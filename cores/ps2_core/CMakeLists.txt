add_library(omnistation_ps2 STATIC
    ps2_core.cpp
)

target_include_directories(omnistation_ps2 PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}
)

target_link_libraries(omnistation_ps2 PUBLIC
    omnistation_common
)
