use std::sync::atomic::{AtomicBool, Ordering};
use std::sync::Arc;

use cpal::traits::{DeviceTrait, HostTrait, StreamTrait};
use cpal::{SampleFormat, Stream, StreamConfig};

use crate::ring_buffer::{AudioConsumer, AudioProducer, AudioRingBuffer};
use crate::AudioError;

pub struct AudioPlayer {
    _stream: Stream,
    producer: AudioProducer,
    sample_rate: u32,
    channels: u16,
    is_paused: Arc<AtomicBool>,
}

impl AudioPlayer {
    /// Initializes the default audio host and output device, building and starting
    /// an active audio playback stream.
    pub fn new() -> Result<Self, AudioError> {
        let host = cpal::default_host();
        let device = host.default_output_device().ok_or_else(|| {
            AudioError::InitFailed("No default audio output device available".to_string())
        })?;

        let supported_config = device.default_output_config().map_err(|e| {
            AudioError::InitFailed(format!("Failed to query default output config: {e}"))
        })?;

        let sample_format = supported_config.sample_format();
        let config: StreamConfig = supported_config.into();
        let sample_rate = config.sample_rate.0;
        let channels = config.channels;

        // Buffer ~500ms of stereo audio to guarantee smooth, jitter-free playback
        let buffer_capacity = (sample_rate as usize * 2).clamp(16384, 65536);
        let (producer, consumer) = AudioRingBuffer::new(buffer_capacity);

        let is_paused = Arc::new(AtomicBool::new(false));
        let is_paused_cb = Arc::clone(&is_paused);

        let err_fn = |err| {
            log::error!("Audio stream playback error: {err}");
        };

        let stream = match sample_format {
            SampleFormat::F32 => Self::build_stream_f32(&device, &config, consumer, is_paused_cb, err_fn)?,
            SampleFormat::I16 => Self::build_stream_i16(&device, &config, consumer, is_paused_cb, err_fn)?,
            SampleFormat::U16 => Self::build_stream_u16(&device, &config, consumer, is_paused_cb, err_fn)?,
            other => {
                return Err(AudioError::InitFailed(format!(
                    "Unsupported output sample format: {other:?}"
                )));
            }
        };

        stream.play().map_err(|e| {
            AudioError::InitFailed(format!("Failed to start cpal playback stream: {e}"))
        })?;

        log::info!(
            "AudioPlayer initialized: {} Hz, {} channels, format: {:?}",
            sample_rate,
            channels,
            sample_format
        );

        Ok(Self {
            _stream: stream,
            producer,
            sample_rate,
            channels,
            is_paused,
        })
    }

    fn build_stream_f32<F>(
        device: &cpal::Device,
        config: &StreamConfig,
        mut consumer: AudioConsumer,
        is_paused: Arc<AtomicBool>,
        err_fn: F,
    ) -> Result<Stream, AudioError>
    where
        F: FnMut(cpal::StreamError) + Send + 'static,
    {
        let channels = config.channels as usize;
        device
            .build_output_stream(
                config,
                move |data: &mut [f32], _: &cpal::OutputCallbackInfo| {
                    if is_paused.load(Ordering::Relaxed) {
                        data.fill(0.0);
                        return;
                    }

                    if channels == 2 {
                        // Standard stereo: pop directly into output buffer
                        consumer.pop_slice(data);
                    } else if channels == 1 {
                        // Mono downmix
                        let mut pair = [0.0f32; 2];
                        for sample in data.iter_mut() {
                            consumer.pop_slice(&mut pair);
                            *sample = (pair[0] + pair[1]) * 0.5;
                        }
                    } else {
                        // Multi-channel (> 2): route stereo to L/R and mute remaining
                        let mut pair = [0.0f32; 2];
                        for frame in data.chunks_exact_mut(channels) {
                            consumer.pop_slice(&mut pair);
                            frame[0] = pair[0];
                            frame[1] = pair[1];
                            for sample in frame.iter_mut().skip(2) {
                                *sample = 0.0;
                            }
                        }
                    }
                },
                err_fn,
                None,
            )
            .map_err(|e| AudioError::InitFailed(format!("Failed to build F32 stream: {e}")))
    }

    fn build_stream_i16<F>(
        device: &cpal::Device,
        config: &StreamConfig,
        mut consumer: AudioConsumer,
        is_paused: Arc<AtomicBool>,
        err_fn: F,
    ) -> Result<Stream, AudioError>
    where
        F: FnMut(cpal::StreamError) + Send + 'static,
    {
        let channels = config.channels as usize;
        let mut temp_stereo = [0.0f32; 2];

        device
            .build_output_stream(
                config,
                move |data: &mut [i16], _: &cpal::OutputCallbackInfo| {
                    if is_paused.load(Ordering::Relaxed) {
                        data.fill(0);
                        return;
                    }

                    if channels == 2 {
                        let (stereo_frames, _) = data.as_chunks_mut::<2>();
                        for frame in stereo_frames {
                            consumer.pop_slice(&mut temp_stereo);
                            frame[0] = (temp_stereo[0] * 32767.0).clamp(-32768.0, 32767.0) as i16;
                            frame[1] = (temp_stereo[1] * 32767.0).clamp(-32768.0, 32767.0) as i16;
                        }
                    } else if channels == 1 {
                        for sample in data.iter_mut() {
                            consumer.pop_slice(&mut temp_stereo);
                            let mono = (temp_stereo[0] + temp_stereo[1]) * 0.5;
                            *sample = (mono * 32767.0).clamp(-32768.0, 32767.0) as i16;
                        }
                    } else {
                        for frame in data.chunks_exact_mut(channels) {
                            consumer.pop_slice(&mut temp_stereo);
                            frame[0] = (temp_stereo[0] * 32767.0).clamp(-32768.0, 32767.0) as i16;
                            frame[1] = (temp_stereo[1] * 32767.0).clamp(-32768.0, 32767.0) as i16;
                            for sample in frame.iter_mut().skip(2) {
                                *sample = 0;
                            }
                        }
                    }
                },
                err_fn,
                None,
            )
            .map_err(|e| AudioError::InitFailed(format!("Failed to build I16 stream: {e}")))
    }

    fn build_stream_u16<F>(
        device: &cpal::Device,
        config: &StreamConfig,
        mut consumer: AudioConsumer,
        is_paused: Arc<AtomicBool>,
        err_fn: F,
    ) -> Result<Stream, AudioError>
    where
        F: FnMut(cpal::StreamError) + Send + 'static,
    {
        let channels = config.channels as usize;
        let mut temp_stereo = [0.0f32; 2];

        device
            .build_output_stream(
                config,
                move |data: &mut [u16], _: &cpal::OutputCallbackInfo| {
                    if is_paused.load(Ordering::Relaxed) {
                        data.fill(32768);
                        return;
                    }

                    if channels == 2 {
                        let (stereo_frames, _) = data.as_chunks_mut::<2>();
                        for frame in stereo_frames {
                            consumer.pop_slice(&mut temp_stereo);
                            let l = (temp_stereo[0] * 32767.0).clamp(-32768.0, 32767.0) + 32768.0;
                            let r = (temp_stereo[1] * 32767.0).clamp(-32768.0, 32767.0) + 32768.0;
                            frame[0] = l as u16;
                            frame[1] = r as u16;
                        }
                    } else {
                        for frame in data.chunks_exact_mut(channels) {
                            consumer.pop_slice(&mut temp_stereo);
                            let l = (temp_stereo[0] * 32767.0).clamp(-32768.0, 32767.0) + 32768.0;
                            let r = (temp_stereo[1] * 32767.0).clamp(-32768.0, 32767.0) + 32768.0;
                            frame[0] = l as u16;
                            frame[1] = r as u16;
                            for sample in frame.iter_mut().skip(2) {
                                *sample = 32768;
                            }
                        }
                    }
                },
                err_fn,
                None,
            )
            .map_err(|e| AudioError::InitFailed(format!("Failed to build U16 stream: {e}")))
    }

    #[inline]
    pub fn sample_rate(&self) -> u32 {
        self.sample_rate
    }

    #[inline]
    pub fn channels(&self) -> u16 {
        self.channels
    }

    /// Pushes interleaved stereo f32 samples [-1.0, 1.0] into the playback buffer.
    pub fn push_samples_f32(&mut self, samples: &[f32]) -> usize {
        self.producer.push_interleaved(samples)
    }

    /// Converts interleaved signed 16-bit PCM samples to f32 and pushes into the playback buffer.
    pub fn push_samples_i16(&mut self, samples: &[i16]) -> usize {
        let mut chunk_f32 = [0.0f32; 512];
        let mut total_written = 0;

        for chunk in samples.chunks(512) {
            for (dest, &src) in chunk_f32[..chunk.len()].iter_mut().zip(chunk.iter()) {
                *dest = (src as f32) / 32768.0;
            }
            let written = self.producer.push_interleaved(&chunk_f32[..chunk.len()]);
            total_written += written;
            if written < chunk.len() {
                break; // Buffer full
            }
        }
        total_written
    }

    pub fn pause(&self) {
        self.is_paused.store(true, Ordering::Relaxed);
    }

    pub fn resume(&self) {
        self.is_paused.store(false, Ordering::Relaxed);
    }
}
