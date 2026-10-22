add_library(omnistation_wiiu STATIC
    wiiu_core.cpp
)

target_include_directories(omnistation_wiiu PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/../common
)

target_link_libraries(omnistation_wiiu PUBLIC
    omnistation_common
)
