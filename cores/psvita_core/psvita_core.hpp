#pragma once
#include "../common/core_interface.hpp"
#include <vector>
#include <cstdint>

namespace omnistation {
namespace psvita {

struct TouchPoint {
    float x;
    float y;
    bool active;
};

class PsVitaCore final : public core::ICpuCore {
public:
    PsVitaCore();
    ~PsVitaCore() override;

    void Reset() override;
    uint32_t Step(uint32_t cycles) override;
    void ExecuteBlock() override;
    void TriggerInterrupt(uint32_t vector) override;
    core::ExecutionStats GetStats() const override;

    // ARM Cortex-A9 MPCore & PowerVR SGX543MP4+ pipeline
    void DispatchArmNeonVectorOp(uint32_t op);
    void UpdateTouchInput(const TouchPoint& front, const TouchPoint& rear);
    bool LoadSelf(const uint8_t* data, size_t size);

private:
    uint32_t pc_{0x81000000};
    uint32_t arm_regs_[16]{0};
    float neon_regs_[64]{0.0f}; // 32 64-bit D registers / 16 128-bit Q registers
    uint64_t total_cycles_{0};
    uint32_t instructions_executed_{0};
    TouchPoint front_touch_{};
    TouchPoint rear_touch_{};
    std::vector<uint8_t> main_ram_; // 512 MB PS Vita main RAM
    std::vector<uint8_t> vram_;     // 128 MB dedicated VRAM
};

} // namespace psvita
} // namespace omnistation
