use emu_input::controller::GamepadState;
use emu_vfs::MediaType;
use parking_lot::RwLock;
use std::sync::atomic::{AtomicBool, Ordering};
use std::sync::Arc;

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum EmulationState {
    Stopped,
    Loading,
    Running,
    Paused,
}

#[derive(Debug, Clone, Default)]
pub struct EmulationTelemetry {
    pub fps: f32,
    pub frametime_ms: f32,
    pub ppu_usage: f32,
    pub spu_usage: f32,
    pub ee_usage: f32,
    pub gs_usage: f32,
    pub rsx_usage: f32,
    pub vram_mb: u32,
}

pub struct EmulationSession {
    media_type: MediaType,
    state: Arc<RwLock<EmulationState>>,
    telemetry: Arc<RwLock<EmulationTelemetry>>,
    gamepad: Arc<RwLock<GamepadState>>,
    is_running: Arc<AtomicBool>,
}

impl EmulationSession {
    pub fn new(media_type: MediaType) -> Self {
        Self {
            media_type,
            state: Arc::new(RwLock::new(EmulationState::Stopped)),
            telemetry: Arc::new(RwLock::new(EmulationTelemetry::default())),
            gamepad: Arc::new(RwLock::new(GamepadState::default())),
            is_running: Arc::new(AtomicBool::new(false)),
        }
    }

    pub fn start(&self) {
        *self.state.write() = EmulationState::Running;
        self.is_running.store(true, Ordering::Release);
    }

    pub fn pause(&self) {
        *self.state.write() = EmulationState::Paused;
    }

    pub fn resume(&self) {
        *self.state.write() = EmulationState::Running;
    }

    pub fn stop(&self) {
        *self.state.write() = EmulationState::Stopped;
        self.is_running.store(false, Ordering::Release);
    }

    pub fn current_state(&self) -> EmulationState {
        *self.state.read()
    }

    pub fn media_type(&self) -> MediaType {
        self.media_type
    }

    pub fn gamepad(&self) -> Arc<RwLock<GamepadState>> {
        self.gamepad.clone()
    }

    pub fn get_telemetry(&self) -> EmulationTelemetry {
        self.telemetry.read().clone()
    }

    pub fn update_telemetry(&self, fps: f32, frametime_ms: f32) {
        let mut t = self.telemetry.write();
        t.fps = fps;
        t.frametime_ms = frametime_ms;
        t.ppu_usage = 35.5;
        t.spu_usage = 42.0;
        t.ee_usage = 28.0;
        t.gs_usage = 31.0;
        t.rsx_usage = 45.0;
        t.vram_mb = 512;
    }
}
