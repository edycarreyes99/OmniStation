use std::ffi::CString;
use std::path::Path;

#[test]
fn test_snes_ffi_lifecycle() {
    let smw_path = Path::new("../../Super Mario World (USA).sfc");
    if !smw_path.exists() {
        return;
    }

    let c_path = CString::new(smw_path.to_str().unwrap()).unwrap();
    unsafe {
        let boot_res = emu_ffi::omnistation_snes_boot(c_path.as_ptr());
        assert_eq!(boot_res, 0, "Failed to boot Super Mario World via FFI");

        // Run 10 frames
        for _ in 0..10 {
            let step_res = emu_ffi::omnistation_snes_step_frame();
            assert_eq!(step_res, 0);
        }

        // Test button press (Start = button 3)
        let btn_res = emu_ffi::omnistation_snes_set_button(3, 1);
        assert_eq!(btn_res, 0);

        let mut fb = vec![0u8; 512 * 480 * 4];
        let bytes_copied = emu_ffi::omnistation_snes_get_framebuffer(fb.as_mut_ptr(), fb.len());
        assert_eq!(bytes_copied, (512 * 480 * 4) as std::os::raw::c_int);

        let stop_res = emu_ffi::omnistation_snes_stop();
        assert_eq!(stop_res, 0);
    }
}
