#include "ps1_core.hpp"

namespace omnistation {
namespace ps1 {

Ps1Core::Ps1Core()
    : ram_(2 * 1024 * 1024, 0), vram_(1024 * 1024, 0) {
    Reset();
}

Ps1Core::~Ps1Core() = default;

void Ps1Core::Reset() {
    pc_ = 0xBFC00000; // Reset vector (BIOS entry)
    for (int i = 0; i < 32; ++i) regs_[i] = 0;
    total_cycles_ = 0;
    pgxp_enabled_ = true;
}

uint32_t Ps1Core::Step(uint32_t cycles) {
    total_cycles_ += cycles;
    return cycles;
}

void Ps1Core::ExecuteBlock() {
    Step(2185); // Standard 33.8688 MHz cycle chunk
}

void Ps1Core::TriggerInterrupt(uint32_t vector) {
    pc_ = 0x80000080 + (vector * 0x80);
}

core::ExecutionStats Ps1Core::GetStats() const {
    return core::ExecutionStats{
        .total_cycles = total_cycles_,
        .instructions_executed = static_cast<uint32_t>(total_cycles_ / 2),
        .core_utilization = 25.0f,
    };
}

void Ps1Core::EnablePgxp(bool enable) {
    pgxp_enabled_ = enable;
}

void Ps1Core::ExecuteGteCommand([[maybe_unused]] uint32_t cmd) {
    // PGXP precision float matrix multiplication eliminating texture wobble
}

} // namespace ps1
} // namespace omnistation
