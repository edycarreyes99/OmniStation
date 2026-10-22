use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Copy, PartialEq, Eq, Default, Serialize, Deserialize)]
pub struct DigitalButtons {
    pub dpad_up: bool,
    pub dpad_down: bool,
    pub dpad_left: bool,
    pub dpad_right: bool,
    pub cross: bool,
    pub circle: bool,
    pub square: bool,
    pub triangle: bool,
    pub l1: bool,
    pub r1: bool,
    pub l2: bool,
    pub r2: bool,
    pub l3: bool,
    pub r3: bool,
    pub start: bool,
    pub select: bool,
    pub ps_home: bool,
}

#[derive(Debug, Clone, Copy, PartialEq, Serialize, Deserialize)]
pub struct AnalogAxes {
    pub left_stick_x: f32,  // -1.0 to 1.0
    pub left_stick_y: f32,
    pub right_stick_x: f32,
    pub right_stick_y: f32,
    pub l2_pressure: f32,   // 0.0 to 1.0
    pub r2_pressure: f32,
}

impl Default for AnalogAxes {
    fn default() -> Self {
        Self {
            left_stick_x: 0.0,
            left_stick_y: 0.0,
            right_stick_x: 0.0,
            right_stick_y: 0.0,
            l2_pressure: 0.0,
            r2_pressure: 0.0,
        }
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Serialize, Deserialize)]
pub struct SixaxisMotion {
    pub gyro_x: f32,
    pub gyro_y: f32,
    pub gyro_z: f32,
    pub accel_x: f32,
    pub accel_y: f32,
    pub accel_z: f32,
}

impl Default for SixaxisMotion {
    fn default() -> Self {
        Self {
            gyro_x: 0.0,
            gyro_y: 0.0,
            gyro_z: 0.0,
            accel_x: 0.0,
            accel_y: 9.81, // 1G standard gravity
            accel_z: 0.0,
        }
    }
}

#[derive(Debug, Clone, Copy, Default, Serialize, Deserialize)]
pub struct GamepadState {
    pub buttons: DigitalButtons,
    pub axes: AnalogAxes,
    pub motion: SixaxisMotion,
    pub rumble_small: u8, // 0-255 high frequency motor
    pub rumble_large: u8, // 0-255 low frequency motor
}
