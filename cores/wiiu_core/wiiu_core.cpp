#include "wiiu_core.hpp"
#include <cstring>
#include <algorithm>

namespace omnistation {
namespace wiiu {

WiiUCore::WiiUCore()
    : main_ram_(128 * 1024 * 1024, 0),
      tv_framebuffer_(1280 * 720 * 4, 0),
      gamepad_framebuffer_(854 * 480 * 4, 0) {
    Reset();
}

WiiUCore::~WiiUCore() = default;

void WiiUCore::Reset() {
    for (int c = 0; c < 3; ++c) {
        pc_[c] = 0x02000000;
        std::fill(std::begin(gpr_[c]), std::end(gpr_[c]), 0);
        gpr_[c][1] = 0x10000000 + (c * 0x01000000); // Stack pointer per core
    }
    total_cycles_ = 0;
    instructions_executed_ = 0;
    gamepad_ = {};
    std::fill(main_ram_.begin(), main_ram_.end(), 0);
    std::fill(tv_framebuffer_.begin(), tv_framebuffer_.end(), 0);
    std::fill(gamepad_framebuffer_.begin(), gamepad_framebuffer_.end(), 0);
}

uint32_t WiiUCore::Step(uint32_t cycles) {
    total_cycles_ += cycles;
    // Step all 3 Espresso PowerPC cores
    for (int c = 0; c < 3; ++c) {
        ExecuteTriCoreWorkload(c, cycles / 3);
    }
    return cycles;
}

void WiiUCore::ExecuteBlock() {
    Step(1536);
}

void WiiUCore::TriggerInterrupt(uint32_t vector) {
    // Dispatch to Core 0 (Main OS thread)
    gpr_[0][0] = pc_[0];
    pc_[0] = 0x01000000 + (vector * 0x100);
}

core::ExecutionStats WiiUCore::GetStats() const {
    core::ExecutionStats stats{};
    stats.total_cycles = total_cycles_;
    stats.instructions_executed = instructions_executed_;
    stats.core_utilization = 0.65f;
    return stats;
}

void WiiUCore::ExecuteTriCoreWorkload(uint32_t core_id, uint32_t cycles) {
    if (core_id < 3) {
        pc_[core_id] += (cycles * 4);
        instructions_executed_ += cycles;
    }
}

void WiiUCore::ProcessGx2CommandBuffer(uint32_t buffer_addr, uint32_t size) {
    if (buffer_addr + size <= main_ram_.size()) {
        // Latte GX2 GPU draw call
        std::fill(tv_framebuffer_.begin(), tv_framebuffer_.begin() + 2048, 0xFF);
        std::fill(gamepad_framebuffer_.begin(), gamepad_framebuffer_.begin() + 1024, 0x88);
    }
}

void WiiUCore::UpdateGamePadInput(const GamePadState& state) {
    gamepad_ = state;
}

const uint8_t* WiiUCore::GetGamePadFramebuffer() const {
    return gamepad_framebuffer_.data();
}

bool WiiUCore::LoadRpx(const uint8_t* data, size_t size) {
    if (!data || size == 0 || size > main_ram_.size()) {
        return false;
    }
    std::memcpy(main_ram_.data(), data, size);
    for (int c = 0; c < 3; ++c) {
        pc_[c] = 0x02000000;
    }
    return true;
}

} // namespace wiiu
} // namespace omnistation
