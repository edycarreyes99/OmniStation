#include "metal_renderer.hpp"

#if defined(__APPLE__)
#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>
#import <IOSurface/IOSurface.h>

namespace omnistation {
namespace gpu {

MetalRenderer::MetalRenderer() = default;

MetalRenderer::~MetalRenderer() {
    if (native_texture_handle_) {
        CFRelease((CFTypeRef)native_texture_handle_);
        native_texture_handle_ = nullptr;
    }
    if (metal_device_) {
#if __has_feature(objc_arc)
        CFRelease((CFTypeRef)metal_device_);
#else
        [(id)metal_device_ release];
#endif
        metal_device_ = nullptr;
    }
    if (command_queue_) {
#if __has_feature(objc_arc)
        CFRelease((CFTypeRef)command_queue_);
#else
        [(id)command_queue_ release];
#endif
        command_queue_ = nullptr;
    }
}

bool MetalRenderer::Initialize(uint32_t width, uint32_t height) {
    width_ = width;
    height_ = height;

    id<MTLDevice> device = MTLCreateSystemDefaultDevice();
    if (!device) return false;

#if __has_feature(objc_arc)
    metal_device_ = (__bridge_retained void*)device;
    command_queue_ = (__bridge_retained void*)[device newCommandQueue];
#else
    metal_device_ = (void*)[device retain];
    command_queue_ = (void*)[[device newCommandQueue] retain];
#endif

    // Allocate an IOSurface-backed Metal texture for Zero-Copy display in Flutter
    NSDictionary* properties = @{
        (id)kIOSurfaceWidth: @(width_),
        (id)kIOSurfaceHeight: @(height_),
        (id)kIOSurfaceBytesPerElement: @(4),
        (id)kIOSurfacePixelFormat: @((uint32_t)'BGRA'),
    };

    IOSurfaceRef surface = IOSurfaceCreate((__bridge CFDictionaryRef)properties);
    if (!surface) return false;

    MTLTextureDescriptor* desc = [MTLTextureDescriptor texture2DDescriptorWithPixelFormat:MTLPixelFormatBGRA8Unorm
                                                                                    width:width_
                                                                                   height:height_
                                                                                mipmapped:NO];
    desc.usage = MTLTextureUsageRenderTarget | MTLTextureUsageShaderRead;

    id<MTLTexture> texture = [device newTextureWithDescriptor:desc iosurface:surface plane:0];
    native_texture_handle_ = (void*)surface; // Handled directly by Flutter Texture Bridge

    return texture != nil;
}

void MetalRenderer::BeginFrame() {
    // Acquire drawable / command buffer
}

void MetalRenderer::EndFrame() {
    // Commit commands and present surface
}

void MetalRenderer::Resize(uint32_t new_width, uint32_t new_height) {
    if (new_width == width_ && new_height == height_) return;
    Initialize(new_width, new_height);
}

void* MetalRenderer::GetNativeTextureHandle() const {
    return native_texture_handle_;
}

} // namespace gpu
} // namespace omnistation

#else

namespace omnistation {
namespace gpu {
MetalRenderer::MetalRenderer() = default;
MetalRenderer::~MetalRenderer() = default;
bool MetalRenderer::Initialize(uint32_t, uint32_t) { return false; }
void MetalRenderer::BeginFrame() {}
void MetalRenderer::EndFrame() {}
void MetalRenderer::Resize(uint32_t, uint32_t) {}
void* MetalRenderer::GetNativeTextureHandle() const { return nullptr; }
} // namespace gpu
} // namespace omnistation

#endif
