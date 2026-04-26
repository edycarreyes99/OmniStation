include(FetchContent)
FetchContent_Declare(
    googletest
    GIT_REPOSITORY https://github.com/google/googletest.git
    GIT_TAG v1.14.0
)
set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
FetchContent_MakeAvailable(googletest)

add_executable(omnistation_tests
    tests_main.cpp
)

target_link_libraries(omnistation_tests PRIVATE
    GTest::gtest
    omnistation_common
    omnistation_gpu
    omnistation_snes
    omnistation_ps1
    omnistation_ps2
    omnistation_ps3
    native_gpu_bridge
)

include(GoogleTest)
gtest_discover_tests(omnistation_tests)
