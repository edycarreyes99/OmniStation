add_library(omnistation_common STATIC
    jit_allocator.cpp
)

target_include_directories(omnistation_common PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}
)
