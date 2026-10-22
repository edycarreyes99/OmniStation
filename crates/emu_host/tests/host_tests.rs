use emu_host::scheduler::{FrameScheduler, VideoStandard};
use emu_host::session::{EmulationSession, EmulationState};
use emu_vfs::MediaType;

#[test]
fn test_frame_scheduler() {
    let mut scheduler = FrameScheduler::new(VideoStandard::Ntsc60Hz);
    assert_eq!(scheduler.fps(), 60.0);

    let start = scheduler.begin_frame();
    scheduler.end_frame_and_wait(start);
    assert_eq!(scheduler.frame_count(), 1);

    scheduler.set_standard(VideoStandard::Pal50Hz);
    assert!(scheduler.begin_frame() <= std::time::Instant::now());
}

#[test]
fn test_emulation_session_lifecycle() {
    let session = EmulationSession::new(MediaType::Ps3BluRay);
    assert_eq!(session.current_state(), EmulationState::Stopped);

    session.start();
    assert_eq!(session.current_state(), EmulationState::Running);

    session.update_telemetry(59.94, 16.68);
    let telemetry = session.get_telemetry();
    assert_eq!(telemetry.fps, 59.94);
    assert!(telemetry.ppu_usage > 0.0);

    session.pause();
    assert_eq!(session.current_state(), EmulationState::Paused);

    session.resume();
    assert_eq!(session.current_state(), EmulationState::Running);

    session.stop();
    assert_eq!(session.current_state(), EmulationState::Stopped);
}
