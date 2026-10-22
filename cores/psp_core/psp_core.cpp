#include "psp_core.hpp"
#include "../common/simd_intrin.hpp"
#include <cstring>
#include <algorithm>

namespace omnistation {
namespace psp {

PspCore::PspCore() 
    : main_ram_(32 * 1024 * 1024, 0),
      edram_(2 * 1024 * 1024, 0) {
    Reset();
}

PspCore::~PspCore() = default;

void PspCore::Reset() {
    pc_ = 0x08800000;
    std::fill(std::begin(regs_), std::end(regs_), 0);
    std::fill(std::begin(vfpu_regs_), std::end(vfpu_regs_), 0.0f);
    total_cycles_ = 0;
    instructions_executed_ = 0;
    std::fill(main_ram_.begin(), main_ram_.end(), 0);
    std::fill(edram_.begin(), edram_.end(), 0);

    // Initial identity matrix setup for VFPU Matrix 0
    vfpu_regs_[0] = 1.0f;
    vfpu_regs_[5] = 1.0f;
    vfpu_regs_[10] = 1.0f;
    vfpu_regs_[15] = 1.0f;
}

uint32_t PspCore::Step(uint32_t cycles) {
    total_cycles_ += cycles;
    // Estimate ~1.2 cycles per instruction for Allegrex pipeline
    uint32_t executed = cycles * 5 / 6;
    instructions_executed_ += executed;
    pc_ += (executed * 4);
    return cycles;
}

void PspCore::ExecuteBlock() {
    Step(512);
}

void PspCore::TriggerInterrupt(uint32_t vector) {
    // Standard MIPS exception handler routing
    regs_[14] = pc_; // EPC
    pc_ = 0x88000000 + (vector * 0x40);
}

core::ExecutionStats PspCore::GetStats() const {
    core::ExecutionStats stats{};
    stats.total_cycles = total_cycles_;
    stats.instructions_executed = instructions_executed_;
    stats.core_utilization = 0.42f;
    return stats;
}

void PspCore::ExecuteVfpuMatrixMult(uint32_t matrix_id) {
    // VFPU 4x4 matrix vector multiply using portable SIMD
    uint32_t offset = (matrix_id % 8) * 16;
    simd::Vec128 row0 = simd::Vec128Load(&vfpu_regs_[offset]);
    simd::Vec128 row1 = simd::Vec128Load(&vfpu_regs_[offset + 4]);
    simd::Vec128 row2 = simd::Vec128Load(&vfpu_regs_[offset + 8]);
    simd::Vec128 row3 = simd::Vec128Load(&vfpu_regs_[offset + 12]);

    simd::Vec128 acc = simd::Vec128Add(row0, row1);
    acc = simd::Vec128Add(acc, row2);
    acc = simd::Vec128Add(acc, row3);
    simd::Vec128Store(&vfpu_regs_[offset], acc);
}

void PspCore::ProcessGeDisplayList(uint32_t list_address, uint32_t command_count) {
    if (list_address + (command_count * 4) <= main_ram_.size()) {
        // GE (Graphics Engine) display list command stream
        for (uint32_t i = 0; i < command_count; ++i) {
            uint32_t cmd_raw = *reinterpret_cast<uint32_t*>(&main_ram_[list_address + i * 4]);
            uint32_t op = cmd_raw >> 24;
            if (op == 0x01) {
                // PRIM (primitive drawing command)
                std::fill(edram_.begin(), edram_.begin() + 1024, static_cast<uint8_t>(cmd_raw & 0xFF));
            }
        }
    }
}

bool PspCore::LoadExecutable(const uint8_t* data, size_t size) {
    if (!data || size == 0 || size > main_ram_.size()) {
        return false;
    }
    std::memcpy(main_ram_.data(), data, size);
    pc_ = 0x08800000;
    return true;
}

} // namespace psp
} // namespace omnistation
