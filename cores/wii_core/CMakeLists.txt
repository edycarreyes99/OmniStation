add_library(omnistation_wii STATIC
    wii_core.cpp
)

target_include_directories(omnistation_wii PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/../common
)

target_link_libraries(omnistation_wii PUBLIC
    omnistation_common
)
