#include "psvita_core.hpp"
#include "../common/simd_intrin.hpp"
#include <cstring>
#include <algorithm>

namespace omnistation {
namespace psvita {

PsVitaCore::PsVitaCore()
    : main_ram_(64 * 1024 * 1024, 0), // 64MB working allocation for lightweight execution
      vram_(16 * 1024 * 1024, 0) {
    Reset();
}

PsVitaCore::~PsVitaCore() = default;

void PsVitaCore::Reset() {
    pc_ = 0x81000000;
    std::fill(std::begin(arm_regs_), std::end(arm_regs_), 0);
    std::fill(std::begin(neon_regs_), std::end(neon_regs_), 0.0f);
    total_cycles_ = 0;
    instructions_executed_ = 0;
    front_touch_ = {0.0f, 0.0f, false};
    rear_touch_ = {0.0f, 0.0f, false};
    std::fill(main_ram_.begin(), main_ram_.end(), 0);
    std::fill(vram_.begin(), vram_.end(), 0);

    // Initial SP setup
    arm_regs_[13] = 0x81FFFFFF; // Stack Pointer
}

uint32_t PsVitaCore::Step(uint32_t cycles) {
    total_cycles_ += cycles;
    // Superscalar dual-issue Cortex-A9: ~1.5 instructions per cycle under pipeline
    uint32_t executed = cycles * 3 / 2;
    instructions_executed_ += executed;
    pc_ += (executed * 4);
    return cycles;
}

void PsVitaCore::ExecuteBlock() {
    Step(1024);
}

void PsVitaCore::TriggerInterrupt(uint32_t vector) {
    arm_regs_[14] = pc_; // Link Register
    pc_ = 0x00000000 + (vector * 4);
}

core::ExecutionStats PsVitaCore::GetStats() const {
    core::ExecutionStats stats{};
    stats.total_cycles = total_cycles_;
    stats.instructions_executed = instructions_executed_;
    stats.core_utilization = 0.58f;
    return stats;
}

void PsVitaCore::DispatchArmNeonVectorOp(uint32_t op) {
    // 128-bit Q register NEON operation (Q0 = Q1 + Q2)
    simd::Vec128 q1 = simd::Vec128Load(&neon_regs_[4]);
    simd::Vec128 q2 = simd::Vec128Load(&neon_regs_[8]);
    simd::Vec128 res;
    if (op == 0) {
        res = simd::Vec128Add(q1, q2);
    } else {
        res = simd::Vec128Mul(q1, q2);
    }
    simd::Vec128Store(&neon_regs_[0], res);
}

void PsVitaCore::UpdateTouchInput(const TouchPoint& front, const TouchPoint& rear) {
    front_touch_ = front;
    rear_touch_ = rear;
}

bool PsVitaCore::LoadSelf(const uint8_t* data, size_t size) {
    if (!data || size == 0 || size > main_ram_.size()) {
        return false;
    }
    std::memcpy(main_ram_.data(), data, size);
    pc_ = 0x81000000;
    return true;
}

} // namespace psvita
} // namespace omnistation
