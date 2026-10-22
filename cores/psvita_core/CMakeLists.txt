add_library(omnistation_psvita STATIC
    psvita_core.cpp
)

target_include_directories(omnistation_psvita PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/../common
)

target_link_libraries(omnistation_psvita PUBLIC
    omnistation_common
)
