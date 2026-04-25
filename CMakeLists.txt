cmake_minimum_required(VERSION 3.28)
project(OmniStation LANGUAGES C CXX OBJC OBJCXX)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Export compile commands for language servers
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Optimization and warning flags
if(MSVC)
    add_compile_options(/W4 /WX- /O2 /Oi /Ot /permissive-)
    add_compile_definitions(_CRT_SECURE_NO_WARNINGS)
else()
    add_compile_options(
        -Wall
        -Wextra
        -Wpedantic
        -O3
        -fno-rtti
        -fvisibility=hidden
    )
    # Enable SIMD instructions based on host architecture
    if(CMAKE_SYSTEM_PROCESSOR MATCHES "arm64|aarch64")
        add_compile_options(-march=armv8.5-a+simd)
    elseif(CMAKE_SYSTEM_PROCESSOR MATCHES "x86_64|AMD64")
        add_compile_options(-mavx2 -mfma -msse4.1)
    endif()
endif()

# Platform specific configuration
if(APPLE)
    enable_language(OBJC OBJCXX)
    set(CMAKE_OBJCXX_STANDARD 23)
    find_library(METAL_LIB Metal REQUIRED)
    find_library(METALKIT_LIB MetalKit REQUIRED)
    find_library(FOUNDATION_LIB Foundation REQUIRED)
    find_library(IOSURFACE_LIB IOSurface REQUIRED)
    find_library(QUARTZCORE_LIB QuartzCore REQUIRED)
endif()

# Subdirectories for cores and components
add_subdirectory(cores/common)
add_subdirectory(cores/gpu_backends)
add_subdirectory(cores/snes_core)
add_subdirectory(cores/ps1_core)
add_subdirectory(cores/ps2_core)
add_subdirectory(cores/ps3_core)
add_subdirectory(native_gpu_bridge)

option(ENABLE_TESTS "Build OmniStation C++23 unit test suite" ON)
if(ENABLE_TESTS)
    enable_testing()
    add_subdirectory(cores/tests)
endif()
