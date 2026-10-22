use std::sync::atomic::{AtomicU32, Ordering};

pub struct AtomicTouchBuffer {
    // Packed bitfields:
    // bits 0-15: digital buttons
    // bits 16-23: L2 pressure (0-255)
    // bits 24-31: R2 pressure (0-255)
    buttons_packed: AtomicU32,
    
    // Analog sticks: packed as two i16s (-32768 to 32767)
    left_stick_packed: AtomicU32,
    right_stick_packed: AtomicU32,
}

impl Default for AtomicTouchBuffer {
    fn default() -> Self {
        Self::new()
    }
}

impl AtomicTouchBuffer {
    pub const fn new() -> Self {
        Self {
            buttons_packed: AtomicU32::new(0),
            left_stick_packed: AtomicU32::new(0),
            right_stick_packed: AtomicU32::new(0),
        }
    }

    #[inline(always)]
    pub fn write_buttons_atomic(&self, buttons_mask: u16, l2: u8, r2: u8) {
        let val = (buttons_mask as u32) | ((l2 as u32) << 16) | ((r2 as u32) << 24);
        self.buttons_packed.store(val, Ordering::Release);
    }

    #[inline(always)]
    pub fn write_sticks_atomic(&self, lx: f32, ly: f32, rx: f32, ry: f32) {
        let lx_i16 = (lx * 32767.0) as i16;
        let ly_i16 = (ly * 32767.0) as i16;
        let rx_i16 = (rx * 32767.0) as i16;
        let ry_i16 = (ry * 32767.0) as i16;

        let left = (lx_i16 as u16 as u32) | ((ly_i16 as u16 as u32) << 16);
        let right = (rx_i16 as u16 as u32) | ((ry_i16 as u16 as u32) << 16);

        self.left_stick_packed.store(left, Ordering::Release);
        self.right_stick_packed.store(right, Ordering::Release);
    }

    #[inline(always)]
    pub fn read_state(&self) -> (u16, u8, u8, f32, f32, f32, f32) {
        let btn_val = self.buttons_packed.load(Ordering::Acquire);
        let l_stick = self.left_stick_packed.load(Ordering::Acquire);
        let r_stick = self.right_stick_packed.load(Ordering::Acquire);

        let buttons = (btn_val & 0xFFFF) as u16;
        let l2 = ((btn_val >> 16) & 0xFF) as u8;
        let r2 = ((btn_val >> 24) & 0xFF) as u8;

        let lx = (l_stick as u16 as i16) as f32 / 32767.0;
        let ly = ((l_stick >> 16) as u16 as i16) as f32 / 32767.0;
        let rx = (r_stick as u16 as i16) as f32 / 32767.0;
        let ry = ((r_stick >> 16) as u16 as i16) as f32 / 32767.0;

        (buttons, l2, r2, lx, ly, rx, ry)
    }
}
