#pragma once
#include "../common/core_interface.hpp"

namespace omnistation {
namespace gpu {

class MetalRenderer final : public core::IGpuRenderer {
public:
    MetalRenderer();
    ~MetalRenderer() override;

    bool Initialize(uint32_t width, uint32_t height) override;
    void BeginFrame() override;
    void EndFrame() override;
    void Resize(uint32_t new_width, uint32_t new_height) override;
    void* GetNativeTextureHandle() const override;

private:
    uint32_t width_{1920};
    uint32_t height_{1080};
    void* native_texture_handle_{nullptr};
    void* metal_device_{nullptr};
    void* command_queue_{nullptr};
};

} // namespace gpu
} // namespace omnistation
