#include "jit_allocator.hpp"
#include <cstdint>

#if defined(__APPLE__)
    #include <sys/mman.h>
    #include <libkern/OSCacheControl.h>
    #include <pthread.h>
#elif defined(_WIN32)
    #include <windows.h>
#else
    #include <sys/mman.h>
    #include <unistd.h>
#endif

namespace omnistation {
namespace jit {

JitAllocator& JitAllocator::Instance() {
    static JitAllocator instance;
    return instance;
}

JitAllocator::JitAllocator() {
#if defined(__APPLE__)
    // On macOS / iOS, probe for JIT permission
    is_jit_supported_ = true;
#else
    is_jit_supported_ = true;
#endif
}

bool JitAllocator::IsJitSupported() const noexcept {
    return is_jit_supported_;
}

void* JitAllocator::Allocate(size_t size) {
    if (size == 0) return nullptr;

#if defined(__APPLE__)
    // macOS Apple Silicon MAP_JIT allocation
    #if defined(MAP_JIT)
        void* ptr = mmap(nullptr, size, PROT_READ | PROT_WRITE | PROT_EXEC, MAP_PRIVATE | MAP_ANON | MAP_JIT, -1, 0);
        if (ptr == MAP_FAILED) {
            // Fallback without MAP_JIT if denied
            ptr = mmap(nullptr, size, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANON, -1, 0);
        }
        return (ptr == MAP_FAILED) ? nullptr : ptr;
    #else
        void* ptr = mmap(nullptr, size, PROT_READ | PROT_WRITE | PROT_EXEC, MAP_PRIVATE | MAP_ANON, -1, 0);
        return (ptr == MAP_FAILED) ? nullptr : ptr;
    #endif
#elif defined(_WIN32)
    return VirtualAlloc(nullptr, size, MEM_COMMIT | MEM_RESERVE, PAGE_EXECUTE_READWRITE);
#else
    // Linux / Android Dual-mapping or standard mmap
    void* ptr = mmap(nullptr, size, PROT_READ | PROT_WRITE | PROT_EXEC, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    return (ptr == MAP_FAILED) ? nullptr : ptr;
#endif
}

void JitAllocator::Free(void* ptr, size_t size) {
    if (!ptr || size == 0) return;

#if defined(_WIN32)
    VirtualFree(ptr, 0, MEM_RELEASE);
#else
    munmap(ptr, size);
#endif
}

void JitAllocator::BeginWrite([[maybe_unused]] void* ptr, [[maybe_unused]] size_t size) {
#if defined(__APPLE__) && defined(__aarch64__)
    // Toggle W^X protection on Apple Silicon (disable execute, enable write)
    #if defined(MAP_JIT)
        pthread_jit_write_protect_np(0);
    #endif
#endif
}

void JitAllocator::EndWrite([[maybe_unused]] void* ptr, [[maybe_unused]] size_t size) {
#if defined(__APPLE__) && defined(__aarch64__)
    // Re-enable execution, disable write
    #if defined(MAP_JIT)
        pthread_jit_write_protect_np(1);
    #endif
#endif
    FlushInstructionCache(ptr, size);
}

void JitAllocator::FlushInstructionCache([[maybe_unused]] void* ptr, [[maybe_unused]] size_t size) {
    if (!ptr || size == 0) return;

#if defined(__APPLE__)
    sys_icache_invalidate(ptr, size);
#elif defined(_WIN32)
    FlushInstructionCache(GetCurrentProcess(), ptr, size);
#elif defined(__GNUC__) || defined(__clang__)
    __builtin___clear_cache(static_cast<char*>(ptr), static_cast<char*>(ptr) + size);
#endif
}

} // namespace jit
} // namespace omnistation
