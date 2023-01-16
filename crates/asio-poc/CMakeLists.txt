cmake_minimum_required(VERSION 3.12)
cmake_policy(SET CMP0048 NEW)
cmake_policy(SET CMP0135 NEW)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

file(GLOB HUNTER_CONFIG "${CMAKE_CURRENT_LIST_DIR}/../../cmake/config.cmake")
include(../../cmake/HunterGate.cmake)
HunterGate(
    URL "https://github.com/cpp-pm/hunter/archive/v0.23.297.tar.gz"
    SHA1 "3319fe6a3b08090df7df98dee75134d68e2ef5a3"
    FILEPATH ${HUNTER_CONFIG}
)

project(cpp-asio-poc)

# dependencies
hunter_add_package(Boost COMPONENTS system chrono timer )
find_package(Boost CONFIG REQUIRED system chrono timer )

if(NOT DEFINED CXXBRIDGE_OUT)
  message(FATAL_ERROR "no cxx bridge sources found!")
endif()
file(GLOB_RECURSE CXXBRIDGE_SOURCES ${CXXBRIDGE_OUT}/*.cc
                                    ${CXXBRIDGE_OUT}/*.cpp
                                    ${CXXBRIDGE_OUT}/*.c)
message("CXXBRIDGE_SOURCES: ${CXXBRIDGE_SOURCES}")

file(GLOB_RECURSE CPP_SOURCES *.cpp *.cc *.c)

add_library(cpp_asio_poc ${CPP_SOURCES} ${CXXBRIDGE_SOURCES})

set(ASIO_INCLUDE "${CMAKE_CURRENT_LIST_DIR}/../../third-party/asio/asio/include")
target_include_directories(cpp_asio_poc PUBLIC ${ASIO_INCLUDE})

add_custom_command(TARGET cpp_asio_poc
    COMMAND ${CMAKE_COMMAND} -E create_symlink "${CMAKE_CURRENT_BINARY_DIR}/compile_commands.json" "${CMAKE_CURRENT_LIST_DIR}/compile_commands.json"
    DEPENDS compile_commands.json
    VERBATIM ON
)
