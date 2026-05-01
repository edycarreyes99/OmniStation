#pragma once
#include <cstdint>

namespace omnistation {
namespace bridge {

class NativeGpuTextureBridge {
public:
    static NativeGpuTextureBridge& Instance();

    // Register a native GPU texture handle with Flutter
    int64_t RegisterTexture(void* native_surface_handle, uint32_t width, uint32_t height);
    
    // Unregister
    void UnregisterTexture(int64_t texture_id);

    // Notify Flutter that a new frame has been rendered
    void MarkFrameAvailable(int64_t texture_id);

private:
    NativeGpuTextureBridge() = default;
    int64_t next_texture_id_{1001};
};

} // namespace bridge
} // namespace omnistation
