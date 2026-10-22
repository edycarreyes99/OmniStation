use emu_audio::drc::DynamicRateController;
use emu_audio::ring_buffer::AudioRingBuffer;

#[test]
fn test_audio_ring_buffer() {
    let (mut producer, mut consumer) = AudioRingBuffer::new(1024);

    let samples = [0.1f32, -0.2, 0.3, -0.4, 0.5, -0.6];
    let written = producer.push_interleaved(&samples);
    assert_eq!(written, 6);

    let mut out = [0.0f32; 6];
    let read = consumer.pop_slice(&mut out);
    assert_eq!(read, 6);
    assert_eq!(out, samples);
}

#[test]
fn test_dynamic_rate_controller() {
    let mut drc = DynamicRateController::new(0.5);

    // Target is 50%. If occupancy is 80% (filling up), ratio should increase above 1.0
    let ratio_high = drc.update(0.8);
    assert!(ratio_high > 1.0);

    // If occupancy is 20% (draining), ratio should decrease below 1.0
    for _ in 0..50 {
        drc.update(0.2);
    }
    let ratio_low = drc.get_ratio();
    assert!(ratio_low < 1.0);
}

#[test]
fn test_audio_player_initialization() {
    // In headless environments, default output device might not be present
    match emu_audio::player::AudioPlayer::new() {
        Ok(mut player) => {
            assert!(player.sample_rate() > 0);
            assert!(player.channels() > 0);
            let samples = [0i16; 512];
            let pushed = player.push_samples_i16(&samples);
            assert_eq!(pushed, 512);
            player.pause();
            player.resume();
        }
        Err(e) => {
            // Expected in headless CI environments without sound card
            eprintln!("AudioPlayer initialization skipped: {e}");
        }
    }
}
