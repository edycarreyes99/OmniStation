#pragma once
#include "../common/core_interface.hpp"
#include <vector>
#include <cstdint>

namespace omnistation {
namespace psp {

class PspCore final : public core::ICpuCore {
public:
    PspCore();
    ~PspCore() override;

    void Reset() override;
    uint32_t Step(uint32_t cycles) override;
    void ExecuteBlock() override;
    void TriggerInterrupt(uint32_t vector) override;
    core::ExecutionStats GetStats() const override;

    // Allegrex MIPS R4000 & VFPU Vector instructions
    void ExecuteVfpuMatrixMult(uint32_t matrix_id);
    void ProcessGeDisplayList(uint32_t list_address, uint32_t command_count);
    bool LoadExecutable(const uint8_t* data, size_t size);

private:
    uint32_t pc_{0x08800000};
    uint32_t regs_[32]{0};
    float vfpu_regs_[128]{0.0f}; // 128 scalar floats / 32 4x4 matrix blocks
    uint64_t total_cycles_{0};
    uint32_t instructions_executed_{0};
    std::vector<uint8_t> main_ram_; // 32 MB PSP main RAM
    std::vector<uint8_t> edram_;    // 2 MB eDRAM VRAM
};

} // namespace psp
} // namespace omnistation
