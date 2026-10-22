add_library(omnistation_psp STATIC
    psp_core.cpp
)

target_include_directories(omnistation_psp PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/../common
)

target_link_libraries(omnistation_psp PUBLIC
    omnistation_common
)
