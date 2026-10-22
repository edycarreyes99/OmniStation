#pragma once
#include "../common/core_interface.hpp"
#include "../common/simd_intrin.hpp"
#include <vector>

namespace omnistation {
namespace ps2 {

class Ps2Core final : public core::ICpuCore {
public:
    Ps2Core();
    ~Ps2Core() override;

    void Reset() override;
    uint32_t Step(uint32_t cycles) override;
    void ExecuteBlock() override;
    void TriggerInterrupt(uint32_t vector) override;
    core::ExecutionStats GetStats() const override;

    void ExecuteVu0Macro(uint32_t instruction);
    void ExecuteVu1Micro(uint32_t address);

private:
    uint32_t pc_{0xBFC00000};
    simd::Vec128 ee_regs_[32]{}; // 128-bit MMI General Purpose Registers
    simd::Vec128 vu0_regs_[32]{};
    simd::Vec128 vu1_regs_[32]{};
    uint64_t total_cycles_{0};
    std::vector<uint8_t> main_ram_; // 32 MB RDRAM
};

} // namespace ps2
} // namespace omnistation
