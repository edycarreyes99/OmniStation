#include "vulkan_renderer.hpp"

namespace omnistation {
namespace gpu {

VulkanRenderer::VulkanRenderer() = default;
VulkanRenderer::~VulkanRenderer() = default;

bool VulkanRenderer::Initialize(uint32_t width, uint32_t height) {
    width_ = width;
    height_ = height;
    // Vulkan 1.3 instance and physical device selection with VK_EXT_shader_object
    return true;
}

void VulkanRenderer::BeginFrame() {
    // Acquire swapchain or offscreen framebuffer
}

void VulkanRenderer::EndFrame() {
    // Execute command buffer and submit queue
}

void VulkanRenderer::Resize(uint32_t new_width, uint32_t new_height) {
    width_ = new_width;
    height_ = new_height;
}

void* VulkanRenderer::GetNativeTextureHandle() const {
    return native_texture_handle_;
}

} // namespace gpu
} // namespace omnistation
