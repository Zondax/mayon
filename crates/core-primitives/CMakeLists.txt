cmake_minimum_required(VERSION 3.12)
cmake_policy(SET CMP0048 NEW)
cmake_policy(SET CMP0135 NEW)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# We do  not need hunter for this package

project(polkadot-core-primitives)

if(NOT DEFINED CXXBRIDGE_OUT)
  message(FATAL_ERROR "no cxx bridge sources found!")
endif()
file(GLOB_RECURSE CXXBRIDGE_SOURCES ${CXXBRIDGE_OUT}/*.cc
                                    ${CXXBRIDGE_OUT}/*.cpp
                                    ${CXXBRIDGE_OUT}/*.c)
message("CXXBRIDGE_SOURCES: ${CXXBRIDGE_SOURCES}")

file(GLOB_RECURSE CPP_SOURCES *.cpp *.cc *.c)

add_library(core_primitives ${CPP_SOURCES} ${CXXBRIDGE_SOURCES})

add_custom_command(TARGET core_primitives
    COMMAND ${CMAKE_COMMAND} -E create_symlink "${CMAKE_CURRENT_BINARY_DIR}/compile_commands.json" "${CMAKE_CURRENT_LIST_DIR}/compile_commands.json"
    DEPENDS compile_commands.json
    VERBATIM ON
)
