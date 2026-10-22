#pragma once
#include "../common/core_interface.hpp"
#include "../common/simd_intrin.hpp"
#include <vector>
#include <array>

namespace omnistation {
namespace ps3 {

struct SpuContext {
    uint32_t pc{0};
    std::array<simd::Vec128, 128> regs{};
    std::vector<uint8_t> local_store{std::vector<uint8_t>(256 * 1024, 0)}; // 256 KB Local Store
    bool is_running{false};
};

class Ps3Core final : public core::ICpuCore {
public:
    Ps3Core();
    ~Ps3Core() override;

    void Reset() override;
    uint32_t Step(uint32_t cycles) override;
    void ExecuteBlock() override;
    void TriggerInterrupt(uint32_t vector) override;
    core::ExecutionStats GetStats() const override;

    // Cell Broadband Engine SPU Pool Management
    void StartSpuThread(size_t spu_index, uint32_t entry_point);
    void StopSpuThread(size_t spu_index);
    void ExecuteSpuDma(size_t spu_index, uint64_t main_addr, uint32_t ls_addr, uint32_t size, uint8_t command);

    // CellOS LV2 Syscall HLE Dispatcher
    uint64_t DispatchSyscall(uint64_t syscall_num, uint64_t arg1, uint64_t arg2, uint64_t arg3);

    // RSX FIFO Command Processing
    void ProcessGcmCommandBuffer(uint64_t buffer_addr, uint32_t size);

private:
    uint64_t ppu_pc_{0x10000};
    uint64_t ppu_gpr_[32]{0};
    std::array<simd::Vec128, 32> ppu_vr_{};
    std::array<SpuContext, 6> spus_{}; // 6 active SPUs
    uint64_t total_cycles_{0};
    std::vector<uint8_t> main_memory_; // 256 MB XDR RAM
    std::vector<uint8_t> rsx_vram_;    // 256 MB GDDR3 VRAM
};

} // namespace ps3
} // namespace omnistation
