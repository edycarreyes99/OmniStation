#pragma once
#include <cstdint>
#include <cstddef>

#if __cplusplus >= 202002L && __has_include(<span>)
#include <span>
#else
namespace std {
template <typename T>
struct span {
    T* data_{nullptr};
    size_t size_{0};
    constexpr span() noexcept = default;
    constexpr span(T* data, size_t size) noexcept : data_(data), size_(size) {}
    constexpr T* data() const noexcept { return data_; }
    constexpr size_t size() const noexcept { return size_; }
    constexpr T& operator[](size_t idx) const noexcept { return data_[idx]; }
    constexpr T* begin() const noexcept { return data_; }
    constexpr T* end() const noexcept { return data_ + size_; }
};
} // namespace std
#endif

namespace omnistation {
namespace core {

enum class PlatformType : uint32_t {
    Snes = 1,
    Ps1 = 2,
    Ps2 = 3,
    Ps3 = 4,
    Psp = 5,
    PsVita = 6,
    Wii = 7,
    WiiU = 8,
};

struct ExecutionStats {
    uint64_t total_cycles;
    uint32_t instructions_executed;
    float core_utilization;
};

// Pure SOLID Interface: ICpuCore
class ICpuCore {
public:
    virtual ~ICpuCore() = default;
    virtual void Reset() = 0;
    virtual uint32_t Step(uint32_t cycles) = 0;
    virtual void ExecuteBlock() = 0;
    virtual void TriggerInterrupt(uint32_t vector) = 0;
    virtual ExecutionStats GetStats() const = 0;
};

// Pure SOLID Interface: IGpuRenderer
class IGpuRenderer {
public:
    virtual ~IGpuRenderer() = default;
    virtual bool Initialize(uint32_t width, uint32_t height) = 0;
    virtual void BeginFrame() = 0;
    virtual void EndFrame() = 0;
    virtual void Resize(uint32_t new_width, uint32_t new_height) = 0;
    virtual void* GetNativeTextureHandle() const = 0;
};

// Pure SOLID Interface: IMemoryCardBus
class IMemoryCardBus {
public:
    virtual ~IMemoryCardBus() = default;
    virtual bool SendCommand(uint8_t cmd, std::span<const uint8_t> in_payload, std::span<uint8_t> out_payload) = 0;
    virtual bool IsCardInserted(uint32_t slot) const = 0;
};

// Pure SOLID Interface: IAudioSink
class IAudioSink {
public:
    virtual ~IAudioSink() = default;
    virtual void SubmitSamples(const float* interleaved, size_t frames) = 0;
    virtual size_t GetAvailableFrames() const = 0;
};

} // namespace core
} // namespace omnistation
