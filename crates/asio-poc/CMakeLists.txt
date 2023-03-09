cmake_minimum_required(VERSION 3.12)
cmake_policy(SET CMP0048 NEW)
cmake_policy(SET CMP0135 NEW)

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

if (HUNTER_ENABLED)
    file(GLOB HUNTER_CONFIG "${CMAKE_CURRENT_LIST_DIR}/../../cmake/config.cmake")
    include(../../cmake/HunterGate.cmake)
    HunterGate(
        URL "https://github.com/cpp-pm/hunter/archive/v0.23.297.tar.gz"
        SHA1 "3319fe6a3b08090df7df98dee75134d68e2ef5a3"
        FILEPATH ${HUNTER_CONFIG})

    include(../../cmake/asio.cmake)
else()
    # Empty to avoid error "unknown function"
    function(hunter_add_package)
    endfunction()
endif()

project(cpp-asio-poc)

set(CXXBRIDGE_OUT ${CMAKE_INSTALL_PREFIX}/cxxbridge CACHE PATH "")
message("CXXBRIDGE: ${CXXBRIDGE_OUT}")
file(GLOB_RECURSE CXXBRIDGE_SOURCES ${CXXBRIDGE_OUT}/sources/*.cc
                                    ${CXXBRIDGE_OUT}/sources/*.cpp
                                    ${CXXBRIDGE_OUT}/sources/*.c)
message("CXXBRIDGE_SOURCES: ${CXXBRIDGE_SOURCES}")

# project includes
include_directories(${CXXBRIDGE_OUT}/include ${CXXBRIDGE_OUT}/crate)

# dependencies
hunter_add_package(Boost COMPONENTS system chrono timer)
find_package(Boost CONFIG REQUIRED system chrono timer)

file(GLOB_RECURSE CPP_SOURCES src/*.cpp
                              src/*.cc
                              src/*.c)
add_library(cpp_asio_poc ${CPP_SOURCES} ${CXXBRIDGE_SOURCES})
target_include_directories(cpp_asio_poc PRIVATE asio)
install(TARGETS cpp_asio_poc)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
add_custom_command(TARGET cpp_asio_poc
    COMMAND ${CMAKE_COMMAND} -E create_symlink "${CMAKE_CURRENT_BINARY_DIR}/compile_commands.json" "${CMAKE_CURRENT_LIST_DIR}/compile_commands.json"
    DEPENDS compile_commands.json
    VERBATIM ON
)
