add_library(omnistation_ps1 STATIC
    ps1_core.cpp
)

target_include_directories(omnistation_ps1 PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}
)

target_link_libraries(omnistation_ps1 PUBLIC
    omnistation_common
)
