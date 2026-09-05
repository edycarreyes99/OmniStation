#include <stdint.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <ctype.h>

#if defined(__ANDROID__)
#include <android/log.h>
#include <aaudio/AAudio.h>
#define LOG_TAG "OmniStationFFI"
#define LOGI(...) __android_log_print(ANDROID_LOG_INFO, LOG_TAG, __VA_ARGS__)
#define LOGE(...) __android_log_print(ANDROID_LOG_ERROR, LOG_TAG, __VA_ARGS__)
#define LOGW(...) __android_log_print(ANDROID_LOG_WARN, LOG_TAG, __VA_ARGS__)
#else
#define LOGI(...) printf(__VA_ARGS__)
#define LOGE(...) fprintf(stderr, __VA_ARGS__)
#define LOGW(...) printf(__VA_ARGS__)
#endif

// LakeSnes Hardware Core C-ABI Declarations
typedef struct Snes Snes;

Snes* snes_init(void);
void snes_free(Snes* snes);
void snes_runFrame(Snes* snes);
bool snes_loadRom(Snes* snes, const uint8_t* data, int length);
void snes_setButtonState(Snes* snes, int player, int button, bool pressed);
void snes_setPixelFormat(Snes* snes, int pixelFormat);
void snes_setPixels(Snes* snes, uint8_t* pixelData);
void snes_setSamples(Snes* snes, int16_t* sampleData, int samplesPerFrame);

#define EXPORT __attribute__((visibility("default")))

typedef struct {
    uint32_t platform_id;
    char title_id[16];
    char title_name[128];
    int32_t is_valid;
} NativeGameInfo;

typedef struct {
    float fps;
    float frametime_ms;
    float ppu_usage;
    float spu_usage;
    float ee_usage;
    float gs_usage;
    float rsx_usage;
    uint32_t vram_mb;
} NativeTelemetry;

static char g_last_error[256] = {0};

static void set_last_error(const char* err) {
    if (err) {
        strncpy(g_last_error, err, sizeof(g_last_error) - 1);
        g_last_error[sizeof(g_last_error) - 1] = '\0';
    } else {
        g_last_error[0] = '\0';
    }
}

// Active SNES emulation state
static Snes* g_snes = NULL;
static uint8_t* g_framebuffer = NULL; // 512 * 480 * 4
static int16_t* g_audio_samples = NULL;
static int g_samples_per_frame = 800; // 48kHz / 60fps

#if defined(__ANDROID__)
static AAudioStream* g_aaudio_stream = NULL;

static void init_aaudio() {
    if (g_aaudio_stream) return;

    AAudioStreamBuilder* builder = NULL;
    aaudio_result_t result = AAudio_createStreamBuilder(&builder);
    if (result != AAUDIO_OK) {
        LOGW("Failed to create AAudio stream builder: %d", result);
        return;
    }

    AAudioStreamBuilder_setFormat(builder, AAUDIO_FORMAT_PCM_I16);
    AAudioStreamBuilder_setChannelCount(builder, 2);
    AAudioStreamBuilder_setSampleRate(builder, 48000);
    AAudioStreamBuilder_setPerformanceMode(builder, AAUDIO_PERFORMANCE_MODE_LOW_LATENCY);
    AAudioStreamBuilder_setSharingMode(builder, AAUDIO_SHARING_MODE_SHARED);

    result = AAudioStreamBuilder_openStream(builder, &g_aaudio_stream);
    AAudioStreamBuilder_delete(builder);

    if (result != AAUDIO_OK) {
        LOGW("Failed to open AAudio stream: %d", result);
        g_aaudio_stream = NULL;
        return;
    }

    result = AAudioStream_requestStart(g_aaudio_stream);
    if (result != AAUDIO_OK) {
        LOGW("Failed to start AAudio stream: %d", result);
        AAudioStream_close(g_aaudio_stream);
        g_aaudio_stream = NULL;
        return;
    }

    LOGI("AAudio stream initialized successfully (48000 Hz, 2ch, Low-Latency)");
}

static void stop_aaudio() {
    if (g_aaudio_stream) {
        AAudioStream_requestStop(g_aaudio_stream);
        AAudioStream_close(g_aaudio_stream);
        g_aaudio_stream = NULL;
    }
}
#endif

EXPORT int32_t omnistation_init(const char* storage_root) {
    LOGI("omnistation_init called with root: %s", storage_root ? storage_root : "null");
    set_last_error(NULL);
    return 0;
}

EXPORT int32_t omnistation_load_media(const char* media_path, NativeGameInfo* out_info) {
    if (!media_path || !out_info) {
        set_last_error("Invalid null pointer in omnistation_load_media");
        return 1;
    }

    FILE* f = fopen(media_path, "rb");
    if (!f) {
        set_last_error("Failed to open media file");
        return 1;
    }

    fseek(f, 0, SEEK_END);
    long fsize = ftell(f);
    fseek(f, 0, SEEK_SET);

    memset(out_info, 0, sizeof(NativeGameInfo));

    // Determine extension
    const char* ext = strrchr(media_path, '.');
    char ext_lower[16] = {0};
    if (ext) {
        size_t len = strlen(ext + 1);
        if (len < sizeof(ext_lower)) {
            for (size_t i = 0; i < len; i++) {
                ext_lower[i] = (char)tolower((unsigned char)ext[1 + i]);
            }
        }
    }

    if (strcmp(ext_lower, "sfc") == 0 || strcmp(ext_lower, "smc") == 0 || strcmp(ext_lower, "msc") == 0) {
        out_info->platform_id = 1; // SNES
        strncpy(out_info->title_id, "OMNI-SNES\0", 16);

        // Try reading internal title from header (0x7FC0 for LoROM or 0xFFC0 for HiROM)
        char rom_title[22] = {0};
        bool found_title = false;

        // Check LoROM title offset
        if (fsize >= 0x7FD5) {
            fseek(f, 0x7FC0, SEEK_SET);
            if (fread(rom_title, 1, 21, f) == 21) {
                // Verify printable
                bool printable = true;
                for (int i = 0; i < 21; i++) {
                    if (rom_title[i] != 0 && (rom_title[i] < 32 || rom_title[i] > 126)) {
                        printable = false;
                        break;
                    }
                }
                if (printable && strlen(rom_title) > 2) {
                    found_title = true;
                }
            }
        }

        // Check HiROM title offset if LoROM didn't give clean title
        if (!found_title && fsize >= 0xFFD5) {
            fseek(f, 0xFFC0, SEEK_SET);
            if (fread(rom_title, 1, 21, f) == 21) {
                bool printable = true;
                for (int i = 0; i < 21; i++) {
                    if (rom_title[i] != 0 && (rom_title[i] < 32 || rom_title[i] > 126)) {
                        printable = false;
                        break;
                    }
                }
                if (printable && strlen(rom_title) > 2) {
                    found_title = true;
                }
            }
        }

        if (found_title) {
            // Trim trailing spaces
            for (int i = 20; i >= 0 && (rom_title[i] == ' ' || rom_title[i] == '\0'); i--) {
                rom_title[i] = '\0';
            }
            strncpy(out_info->title_name, rom_title, 127);
        } else {
            // Fallback to filename
            const char* base = strrchr(media_path, '/');
            base = base ? base + 1 : media_path;
            strncpy(out_info->title_name, base, 127);
            char* dot = strrchr(out_info->title_name, '.');
            if (dot) *dot = '\0';
        }
    } else if (strcmp(ext_lower, "pkg") == 0 || strcmp(ext_lower, "self") == 0) {
        out_info->platform_id = 4; // PS3
        strncpy(out_info->title_id, "OMNI-PS3\0", 16);
        strncpy(out_info->title_name, "PlayStation 3 Game", 127);
    } else {
        if (fsize > 700 * 1024 * 1024) {
            out_info->platform_id = 3; // PS2
            strncpy(out_info->title_id, "OMNI-PS2\0", 16);
            strncpy(out_info->title_name, "PlayStation 2 Game", 127);
        } else {
            out_info->platform_id = 2; // PS1
            strncpy(out_info->title_id, "OMNI-PS1\0", 16);
            strncpy(out_info->title_name, "PlayStation 1 Game", 127);
        }
    }

    fclose(f);
    out_info->is_valid = 1;
    set_last_error(NULL);
    LOGI("load_media success: %s (Platform ID: %u)", out_info->title_name, out_info->platform_id);
    return 0;
}

EXPORT int32_t omnistation_get_telemetry(NativeTelemetry* out_telemetry) {
    if (!out_telemetry) return 1;
    out_telemetry->fps = 60.0f;
    out_telemetry->frametime_ms = 16.67f;
    out_telemetry->ppu_usage = 32.0f;
    out_telemetry->spu_usage = 45.0f;
    out_telemetry->ee_usage = 25.0f;
    out_telemetry->gs_usage = 30.0f;
    out_telemetry->rsx_usage = 40.0f;
    out_telemetry->vram_mb = 512;
    return 0;
}

EXPORT int32_t omnistation_get_last_error_code(char* out_buf, size_t max_len) {
    if (!out_buf || max_len == 0) return 0;
    strncpy(out_buf, g_last_error, max_len - 1);
    out_buf[max_len - 1] = '\0';
    return 0;
}

EXPORT int32_t omnistation_snes_boot(const char* rom_path) {
    LOGI("omnistation_snes_boot called for: %s", rom_path ? rom_path : "null");
    if (!rom_path) {
        set_last_error("ROM path pointer is null");
        return 1;
    }

    FILE* f = fopen(rom_path, "rb");
    if (!f) {
        set_last_error("ROM file could not be opened on device storage");
        LOGE("Failed to open ROM at: %s", rom_path);
        return 1;
    }

    fseek(f, 0, SEEK_END);
    long rom_size = ftell(f);
    fseek(f, 0, SEEK_SET);

    if (rom_size <= 0 || rom_size > 16 * 1024 * 1024) {
        fclose(f);
        set_last_error("Invalid ROM file size");
        return 1;
    }

    uint8_t* rom_data = (uint8_t*)malloc(rom_size);
    if (!rom_data) {
        fclose(f);
        set_last_error("Out of memory allocating ROM buffer");
        return 1;
    }

    size_t read_bytes = fread(rom_data, 1, rom_size, f);
    fclose(f);

    if ((long)read_bytes != rom_size) {
        free(rom_data);
        set_last_error("Incomplete read of ROM file");
        return 1;
    }

    // Clean up any existing session
    if (g_snes) {
        snes_free(g_snes);
        g_snes = NULL;
    }
    if (!g_framebuffer) {
        g_framebuffer = (uint8_t*)calloc(1, 512 * 480 * 4);
    }
    if (!g_audio_samples) {
        g_samples_per_frame = 800; // 48000 Hz / 60
        g_audio_samples = (int16_t*)calloc(g_samples_per_frame * 2, sizeof(int16_t));
    }

    g_snes = snes_init();
    if (!g_snes) {
        free(rom_data);
        set_last_error("Failed to initialize LakeSnes hardware core");
        return 1;
    }

    snes_setPixelFormat(g_snes, 0); // format 0 = XBGR
    snes_setPixels(g_snes, g_framebuffer);

    bool loaded = snes_loadRom(g_snes, rom_data, (int)rom_size);
    free(rom_data);

    if (!loaded) {
        snes_free(g_snes);
        g_snes = NULL;
        set_last_error("LakeSnes failed to parse cartridge ROM header or layout");
        return 1;
    }

#if defined(__ANDROID__)
    init_aaudio();
#endif

    set_last_error(NULL);
    LOGI("LakeSnes core successfully booted for: %s", rom_path);
    return 0;
}

EXPORT int32_t omnistation_snes_step_frame(void) {
    if (!g_snes || !g_framebuffer) return 1;

    snes_setPixels(g_snes, g_framebuffer);
    snes_runFrame(g_snes);

    if (g_audio_samples) {
        snes_setSamples(g_snes, g_audio_samples, g_samples_per_frame);

#if defined(__ANDROID__)
        if (g_aaudio_stream) {
            // Write samples non-blocking with 0 timeout
            AAudioStream_write(g_aaudio_stream, g_audio_samples, g_samples_per_frame, 0);
        }
#endif
    }

    return 0;
}

EXPORT int32_t omnistation_snes_get_framebuffer(uint8_t* out_buf, size_t max_len) {
    if (!out_buf || !g_framebuffer || max_len == 0) return 0;

    size_t copy_len = 512 * 480 * 4;
    if (copy_len > max_len) copy_len = max_len;

    size_t pixel_count = copy_len / 4;
    // Format conversion from XBGR (LakeSnes) to RGBA8888 (Flutter / Skia / Impeller)
    for (size_t i = 0; i < pixel_count; i++) {
        size_t src_idx = i * 4;
        uint8_t b = g_framebuffer[src_idx];
        uint8_t g = g_framebuffer[src_idx + 1];
        uint8_t r = g_framebuffer[src_idx + 2];

        out_buf[src_idx] = r;
        out_buf[src_idx + 1] = g;
        out_buf[src_idx + 2] = b;
        out_buf[src_idx + 3] = 255;
    }

    return (int32_t)copy_len;
}

EXPORT int32_t omnistation_snes_set_button(int32_t button, int32_t pressed) {
    if (!g_snes) return 1;
    snes_setButtonState(g_snes, 1, button, pressed != 0);
    return 0;
}

EXPORT int32_t omnistation_snes_stop(void) {
    LOGI("omnistation_snes_stop invoked");
#if defined(__ANDROID__)
    stop_aaudio();
#endif
    if (g_snes) {
        snes_free(g_snes);
        g_snes = NULL;
    }
    if (g_framebuffer) {
        free(g_framebuffer);
        g_framebuffer = NULL;
    }
    if (g_audio_samples) {
        free(g_audio_samples);
        g_audio_samples = NULL;
    }
    set_last_error(NULL);
    return 0;
}
