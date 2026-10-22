#pragma once
#include "../common/core_interface.hpp"
#include <vector>

namespace omnistation {
namespace ps1 {

class Ps1Core final : public core::ICpuCore {
public:
    Ps1Core();
    ~Ps1Core() override;

    void Reset() override;
    uint32_t Step(uint32_t cycles) override;
    void ExecuteBlock() override;
    void TriggerInterrupt(uint32_t vector) override;
    core::ExecutionStats GetStats() const override;

    void EnablePgxp(bool enable);
    void ExecuteGteCommand(uint32_t cmd);

private:
    uint32_t pc_{0xBFC00000};
    uint32_t regs_[32]{0};
    uint64_t total_cycles_{0};
    bool pgxp_enabled_{true};
    std::vector<uint8_t> ram_;
    std::vector<uint8_t> vram_;
};

} // namespace ps1
} // namespace omnistation
