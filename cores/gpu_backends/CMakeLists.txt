if(APPLE)
    add_library(omnistation_gpu STATIC
        metal_renderer.mm
        vulkan_renderer.cpp
    )
    target_compile_options(omnistation_gpu PRIVATE -fobjc-arc)
    target_link_libraries(omnistation_gpu PUBLIC
        ${METAL_LIB}
        ${METALKIT_LIB}
        ${FOUNDATION_LIB}
        ${IOSURFACE_LIB}
        omnistation_common
    )
else()
    add_library(omnistation_gpu STATIC
        vulkan_renderer.cpp
    )
    target_link_libraries(omnistation_gpu PUBLIC
        omnistation_common
    )
endif()

target_include_directories(omnistation_gpu PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}
)
