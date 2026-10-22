file(GLOB LAKE_SNES_SOURCES "lake_snes/*.c")

add_library(omnistation_snes STATIC
    snes_core.cpp
    ${LAKE_SNES_SOURCES}
)

target_include_directories(omnistation_snes PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/lake_snes
)

target_compile_options(omnistation_snes PRIVATE
    -Wno-unused-parameter
    -Wno-sign-compare
    -Wno-unused-function
    -Wno-c23-extensions
)

target_link_libraries(omnistation_snes PUBLIC
    omnistation_common
)
