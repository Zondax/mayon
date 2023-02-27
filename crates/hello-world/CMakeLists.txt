cmake_minimum_required(VERSION 3.12)
cmake_policy(SET CMP0048 NEW)
cmake_policy(SET CMP0135 NEW)

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)

project(HelloWorld)
set(CXXBRIDGE_OUT ${CMAKE_INSTALL_PREFIX}/cxxbridge CACHE PATH "")
message("CXXBRIDGE: ${CXXBRIDGE_OUT}")
file(GLOB_RECURSE CXXBRIDGE_SOURCES ${CXXBRIDGE_OUT}/sources/*.cc
                                    ${CXXBRIDGE_OUT}/sources/*.cpp
                                    ${CXXBRIDGE_OUT}/sources/*.c)
message("CXXBRIDGE_SOURCES: ${CXXBRIDGE_SOURCES}")

# project includes
include_directories(${CXXBRIDGE_OUT}/include ${CXXBRIDGE_OUT}/crate)

# dependencies
find_package(libp2p REQUIRED)

file(GLOB_RECURSE CPP_SOURCES *.cpp *.cc *.c)
add_library(hello_world ${CPP_SOURCES} ${CXXBRIDGE_SOURCES})
install(TARGETS hello_world)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
add_custom_command(TARGET hello_world
    COMMAND ${CMAKE_COMMAND} -E create_symlink "${CMAKE_CURRENT_BINARY_DIR}/compile_commands.json" "${CMAKE_CURRENT_LIST_DIR}/compile_commands.json"
    DEPENDS compile_commands.json
    VERBATIM ON
)
