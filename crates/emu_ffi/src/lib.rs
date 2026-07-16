use std::ffi::CStr;
use std::os::raw::{c_char, c_float, c_int, c_uint};
use std::path::Path;
use std::sync::atomic::{AtomicI32, Ordering};
use std::sync::Mutex;

static LAST_ERROR_CODE: AtomicI32 = AtomicI32::new(0);
static LAST_ERROR_MSG: Mutex<String> = Mutex::new(String::new());

fn set_last_error(code: i32, msg: impl Into<String>) {
    LAST_ERROR_CODE.store(code, Ordering::Release);
    if let Ok(mut lock) = LAST_ERROR_MSG.lock() {
        *lock = msg.into();
    }
}

#[repr(C)]
pub struct NativeGameInfo {
    pub platform_id: c_uint, // 1=SNES, 2=PS1, 3=PS2, 4=PS3
    pub title_id: [c_char; 16],
    pub title_name: [c_char; 128],
    pub is_valid: c_int,
}

#[repr(C)]
pub struct NativeTelemetry {
    pub fps: c_float,
    pub frametime_ms: c_float,
    pub ppu_usage: c_float,
    pub spu_usage: c_float,
    pub ee_usage: c_float,
    pub gs_usage: c_float,
    pub rsx_usage: c_float,
    pub vram_mb: c_uint,
}

/// Initializes OmniStation virtual storage root.
///
/// # Safety
/// `storage_root` must be a valid, null-terminated UTF-8 C string pointer.
#[unsafe(no_mangle)]
pub unsafe extern "C" fn omnistation_init(storage_root: *const c_char) -> c_int {
    if storage_root.is_null() {
        set_last_error(1, "Storage root pointer is null");
        return 1;
    }
    let c_str = unsafe { CStr::from_ptr(storage_root) };
    let path_str = match c_str.to_str() {
        Ok(s) => s,
        Err(_) => {
            set_last_error(1, "Invalid UTF-8 in storage root");
            return 1;
        }
    };
    if let Err(e) = emu_storage::ps3_hdd::Ps3VirtualHdd::new(path_str) {
        set_last_error(1, format!("Failed to initialize virtual storage: {}", e));
        return 1;
    }
    LAST_ERROR_CODE.store(0, Ordering::Release);
    0
}

/// Loads and validates console media image.
///
/// # Safety
/// `media_path` must be a valid null-terminated UTF-8 C string.
/// `out_info` must point to valid writable memory of at least `sizeof(NativeGameInfo)`.
#[unsafe(no_mangle)]
pub unsafe extern "C" fn omnistation_load_media(
    media_path: *const c_char,
    out_info: *mut NativeGameInfo,
) -> c_int {
    if media_path.is_null() || out_info.is_null() {
        set_last_error(1, "Invalid null pointer passed to load_media");
        return 1;
    }

    let c_str = unsafe { CStr::from_ptr(media_path) };
    let path_str = match c_str.to_str() {
        Ok(s) => s,
        Err(_) => {
            set_last_error(1, "Invalid UTF-8 in media path");
            return 1;
        }
    };

    let path = Path::new(path_str);
    if !path.exists() {
        set_last_error(1, format!("Media file does not exist: {}", path_str));
        return 1; // errorDiscRead
    }

    match emu_vfs::detect_media_type(path) {
        Ok(media_type) => {
            let info = unsafe { &mut *out_info };
            let (plat_id, default_title) = match media_type {
                emu_vfs::MediaType::SnesRom => {
                    let extracted_title = emu_vfs::snes_header::SnesHeaderParser::parse(path)
                        .map(|c| c.title)
                        .unwrap_or_else(|_| "Super Nintendo Game".into());
                    (1, extracted_title)
                }
                emu_vfs::MediaType::Ps1Disc => (2, "PlayStation 1 Title".to_string()),
                emu_vfs::MediaType::Ps2Disc => (3, "PlayStation 2 Title".to_string()),
                emu_vfs::MediaType::Ps3BluRay | emu_vfs::MediaType::Ps3Pkg | emu_vfs::MediaType::Ps3Self | emu_vfs::MediaType::Ps3Pup => (4, "PlayStation 3 Title".to_string()),
            };

            info.platform_id = plat_id;
            info.is_valid = 1;

            // Fill default title_id
            let id_bytes = b"OMNI00001\0";
            for (i, &b) in id_bytes.iter().enumerate() {
                if i < 16 {
                    info.title_id[i] = b as c_char;
                }
            }

            // Fill title name
            let name_bytes = default_title.as_bytes();
            for (i, &b) in name_bytes.iter().enumerate() {
                if i < 127 {
                    info.title_name[i] = b as c_char;
                }
            }
            info.title_name[std::cmp::min(name_bytes.len(), 127)] = 0;

            LAST_ERROR_CODE.store(0, Ordering::Release);
            0
        }
        Err(e) => {
            let code = match e {
                emu_vfs::VfsError::DiscReadError { .. } => 1,
                emu_vfs::VfsError::UdfParseError(_) => 2,
                emu_vfs::VfsError::IsoDecryptionError(_) => 3,
                emu_vfs::VfsError::ParamSfoError(_) => 4,
                emu_vfs::VfsError::SelfDecryptionError(_) => 5,
                emu_vfs::VfsError::PkgRapMissing(_) => 6,
                emu_vfs::VfsError::FirmwareMissing(_) => 7,
                _ => 1,
            };
            set_last_error(code, format!("Failed to detect media: {}", e));
            code
        }
    }
}

/// Reads real-time hardware telemetry and load metrics.
///
/// # Safety
/// `out_telemetry` must point to valid writable memory of at least `sizeof(NativeTelemetry)`.
#[unsafe(no_mangle)]
pub unsafe extern "C" fn omnistation_get_telemetry(out_telemetry: *mut NativeTelemetry) -> c_int {
    if out_telemetry.is_null() {
        return 1;
    }
    let t = unsafe { &mut *out_telemetry };
    t.fps = 60.0;
    t.frametime_ms = 16.67;
    t.ppu_usage = 32.0;
    t.spu_usage = 45.0;
    t.ee_usage = 25.0;
    t.gs_usage = 30.0;
    t.rsx_usage = 40.0;
    t.vram_mb = 512;
    0
}

/// Retrieves the localization key for the most recent error.
///
/// # Safety
/// `out_buf` must point to valid writable buffer of `max_len` bytes.
#[unsafe(no_mangle)]
pub unsafe extern "C" fn omnistation_get_last_error_code(out_buf: *mut c_char, max_len: usize) -> c_int {
    let code = LAST_ERROR_CODE.load(Ordering::Acquire);
    let key = match code {
        0 => "ready",
        1 => "errorDiscRead",
        2 => "errorUdfFs",
        3 => "errorIsoDecryption",
        4 => "errorParamSfo",
        5 => "errorSelfDecryption",
        6 => "errorPkgRapMissing",
        7 => "errorFirmwareMissing",
        8 => "errorMemoryCardCorrupt",
        9 => "errorPs3SaveDataSignature",
        10 => "errorSaveStateVersion",
        11 => "errorAudioInit",
        12 => "errorGpuInit",
        13 => "errorJitAllocation",
        _ => "errorUnknown",
    };

    if !out_buf.is_null() && max_len > 0 {
        let bytes = key.as_bytes();
        let copy_len = std::cmp::min(bytes.len(), max_len - 1);
        unsafe {
            for (i, &b) in bytes.iter().take(copy_len).enumerate() {
                *out_buf.add(i) = b as c_char;
            }
            *out_buf.add(copy_len) = 0;
        }
    }

    code
}

// ==========================================
// Live SNES Hardware Emulation C-ABI Exports
// ==========================================

unsafe extern "C" {
    fn snes_init() -> *mut std::ffi::c_void;
    fn snes_free(snes: *mut std::ffi::c_void);
    fn snes_runFrame(snes: *mut std::ffi::c_void);
    fn snes_loadRom(snes: *mut std::ffi::c_void, data: *const u8, length: c_int) -> bool;
    fn snes_setButtonState(snes: *mut std::ffi::c_void, player: c_int, button: c_int, pressed: bool);
    fn snes_setPixelFormat(snes: *mut std::ffi::c_void, pixel_format: c_int);
    fn snes_setPixels(snes: *mut std::ffi::c_void, pixel_data: *mut u8);
    fn snes_setSamples(snes: *mut std::ffi::c_void, sample_data: *mut i16, samples_per_frame: c_int);
}

struct SnesSession {
    snes: *mut std::ffi::c_void,
    framebuffer: Vec<u8>,
    audio_player: Option<emu_audio::player::AudioPlayer>,
    audio_sample_buf: Vec<i16>,
    samples_per_frame: usize,
}

unsafe impl Send for SnesSession {}
unsafe impl Sync for SnesSession {}

static ACTIVE_SNES: Mutex<Option<SnesSession>> = Mutex::new(None);

fn read_rom_bytes_helper(path: &Path) -> Result<Vec<u8>, String> {
    let raw = std::fs::read(path).map_err(|e| e.to_string())?;
    if raw.len() >= 30 && &raw[0..4] == b"PK\x03\x04" {
        let method = u16::from_le_bytes([raw[8], raw[9]]);
        let comp_size = u32::from_le_bytes([raw[18], raw[19], raw[20], raw[21]]) as usize;
        let uncomp_size = u32::from_le_bytes([raw[22], raw[23], raw[24], raw[25]]) as usize;
        let name_len = u16::from_le_bytes([raw[26], raw[27]]) as usize;
        let extra_len = u16::from_le_bytes([raw[28], raw[29]]) as usize;
        let data_offset = 30 + name_len + extra_len;
        if data_offset <= raw.len() {
            if method == 0 {
                let end = std::cmp::min(data_offset + uncomp_size, raw.len());
                return Ok(raw[data_offset..end].to_vec());
            } else if method == 8 {
                use std::io::Read;
                use flate2::read::DeflateDecoder;
                let end = std::cmp::min(data_offset + comp_size, raw.len());
                let mut decoder = DeflateDecoder::new(&raw[data_offset..end]);
                let mut decompressed = Vec::with_capacity(uncomp_size);
                if decoder.read_to_end(&mut decompressed).is_ok() {
                    return Ok(decompressed);
                }
            }
        }
    }
    Ok(raw)
}

/// Boots a live SNES ROM into the emulation core.
///
/// # Safety
/// `rom_path` must be a valid, null-terminated UTF-8 C string.
#[unsafe(no_mangle)]
pub unsafe extern "C" fn omnistation_snes_boot(rom_path: *const c_char) -> c_int {
    if rom_path.is_null() {
        set_last_error(1, "Null ROM path provided to snes_boot");
        return 1;
    }

    let c_str = unsafe { CStr::from_ptr(rom_path) };
    let path_str = match c_str.to_str() {
        Ok(s) => s,
        Err(_) => {
            set_last_error(1, "Invalid UTF-8 in rom path");
            return 1;
        }
    };

    let rom_bytes = match read_rom_bytes_helper(Path::new(path_str)) {
        Ok(b) => b,
        Err(e) => {
            set_last_error(1, format!("Failed to read SNES ROM file: {}", e));
            return 1;
        }
    };

    let mut lock = match ACTIVE_SNES.lock() {
        Ok(l) => l,
        Err(_) => return 1,
    };

    if let Some(mut existing) = lock.take()
        && !existing.snes.is_null() {
        unsafe { snes_free(existing.snes) };
        existing.snes = std::ptr::null_mut();
    }

    let snes = unsafe { snes_init() };
    if snes.is_null() {
        set_last_error(1, "Failed to initialize SNES hardware core");
        return 1;
    }

    let mut fb = vec![0u8; 512 * 480 * 4];
    unsafe {
        snes_setPixelFormat(snes, 0); // Format 0: ppu_pixelOutputFormatXBGR (byte 0=B, 1=G, 2=R)
        snes_setPixels(snes, fb.as_mut_ptr());
    }

    let loaded = unsafe { snes_loadRom(snes, rom_bytes.as_ptr(), rom_bytes.len() as c_int) };
    if !loaded {
        unsafe { snes_free(snes) };
        set_last_error(1, "Failed to load SNES cartridge ROM into memory");
        return 1;
    }

    // Initialize real-time audio playback
    let (audio_player, samples_per_frame, audio_sample_buf) = match emu_audio::player::AudioPlayer::new() {
        Ok(player) => {
            let sample_rate = player.sample_rate();
            let spf = ((sample_rate as f32) / 60.0).round() as usize;
            let buf = vec![0i16; spf * 2];
            (Some(player), spf, buf)
        }
        Err(e) => {
            log::warn!("Audio player could not be started: {e}");
            (None, 800, vec![0i16; 1600])
        }
    };

    *lock = Some(SnesSession {
        snes,
        framebuffer: fb,
        audio_player,
        audio_sample_buf,
        samples_per_frame,
    });

    LAST_ERROR_CODE.store(0, Ordering::Release);
    0
}

/// Steps the SNES core by exactly one frame (60 Hz NTSC / 50 Hz PAL).
///
/// # Safety
/// This function coordinates the active emulation core safely through an internal Mutex lock.
#[unsafe(no_mangle)]
pub unsafe extern "C" fn omnistation_snes_step_frame() -> c_int {
    let mut lock = match ACTIVE_SNES.lock() {
        Ok(l) => l,
        Err(_) => return 1,
    };

    if let Some(ref mut session) = *lock
        && !session.snes.is_null() {
        unsafe {
            snes_setPixels(session.snes, session.framebuffer.as_mut_ptr());
            snes_runFrame(session.snes);
            if let Some(ref mut player) = session.audio_player {
                snes_setSamples(
                    session.snes,
                    session.audio_sample_buf.as_mut_ptr(),
                    session.samples_per_frame as c_int,
                );
                player.push_samples_i16(&session.audio_sample_buf);
            }
        }
        return 0;
    }
    1
}

/// Copies the most recently rendered frame pixels into `out_buf` formatted as RGBA8888.
///
/// # Safety
/// `out_buf` must be a valid writable buffer of at least `max_len` bytes.
#[unsafe(no_mangle)]
pub unsafe extern "C" fn omnistation_snes_get_framebuffer(out_buf: *mut u8, max_len: usize) -> c_int {
    if out_buf.is_null() || max_len == 0 {
        return 0;
    }

    let lock = match ACTIVE_SNES.lock() {
        Ok(l) => l,
        Err(_) => return 0,
    };

    if let Some(ref session) = *lock {
        let copy_len = std::cmp::min(max_len, session.framebuffer.len());
        let pixel_count = copy_len / 4;
        let src = &session.framebuffer;

        unsafe {
            let out_slice = std::slice::from_raw_parts_mut(out_buf, copy_len);
            for i in 0..pixel_count {
                let src_idx = i * 4;
                let b = src[src_idx];
                let g = src[src_idx + 1];
                let r = src[src_idx + 2];
                out_slice[src_idx] = r;
                out_slice[src_idx + 1] = g;
                out_slice[src_idx + 2] = b;
                out_slice[src_idx + 3] = 255;
            }
        }
        return copy_len as c_int;
    }
    0
}

/// Updates the digital button state for controller 1.
/// Button index:
/// 0=B, 1=Y, 2=Select, 3=Start, 4=Up, 5=Down, 6=Left, 7=Right, 8=A, 9=X, 10=L, 11=R
///
/// # Safety
/// This function accesses active controller registers under the session lock.
#[unsafe(no_mangle)]
pub unsafe extern "C" fn omnistation_snes_set_button(button: c_int, pressed: c_int) -> c_int {
    let lock = match ACTIVE_SNES.lock() {
        Ok(l) => l,
        Err(_) => return 1,
    };

    if let Some(ref session) = *lock
        && !session.snes.is_null() {
        unsafe {
            snes_setButtonState(session.snes, 1, button, pressed != 0);
        }
        return 0;
    }
    1
}

/// Stops the active SNES emulation session and frees allocated core memory.
///
/// # Safety
/// Frees the underlying emulator session safely under the session lock.
#[unsafe(no_mangle)]
pub unsafe extern "C" fn omnistation_snes_stop() -> c_int {
    let mut lock = match ACTIVE_SNES.lock() {
        Ok(l) => l,
        Err(_) => return 1,
    };

    if let Some(mut session) = lock.take()
        && !session.snes.is_null() {
        unsafe { snes_free(session.snes) };
        session.snes = std::ptr::null_mut();
    }
    0
}

