add_library(omnistation_ps3 STATIC
    ps3_core.cpp
)

target_include_directories(omnistation_ps3 PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}
)

target_link_libraries(omnistation_ps3 PUBLIC
    omnistation_common
)
