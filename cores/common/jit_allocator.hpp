#pragma once
#include <cstddef>

namespace omnistation {
namespace jit {

class JitAllocator {
public:
    static JitAllocator& Instance();

    // Allocates executable & writable memory according to OS security policies
    void* Allocate(size_t size);
    void Free(void* ptr, size_t size);

    // W^X State switching
    void BeginWrite(void* ptr, size_t size);
    void EndWrite(void* ptr, size_t size);

    // Invalidate instruction cache
    void FlushInstructionCache(void* ptr, size_t size);

    // Queries if native JIT is supported on current OS environment
    [[nodiscard]] bool IsJitSupported() const noexcept;

private:
    JitAllocator();
    ~JitAllocator() = default;

    bool is_jit_supported_{true};
};

} // namespace jit
} // namespace omnistation
