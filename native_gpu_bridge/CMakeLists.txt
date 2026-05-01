if(APPLE)
    add_library(native_gpu_bridge STATIC
        apple_texture_bridge.mm
    )
    target_compile_options(native_gpu_bridge PRIVATE -fobjc-arc)
    target_link_libraries(native_gpu_bridge PUBLIC
        ${IOSURFACE_LIB}
        ${FOUNDATION_LIB}
        omnistation_common
    )
else()
    add_library(native_gpu_bridge STATIC
        apple_texture_bridge.mm
    )
    target_link_libraries(native_gpu_bridge PUBLIC
        omnistation_common
    )
endif()

target_include_directories(native_gpu_bridge PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}
)
