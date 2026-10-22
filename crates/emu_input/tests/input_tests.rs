use emu_input::controller::GamepadState;
use emu_input::touch_memory::AtomicTouchBuffer;

#[test]
fn test_atomic_touch_memory() {
    let buffer = AtomicTouchBuffer::new();

    // Write button bitmask + L2/R2 triggers
    buffer.write_buttons_atomic(0x000F, 128, 255);
    // Write analog sticks (-1.0 to 1.0)
    buffer.write_sticks_atomic(0.5, -0.5, 1.0, -1.0);

    let (buttons, l2, r2, lx, ly, rx, ry) = buffer.read_state();
    assert_eq!(buttons, 0x000F);
    assert_eq!(l2, 128);
    assert_eq!(r2, 255);
    assert!((lx - 0.5).abs() < 0.01);
    assert!((ly - (-0.5)).abs() < 0.01);
    assert!((rx - 1.0).abs() < 0.01);
    assert!((ry - (-1.0)).abs() < 0.01);
}

#[test]
fn test_gamepad_defaults() {
    let state = GamepadState::default();
    assert_eq!(state.motion.accel_y, 9.81);
    assert!(!state.buttons.ps_home);
}
