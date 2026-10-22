use spin_sleep::SpinSleeper;
use std::time::{Duration, Instant};

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum VideoStandard {
    Ntsc60Hz, // 59.940059 Hz -> 16.6833 ms
    Pal50Hz,  // 50.000000 Hz -> 20.0000 ms
}

impl VideoStandard {
    pub fn frame_duration(&self) -> Duration {
        match self {
            VideoStandard::Ntsc60Hz => Duration::from_nanos(16_683_333),
            VideoStandard::Pal50Hz => Duration::from_nanos(20_000_000),
        }
    }
}

pub struct FrameScheduler {
    target_standard: VideoStandard,
    sleeper: SpinSleeper,
    last_frame_instant: Instant,
    frame_count: u64,
    current_fps: f32,
    current_frametime_ms: f32,
}

impl FrameScheduler {
    pub fn new(standard: VideoStandard) -> Self {
        Self {
            target_standard: standard,
            sleeper: SpinSleeper::default(),
            last_frame_instant: Instant::now(),
            frame_count: 0,
            current_fps: 60.0,
            current_frametime_ms: 16.67,
        }
    }

    pub fn set_standard(&mut self, standard: VideoStandard) {
        self.target_standard = standard;
    }

    pub fn begin_frame(&mut self) -> Instant {
        Instant::now()
    }

    pub fn end_frame_and_wait(&mut self, frame_start: Instant) {
        let elapsed = frame_start.elapsed();
        let target_duration = self.target_standard.frame_duration();

        if elapsed < target_duration {
            let sleep_needed = target_duration - elapsed;
            self.sleeper.sleep(sleep_needed);
        }

        let full_frame_time = frame_start.elapsed();
        self.current_frametime_ms = full_frame_time.as_secs_f32() * 1000.0;
        if self.current_frametime_ms > 0.0 {
            self.current_fps = 1000.0 / self.current_frametime_ms;
        }

        self.frame_count += 1;
        self.last_frame_instant = Instant::now();
    }

    pub fn fps(&self) -> f32 {
        self.current_fps
    }

    pub fn frametime_ms(&self) -> f32 {
        self.current_frametime_ms
    }

    pub fn frame_count(&self) -> u64 {
        self.frame_count
    }
}
