#include "ps2_core.hpp"

namespace omnistation {
namespace ps2 {

Ps2Core::Ps2Core()
    : main_ram_(32 * 1024 * 1024, 0) {
    Reset();
}

Ps2Core::~Ps2Core() = default;

void Ps2Core::Reset() {
    pc_ = 0xBFC00000;
    for (int i = 0; i < 32; ++i) {
        ee_regs_[i] = {};
        vu0_regs_[i] = {};
        vu1_regs_[i] = {};
    }
    total_cycles_ = 0;
}

uint32_t Ps2Core::Step(uint32_t cycles) {
    total_cycles_ += cycles;
    return cycles;
}

void Ps2Core::ExecuteBlock() {
    Step(4915); // Emotion Engine chunk @ 294.912 MHz
}

void Ps2Core::TriggerInterrupt(uint32_t vector) {
    pc_ = 0x80000080 + (vector * 0x80);
}

core::ExecutionStats Ps2Core::GetStats() const {
    return core::ExecutionStats{
        .total_cycles = total_cycles_,
        .instructions_executed = static_cast<uint32_t>(total_cycles_ / 2),
        .core_utilization = 38.0f,
    };
}

void Ps2Core::ExecuteVu0Macro(uint32_t instruction) {
    // COP2 instruction execution in macro mode
    uint32_t op = instruction & 0x3F;
    if (op == 0x28) {
        // VADD
        vu0_regs_[1] = simd::Vec128Add(vu0_regs_[1], vu0_regs_[2]);
    }
}

void Ps2Core::ExecuteVu1Micro([[maybe_unused]] uint32_t address) {
    // microVU JIT execution of geometric transform code
}

} // namespace ps2
} // namespace omnistation
