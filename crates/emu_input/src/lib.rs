pub mod controller;
pub mod touch_memory;

use thiserror::Error;

#[derive(Error, Debug)]
pub enum InputError {
    #[error("Controller device error: {0}")]
    DeviceError(String),
}
