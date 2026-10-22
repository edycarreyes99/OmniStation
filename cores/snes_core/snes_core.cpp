#include "snes_core.hpp"
extern "C" {
#include "lake_snes/snes.h"
}

namespace omnistation {
namespace snes {

SnesCore::SnesCore()
    : framebuffer_(512 * 480 * 4, 0) {
    snes_ = snes_init();
    if (snes_) {
        snes_setPixelFormat(snes_, pixelFormatRGBX);
        snes_setPixels(snes_, framebuffer_.data());
    }
}

SnesCore::~SnesCore() {
    if (snes_) {
        snes_free(snes_);
        snes_ = nullptr;
    }
}

void SnesCore::Reset() {
    if (snes_) {
        snes_reset(snes_, true);
    }
    total_cycles_ = 0;
}

uint32_t SnesCore::Step(uint32_t cycles) {
    if (snes_) {
        snes_runCycles(snes_, static_cast<int>(cycles));
    }
    total_cycles_ += cycles;
    return cycles;
}

void SnesCore::ExecuteBlock() {
    RunFrame();
}

void SnesCore::RunFrame() {
    if (snes_) {
        snes_runFrame(snes_);
        total_cycles_ += 357366; // Approx cycles per frame (NTSC 60Hz)
    }
}

void SnesCore::TriggerInterrupt(uint32_t vector) {
    if (snes_ && vector == 0xFFEA) {
        snes_->inNmi = true;
    }
}

core::ExecutionStats SnesCore::GetStats() const {
    return core::ExecutionStats{
        .total_cycles = total_cycles_,
        .instructions_executed = static_cast<uint32_t>(total_cycles_ / 3),
        .core_utilization = 15.0f,
    };
}

bool SnesCore::LoadRom(const uint8_t* rom_data, size_t size) {
    if (!snes_ || !rom_data || size < 0x8000) return false;
    return snes_loadRom(snes_, rom_data, static_cast<int>(size));
}

void SnesCore::SetAudioSink(std::shared_ptr<core::IAudioSink> sink) {
    audio_sink_ = std::move(sink);
}

void SnesCore::RenderScanline([[maybe_unused]] uint16_t line) {
    // Scanlines are continuously rasterized into framebuffer_ by LakeSnes PPU
}

void SnesCore::SetButtonState(int player, int button, bool pressed) {
    if (snes_) {
        snes_setButtonState(snes_, player, button, pressed);
    }
}

const uint8_t* SnesCore::GetFramebuffer() const {
    return framebuffer_.data();
}

size_t SnesCore::GetFramebufferSize() const {
    return framebuffer_.size();
}

} // namespace snes
} // namespace omnistation

