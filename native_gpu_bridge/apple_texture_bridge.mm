#include "texture_bridge.hpp"

#if defined(__APPLE__)
#import <IOSurface/IOSurface.h>
#import <CoreVideo/CoreVideo.h>

namespace omnistation {
namespace bridge {

NativeGpuTextureBridge& NativeGpuTextureBridge::Instance() {
    static NativeGpuTextureBridge instance;
    return instance;
}

int64_t NativeGpuTextureBridge::RegisterTexture(void* native_surface_handle, [[maybe_unused]] uint32_t width, [[maybe_unused]] uint32_t height) {
    if (!native_surface_handle) return -1;
    // Bind IOSurfaceRef to Flutter texture ID
    int64_t id = next_texture_id_++;
    return id;
}

void NativeGpuTextureBridge::UnregisterTexture([[maybe_unused]] int64_t texture_id) {
    // Unbind and release
}

void NativeGpuTextureBridge::MarkFrameAvailable([[maybe_unused]] int64_t texture_id) {
    // Post frame notification to Flutter engine event loop
}

} // namespace bridge
} // namespace omnistation

#else

namespace omnistation {
namespace bridge {
NativeGpuTextureBridge& NativeGpuTextureBridge::Instance() {
    static NativeGpuTextureBridge instance;
    return instance;
}
int64_t NativeGpuTextureBridge::RegisterTexture(void*, uint32_t, uint32_t) { return 1001; }
void NativeGpuTextureBridge::UnregisterTexture(int64_t) {}
void NativeGpuTextureBridge::MarkFrameAvailable(int64_t) {}
} // namespace bridge
} // namespace omnistation

#endif
