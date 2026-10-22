#pragma once
#include <cstdint>
#if __has_include(<bit>)
#include <bit>
#endif

#if defined(__ARM_NEON) || defined(__aarch64__)
    #include <arm_neon.h>
    #define OMNISTATION_ARCH_ARM64 1
#elif defined(__x86_64__) || defined(_M_X64)
    #include <immintrin.h>
    #define OMNISTATION_ARCH_X86_64 1
#endif

namespace omnistation {
namespace simd {

// 128-bit Vector Union
union alignas(16) Vec128 {
    float f32[4];
    uint32_t u32[4];
    int32_t i32[4];
    uint64_t u64[2];
    uint8_t u8[16];

#if defined(OMNISTATION_ARCH_ARM64)
    float32x4_t neon_f32;
    uint32x4_t neon_u32;
#elif defined(OMNISTATION_ARCH_X86_64)
    __m128 sse_f32;
    __m128i sse_i32;
#endif
};

// Load/Store SIMD primitives
[[nodiscard]] inline Vec128 Vec128Load(const float* ptr) noexcept {
    Vec128 result;
#if defined(OMNISTATION_ARCH_ARM64)
    result.neon_f32 = vld1q_f32(ptr);
#elif defined(OMNISTATION_ARCH_X86_64)
    result.sse_f32 = _mm_loadu_ps(ptr);
#else
    for (int i = 0; i < 4; ++i) result.f32[i] = ptr[i];
#endif
    return result;
}

inline void Vec128Store(float* ptr, Vec128 val) noexcept {
#if defined(OMNISTATION_ARCH_ARM64)
    vst1q_f32(ptr, val.neon_f32);
#elif defined(OMNISTATION_ARCH_X86_64)
    _mm_storeu_ps(ptr, val.sse_f32);
#else
    for (int i = 0; i < 4; ++i) ptr[i] = val.f32[i];
#endif
}

// Zero-overhead SIMD vector operations
[[nodiscard]] inline Vec128 Vec128Add(Vec128 a, Vec128 b) noexcept {
    Vec128 result;
#if defined(OMNISTATION_ARCH_ARM64)
    result.neon_f32 = vaddq_f32(a.neon_f32, b.neon_f32);
#elif defined(OMNISTATION_ARCH_X86_64)
    result.sse_f32 = _mm_add_ps(a.sse_f32, b.sse_f32);
#else
    for (int i = 0; i < 4; ++i) result.f32[i] = a.f32[i] + b.f32[i];
#endif
    return result;
}

[[nodiscard]] inline Vec128 Vec128Sub(Vec128 a, Vec128 b) noexcept {
    Vec128 result;
#if defined(OMNISTATION_ARCH_ARM64)
    result.neon_f32 = vsubq_f32(a.neon_f32, b.neon_f32);
#elif defined(OMNISTATION_ARCH_X86_64)
    result.sse_f32 = _mm_sub_ps(a.sse_f32, b.sse_f32);
#else
    for (int i = 0; i < 4; ++i) result.f32[i] = a.f32[i] - b.f32[i];
#endif
    return result;
}

[[nodiscard]] inline Vec128 Vec128Mul(Vec128 a, Vec128 b) noexcept {
    Vec128 result;
#if defined(OMNISTATION_ARCH_ARM64)
    result.neon_f32 = vmulq_f32(a.neon_f32, b.neon_f32);
#elif defined(OMNISTATION_ARCH_X86_64)
    result.sse_f32 = _mm_mul_ps(a.sse_f32, b.sse_f32);
#else
    for (int i = 0; i < 4; ++i) result.f32[i] = a.f32[i] * b.f32[i];
#endif
    return result;
}

[[nodiscard]] inline float Vec128Dot3(Vec128 a, Vec128 b) noexcept {
    return (a.f32[0] * b.f32[0]) + (a.f32[1] * b.f32[1]) + (a.f32[2] * b.f32[2]);
}

[[nodiscard]] inline Vec128 Vec128Cross3(Vec128 a, Vec128 b) noexcept {
    Vec128 res{};
    res.f32[0] = a.f32[1] * b.f32[2] - a.f32[2] * b.f32[1];
    res.f32[1] = a.f32[2] * b.f32[0] - a.f32[0] * b.f32[2];
    res.f32[2] = a.f32[0] * b.f32[1] - a.f32[1] * b.f32[0];
    res.f32[3] = 0.0f;
    return res;
}

// Byte-swap for Big-Endian PowerPC / Emotion Engine
[[nodiscard]] constexpr uint32_t Swap32(uint32_t val) noexcept {
#if defined(__cpp_lib_byteswap) && __cpp_lib_byteswap >= 202110L
    return std::byteswap(val);
#elif defined(__GNUC__) || defined(__clang__)
    return __builtin_bswap32(val);
#else
    return ((val & 0x000000FFu) << 24) |
           ((val & 0x0000FF00u) << 8)  |
           ((val & 0x00FF0000u) >> 8)  |
           ((val & 0xFF000000u) >> 24);
#endif
}

[[nodiscard]] constexpr uint64_t Swap64(uint64_t val) noexcept {
#if defined(__cpp_lib_byteswap) && __cpp_lib_byteswap >= 202110L
    return std::byteswap(val);
#elif defined(__GNUC__) || defined(__clang__)
    return __builtin_bswap64(val);
#else
    return ((val & 0x00000000000000FFull) << 56) |
           ((val & 0x000000000000FF00ull) << 40) |
           ((val & 0x0000000000FF0000ull) << 24) |
           ((val & 0x00000000FF000000ull) << 8)  |
           ((val & 0x000000FF00000000ull) >> 8)  |
           ((val & 0x0000FF0000000000ull) >> 24) |
           ((val & 0x00FF000000000000ull) >> 40) |
           ((val & 0xFF00000000000000ull) >> 56);
#endif
}

} // namespace simd
} // namespace omnistation
