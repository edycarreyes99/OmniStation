#pragma once
#include "../common/core_interface.hpp"
#include <vector>
#include <cstdint>

namespace omnistation {
namespace wii {

struct WiimoteState {
    uint32_t buttons;
    float ir_x;
    float ir_y;
    float nunchuk_stick_x;
    float nunchuk_stick_y;
    bool nunchuk_c;
    bool nunchuk_z;
};

class WiiCore final : public core::ICpuCore {
public:
    WiiCore();
    ~WiiCore() override;

    void Reset() override;
    uint32_t Step(uint32_t cycles) override;
    void ExecuteBlock() override;
    void TriggerInterrupt(uint32_t vector) override;
    core::ExecutionStats GetStats() const override;

    // Broadway PowerPC 750CL Paired-Single & Hollywood GX FIFO
    void ExecutePairedSingleMath(uint32_t op);
    void ProcessGxFifoCommand(uint32_t cmd);
    void UpdateWiimote(const WiimoteState& state);
    bool LoadDol(const uint8_t* data, size_t size);

private:
    uint32_t pc_{0x80003100};
    uint32_t gpr_[32]{0};
    double fpr_[32]{0.0};       // 32 64-bit FPRs
    double ps1_[32]{0.0};       // Paired single companion registers
    uint64_t total_cycles_{0};
    uint32_t instructions_executed_{0};
    WiimoteState wiimote_{};
    std::vector<uint8_t> mem1_; // 24 MB 1T-SRAM
    std::vector<uint8_t> mem2_; // 64 MB GDDR3 RAM
};

} // namespace wii
} // namespace omnistation
