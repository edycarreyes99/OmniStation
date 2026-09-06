cmake_minimum_required(VERSION 3.22.1)
project(emu_ffi C)

set(CMAKE_C_STANDARD 11)

set(LAKE_SNES_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../../../../../../cores/snes_core/lake_snes")

file(GLOB LAKE_SNES_SOURCES "${LAKE_SNES_DIR}/*.c")

add_library(emu_ffi SHARED
    emu_ffi_bridge.c
    ${LAKE_SNES_SOURCES}
)

target_include_directories(emu_ffi PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/../../../../../../cores/snes_core
    ${LAKE_SNES_DIR}
)

target_compile_options(emu_ffi PRIVATE
    -O3
    -fvisibility=default
    -Wno-unused-parameter
    -Wno-sign-compare
    -Wno-unused-function
)

target_link_libraries(emu_ffi
    android
    log
    aaudio
)
