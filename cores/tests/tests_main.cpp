#include <gtest/gtest.h>
#include "../common/jit_allocator.hpp"
#include "../common/simd_intrin.hpp"
#include "../snes_core/snes_core.hpp"
#include "../ps1_core/ps1_core.hpp"
#include "../ps2_core/ps2_core.hpp"
#include "../ps3_core/ps3_core.hpp"
#include "../psp_core/psp_core.hpp"
#include "../psvita_core/psvita_core.hpp"
#include "../wii_core/wii_core.hpp"
#include "../wiiu_core/wiiu_core.hpp"
#include "../gpu_backends/metal_renderer.hpp"
#include "../gpu_backends/vulkan_renderer.hpp"
#include "../../native_gpu_bridge/texture_bridge.hpp"

// ==========================================
// 1. JIT Allocator W^X & Security Tests
// ==========================================
TEST(JitAllocatorTest, AllocateAndFree) {
    auto& allocator = omnistation::jit::JitAllocator::Instance();
    EXPECT_TRUE(allocator.IsJitSupported());

    size_t size = 4096;
    void* ptr = allocator.Allocate(size);
    ASSERT_NE(ptr, nullptr);

    allocator.BeginWrite(ptr, size);
    auto* code = static_cast<uint8_t*>(ptr);
    code[0] = 0x90; // NOP (x86) or valid byte
    allocator.EndWrite(ptr, size);

    allocator.FlushInstructionCache(ptr, size);
    allocator.Free(ptr, size);
}

// ==========================================
// 2. SIMD Vector Operations Tests
// ==========================================
TEST(SimdTest, Vector128Math) {
    omnistation::simd::Vec128 a{};
    omnistation::simd::Vec128 b{};
    for (int i = 0; i < 4; ++i) {
        a.f32[i] = static_cast<float>(i + 1); // 1, 2, 3, 4
        b.f32[i] = 2.0f;
    }

    auto sum = omnistation::simd::Vec128Add(a, b);
    EXPECT_FLOAT_EQ(sum.f32[0], 3.0f);
    EXPECT_FLOAT_EQ(sum.f32[1], 4.0f);
    EXPECT_FLOAT_EQ(sum.f32[2], 5.0f);
    EXPECT_FLOAT_EQ(sum.f32[3], 6.0f);

    auto sub = omnistation::simd::Vec128Sub(a, b);
    EXPECT_FLOAT_EQ(sub.f32[0], -1.0f);
    EXPECT_FLOAT_EQ(sub.f32[1], 0.0f);

    auto mul = omnistation::simd::Vec128Mul(a, b);
    EXPECT_FLOAT_EQ(mul.f32[0], 2.0f);
    EXPECT_FLOAT_EQ(mul.f32[1], 4.0f);

    float dot = omnistation::simd::Vec128Dot3(a, b);
    EXPECT_FLOAT_EQ(dot, 12.0f); // (1*2)+(2*2)+(3*2) = 2+4+6 = 12

    auto cross = omnistation::simd::Vec128Cross3(a, b);
    EXPECT_FLOAT_EQ(cross.f32[3], 0.0f);

    EXPECT_EQ(omnistation::simd::Swap32(0x12345678), 0x78563412);
}

// ==========================================
// 3. SNES Core Architecture Tests
// ==========================================
TEST(SnesCoreTest, LifecycleAndExecution) {
    omnistation::snes::SnesCore core;
    core.Reset();

    EXPECT_EQ(core.Step(100), 100);
    core.ExecuteBlock();

    auto stats = core.GetStats();
    EXPECT_GT(stats.total_cycles, 0);

    std::vector<uint8_t> dummy_rom(0x10000, 0xEA); // 64KB NOPs
    EXPECT_TRUE(core.LoadRom(dummy_rom.data(), dummy_rom.size()));
    core.RenderScanline(120);
    core.TriggerInterrupt(0xFFEA);
}

// ==========================================
// 4. PS1 Core & PGXP Tests
// ==========================================
TEST(Ps1CoreTest, LifecycleAndPgxp) {
    omnistation::ps1::Ps1Core core;
    core.Reset();

    EXPECT_EQ(core.Step(200), 200);
    core.ExecuteBlock();

    auto stats = core.GetStats();
    EXPECT_GT(stats.total_cycles, 0);

    core.EnablePgxp(true);
    core.ExecuteGteCommand(0x18);
    core.TriggerInterrupt(0);
}

// ==========================================
// 5. PS2 Core Emotion Engine & VU Tests
// ==========================================
TEST(Ps2CoreTest, LifecycleAndVu) {
    omnistation::ps2::Ps2Core core;
    core.Reset();

    EXPECT_EQ(core.Step(500), 500);
    core.ExecuteBlock();

    auto stats = core.GetStats();
    EXPECT_GT(stats.total_cycles, 0);

    core.ExecuteVu0Macro(0x28); // VADD
    core.ExecuteVu1Micro(0x1000);
    core.TriggerInterrupt(1);
}

// ==========================================
// 6. PS3 Core Cell Broadband Engine & SPU Tests
// ==========================================
TEST(Ps3CoreTest, CellPpeAndSpuDma) {
    omnistation::ps3::Ps3Core core;
    core.Reset();

    core.StartSpuThread(0, 0x0000);
    core.StartSpuThread(1, 0x0100);
    EXPECT_EQ(core.Step(1000), 1000);
    core.ExecuteBlock();

    auto stats = core.GetStats();
    EXPECT_GT(stats.total_cycles, 0);

    // Test SPU DMA transfer (MFC_GET_CMD 0x20 and MFC_PUT_CMD 0x40)
    core.ExecuteSpuDma(0, 0x1000, 0x0000, 1024, 0x20);
    core.ExecuteSpuDma(0, 0x1000, 0x0000, 1024, 0x40);

    core.StopSpuThread(0);
    core.StopSpuThread(1);

    // Test CellOS LV2 Syscalls
    EXPECT_EQ(core.DispatchSyscall(1, 0, 0, 0), 0);
    EXPECT_EQ(core.DispatchSyscall(378, 6, 0, 0), 0);
    EXPECT_EQ(core.DispatchSyscall(399, 0, 0, 0), 0);
    EXPECT_EQ(core.DispatchSyscall(410, 0, 0, 0), 0);
    core.ProcessGcmCommandBuffer(0x2000, 512);
}

// ==========================================
// 7. GPU Renderers & Texture Bridge Tests
// ==========================================
TEST(GpuRendererTest, MetalAndVulkanInit) {
    omnistation::gpu::VulkanRenderer vk_renderer;
    EXPECT_TRUE(vk_renderer.Initialize(1920, 1080));
    vk_renderer.BeginFrame();
    vk_renderer.EndFrame();
    vk_renderer.Resize(3840, 2160);

#if defined(__APPLE__)
    omnistation::gpu::MetalRenderer mtl_renderer;
    EXPECT_TRUE(mtl_renderer.Initialize(1280, 720));
    mtl_renderer.BeginFrame();
    mtl_renderer.EndFrame();
    void* handle = mtl_renderer.GetNativeTextureHandle();
    EXPECT_NE(handle, nullptr);

    auto& bridge = omnistation::bridge::NativeGpuTextureBridge::Instance();
    int64_t tex_id = bridge.RegisterTexture(handle, 1280, 720);
    EXPECT_GT(tex_id, 0);
    bridge.MarkFrameAvailable(tex_id);
    bridge.UnregisterTexture(tex_id);
#endif
}

// ==========================================
// 8. PSP Core & VFPU Vector Tests
// ==========================================
TEST(PspCoreTest, LifecycleAndVfpu) {
    omnistation::psp::PspCore core;
    core.Reset();

    EXPECT_EQ(core.Step(256), 256);
    core.ExecuteBlock();

    auto stats = core.GetStats();
    EXPECT_GT(stats.total_cycles, 0);

    core.ExecuteVfpuMatrixMult(0);
    core.TriggerInterrupt(1);

    std::vector<uint8_t> dummy_elf(4096, 0);
    EXPECT_TRUE(core.LoadExecutable(dummy_elf.data(), dummy_elf.size()));
}

// ==========================================
// 9. PS Vita Core & ARM NEON Tests
// ==========================================
TEST(PsVitaCoreTest, LifecycleAndArmNeon) {
    omnistation::psvita::PsVitaCore core;
    core.Reset();

    EXPECT_EQ(core.Step(512), 512);
    core.ExecuteBlock();

    auto stats = core.GetStats();
    EXPECT_GT(stats.total_cycles, 0);

    core.DispatchArmNeonVectorOp(0); // Add
    core.DispatchArmNeonVectorOp(1); // Mul

    omnistation::psvita::TouchPoint front{0.5f, 0.5f, true};
    omnistation::psvita::TouchPoint rear{0.2f, 0.8f, true};
    core.UpdateTouchInput(front, rear);
    core.TriggerInterrupt(2);

    std::vector<uint8_t> dummy_self(4096, 0);
    EXPECT_TRUE(core.LoadSelf(dummy_self.data(), dummy_self.size()));
}

// ==========================================
// 10. Wii Core & Broadway PPC Tests
// ==========================================
TEST(WiiCoreTest, LifecycleAndPairedSingle) {
    omnistation::wii::WiiCore core;
    core.Reset();

    EXPECT_EQ(core.Step(1024), 1024);
    core.ExecuteBlock();

    auto stats = core.GetStats();
    EXPECT_GT(stats.total_cycles, 0);

    core.ExecutePairedSingleMath(0); // ps_add
    core.ExecutePairedSingleMath(1); // ps_mul
    core.ProcessGxFifoCommand(0x80000000);

    omnistation::wii::WiimoteState wm{};
    wm.buttons = 0x0008; // A button
    wm.ir_x = 0.5f;
    wm.ir_y = 0.5f;
    core.UpdateWiimote(wm);
    core.TriggerInterrupt(4);

    std::vector<uint8_t> dummy_dol(4096, 0);
    EXPECT_TRUE(core.LoadDol(dummy_dol.data(), dummy_dol.size()));
}

// ==========================================
// 11. Wii U Core & Tri-Core GamePad Tests
// ==========================================
TEST(WiiUCoreTest, LifecycleAndTriCoreGamePad) {
    omnistation::wiiu::WiiUCore core;
    core.Reset();

    EXPECT_EQ(core.Step(1536), 1536);
    core.ExecuteBlock();

    auto stats = core.GetStats();
    EXPECT_GT(stats.total_cycles, 0);

    core.ExecuteTriCoreWorkload(0, 512);
    core.ExecuteTriCoreWorkload(1, 512);
    core.ExecuteTriCoreWorkload(2, 512);
    core.ProcessGx2CommandBuffer(0x1000, 256);

    EXPECT_NE(core.GetGamePadFramebuffer(), nullptr);

    omnistation::wiiu::GamePadState gp{};
    gp.buttons = 0x0001;
    gp.touch_active = true;
    gp.touch_x = 0.4f;
    gp.touch_y = 0.6f;
    core.UpdateGamePadInput(gp);
    core.TriggerInterrupt(5);

    std::vector<uint8_t> dummy_rpx(4096, 0);
    EXPECT_TRUE(core.LoadRpx(dummy_rpx.data(), dummy_rpx.size()));
}

int main(int argc, char** argv) {
    ::testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}
