#pragma once
#include "../common/core_interface.hpp"
#include <vector>
#include <cstdint>

namespace omnistation {
namespace wiiu {

struct GamePadState {
    uint32_t buttons;
    float left_stick_x;
    float left_stick_y;
    float right_stick_x;
    float right_stick_y;
    float touch_x;
    float touch_y;
    bool touch_active;
};

class WiiUCore final : public core::ICpuCore {
public:
    WiiUCore();
    ~WiiUCore() override;

    void Reset() override;
    uint32_t Step(uint32_t cycles) override;
    void ExecuteBlock() override;
    void TriggerInterrupt(uint32_t vector) override;
    core::ExecutionStats GetStats() const override;

    // Espresso Tri-Core PowerPC & Latte GX2 GPU
    void ExecuteTriCoreWorkload(uint32_t core_id, uint32_t cycles);
    void ProcessGx2CommandBuffer(uint32_t buffer_addr, uint32_t size);
    void UpdateGamePadInput(const GamePadState& state);
    const uint8_t* GetGamePadFramebuffer() const;
    bool LoadRpx(const uint8_t* data, size_t size);

private:
    uint32_t pc_[3]{0x02000000, 0x02000000, 0x02000000}; // Tri-Core program counters
    uint32_t gpr_[3][32]{{0}};
    uint64_t total_cycles_{0};
    uint32_t instructions_executed_{0};
    GamePadState gamepad_{};
    std::vector<uint8_t> main_ram_;          // 128 MB working memory
    std::vector<uint8_t> tv_framebuffer_;    // 1280x720 RGBA (3.68 MB)
    std::vector<uint8_t> gamepad_framebuffer_; // 854x480 RGBA (1.63 MB)
};

} // namespace wiiu
} // namespace omnistation
