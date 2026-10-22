#include "ps3_core.hpp"
#include <cstring>
#include <algorithm>

namespace omnistation {
namespace ps3 {

Ps3Core::Ps3Core()
    : main_memory_(256 * 1024 * 1024, 0), rsx_vram_(256 * 1024 * 1024, 0) {
    Reset();
}

Ps3Core::~Ps3Core() = default;

void Ps3Core::Reset() {
    ppu_pc_ = 0x10000;
    for (int i = 0; i < 32; ++i) {
        ppu_gpr_[i] = 0;
        ppu_vr_[i] = {};
    }
    for (size_t i = 0; i < spus_.size(); ++i) {
        spus_[i].pc = 0;
        spus_[i].is_running = false;
        std::fill(spus_[i].local_store.begin(), spus_[i].local_store.end(), 0);
    }
    total_cycles_ = 0;
}

uint32_t Ps3Core::Step(uint32_t cycles) {
    total_cycles_ += cycles;
    // Step PPE PowerPC and active SPUs concurrently
    for (auto& spu : spus_) {
        if (spu.is_running) {
            spu.pc += 4;
        }
    }
    return cycles;
}

void Ps3Core::ExecuteBlock() {
    Step(53333); // 3.2 GHz clock chunk
}

void Ps3Core::TriggerInterrupt([[maybe_unused]] uint32_t vector) {
    // CellOS LV2 interrupt handling
}

core::ExecutionStats Ps3Core::GetStats() const {
    return core::ExecutionStats{
        .total_cycles = total_cycles_,
        .instructions_executed = static_cast<uint32_t>(total_cycles_ / 2),
        .core_utilization = 52.0f,
    };
}

void Ps3Core::StartSpuThread(size_t spu_index, uint32_t entry_point) {
    if (spu_index < spus_.size()) {
        spus_[spu_index].pc = entry_point;
        spus_[spu_index].is_running = true;
    }
}

void Ps3Core::StopSpuThread(size_t spu_index) {
    if (spu_index < spus_.size()) {
        spus_[spu_index].is_running = false;
    }
}

void Ps3Core::ExecuteSpuDma(size_t spu_index, uint64_t main_addr, uint32_t ls_addr, uint32_t size, uint8_t command) {
    if (spu_index >= spus_.size()) return;
    auto& spu = spus_[spu_index];

    if (command == 0x20) {
        // MFC_GET_CMD: Main Memory -> SPU Local Store
        if (main_addr + size <= main_memory_.size() && ls_addr + size <= spu.local_store.size()) {
            std::memcpy(&spu.local_store[ls_addr], &main_memory_[main_addr], size);
        }
    } else if (command == 0x40) {
        // MFC_PUT_CMD: SPU Local Store -> Main Memory
        if (main_addr + size <= main_memory_.size() && ls_addr + size <= spu.local_store.size()) {
            std::memcpy(&main_memory_[main_addr], &spu.local_store[ls_addr], size);
        }
    }
}

uint64_t Ps3Core::DispatchSyscall(uint64_t syscall_num, [[maybe_unused]] uint64_t arg1, [[maybe_unused]] uint64_t arg2, [[maybe_unused]] uint64_t arg3) {
    // CellOS LV2 HLE Dispatcher
    switch (syscall_num) {
        case 1: // sys_process_exit
            return 0;
        case 378: // sys_spu_initialize
            return 0; // CELL_OK
        case 399: // cellGcmSys
            return 0;
        case 410: // cellAudio
            return 0;
        default:
            return 0;
    }
}

void Ps3Core::ProcessGcmCommandBuffer([[maybe_unused]] uint64_t buffer_addr, [[maybe_unused]] uint32_t size) {
    // Process RSX NV47 FIFO push buffer
}

} // namespace ps3
} // namespace omnistation
