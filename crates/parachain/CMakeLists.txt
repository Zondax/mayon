cmake_minimum_required(VERSION 3.12)
cmake_policy(SET CMP0048 NEW)
cmake_policy(SET CMP0135 NEW)

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

project(polkadot-parachain)

set(CXXBRIDGE_OUT ${CMAKE_INSTALL_PREFIX}/cxxbridge CACHE PATH "")
message("CXXBRIDGE: ${CXXBRIDGE_OUT}")
file(GLOB_RECURSE CXXBRIDGE_SOURCES ${CXXBRIDGE_OUT}/sources/*.cc
                                    ${CXXBRIDGE_OUT}/sources/*.cpp
                                    ${CXXBRIDGE_OUT}/sources/*.c)
message("CXXBRIDGE_SOURCES: ${CXXBRIDGE_SOURCES}")

# project includes
include_directories(${CXXBRIDGE_OUT}/include ${CXXBRIDGE_OUT}/crate)

file(GLOB_RECURSE CPP_SOURCES *.cpp *.cc *.c)
add_library(polkadot_parachain ${CPP_SOURCES} ${CXXBRIDGE_SOURCES})
install(TARGETS polkadot_parachain)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
add_custom_command(TARGET polkadot_parachain
    COMMAND ${CMAKE_COMMAND} -E create_symlink "${CMAKE_CURRENT_BINARY_DIR}/compile_commands.json" "${CMAKE_CURRENT_LIST_DIR}/compile_commands.json"
    DEPENDS compile_commands.json
    VERBATIM ON
)
