#pragma once
#include "../common/core_interface.hpp"
#include <vector>
#include <memory>
#include <cstdint>

struct Snes;

namespace omnistation {
namespace snes {

class SnesCore final : public core::ICpuCore {
public:
    SnesCore();
    ~SnesCore() override;

    void Reset() override;
    uint32_t Step(uint32_t cycles) override;
    void ExecuteBlock() override;
    void TriggerInterrupt(uint32_t vector) override;
    core::ExecutionStats GetStats() const override;

    bool LoadRom(const uint8_t* rom_data, size_t size);
    void SetAudioSink(std::shared_ptr<core::IAudioSink> sink);
    void RenderScanline(uint16_t line);

    void RunFrame();
    void SetButtonState(int player, int button, bool pressed);
    const uint8_t* GetFramebuffer() const;
    size_t GetFramebufferSize() const;
    uint32_t GetWidth() const { return 512; }
    uint32_t GetHeight() const { return 480; }

private:
    struct Snes* snes_{nullptr};
    std::vector<uint8_t> framebuffer_;
    std::shared_ptr<core::IAudioSink> audio_sink_;
    uint64_t total_cycles_{0};
};

} // namespace snes
} // namespace omnistation

