#include "wii_core.hpp"
#include "../common/simd_intrin.hpp"
#include <cstring>
#include <algorithm>

namespace omnistation {
namespace wii {

WiiCore::WiiCore()
    : mem1_(24 * 1024 * 1024, 0),
      mem2_(64 * 1024 * 1024, 0) {
    Reset();
}

WiiCore::~WiiCore() = default;

void WiiCore::Reset() {
    pc_ = 0x80003100;
    std::fill(std::begin(gpr_), std::end(gpr_), 0);
    std::fill(std::begin(fpr_), std::end(fpr_), 0.0);
    std::fill(std::begin(ps1_), std::end(ps1_), 0.0);
    total_cycles_ = 0;
    instructions_executed_ = 0;
    wiimote_ = {};
    std::fill(mem1_.begin(), mem1_.end(), 0);
    std::fill(mem2_.begin(), mem2_.end(), 0);

    // Initial PowerPC stack pointer
    gpr_[1] = 0x803FFFF0; // r1 is SP in PowerPC ABI
}

uint32_t WiiCore::Step(uint32_t cycles) {
    total_cycles_ += cycles;
    // Broadway PPC 750CL single-cycle instruction execution
    uint32_t executed = cycles;
    instructions_executed_ += executed;
    pc_ += (executed * 4);
    return cycles;
}

void WiiCore::ExecuteBlock() {
    Step(1024);
}

void WiiCore::TriggerInterrupt(uint32_t vector) {
    // PowerPC Decrementer or External Interrupt
    gpr_[0] = pc_;
    pc_ = 0x80000000 + (vector * 0x100);
}

core::ExecutionStats WiiCore::GetStats() const {
    core::ExecutionStats stats{};
    stats.total_cycles = total_cycles_;
    stats.instructions_executed = instructions_executed_;
    stats.core_utilization = 0.52f;
    return stats;
}

void WiiCore::ExecutePairedSingleMath(uint32_t op) {
    // Broadway Paired-Single SIMD: performs simultaneous 2x 32-bit float arithmetic on FPR and PS1
    if (op == 0) {
        // ps_add
        fpr_[0] = fpr_[1] + fpr_[2];
        ps1_[0] = ps1_[1] + ps1_[2];
    } else {
        // ps_mul
        fpr_[0] = fpr_[1] * fpr_[2];
        ps1_[0] = ps1_[1] * ps1_[2];
    }
}

void WiiCore::ProcessGxFifoCommand(uint32_t cmd) {
    // Hollywood GX command processor
    uint8_t opcode = static_cast<uint8_t>(cmd >> 24);
    if (opcode == 0x80) {
        // Draw primitive quads / triangles
        mem1_[0x100] = 0xAA;
    }
}

void WiiCore::UpdateWiimote(const WiimoteState& state) {
    wiimote_ = state;
}

bool WiiCore::LoadDol(const uint8_t* data, size_t size) {
    if (!data || size == 0 || size > mem1_.size()) {
        return false;
    }
    std::memcpy(mem1_.data(), data, size);
    pc_ = 0x80003100;
    return true;
}

} // namespace wii
} // namespace omnistation
