cmake_minimum_required(VERSION 3.12)
cmake_policy(SET CMP0048 NEW)
cmake_policy(SET CMP0135 NEW)

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)

if (HUNTER_ENABLED)
    file(GLOB HUNTER_CONFIG "${CMAKE_CURRENT_LIST_DIR}/../../cmake/config.cmake")
    include(../../cmake/HunterGate.cmake)
    HunterGate(
        URL "https://github.com/soramitsu/soramitsu-hunter/archive/v0.23.257-soramitsu31.tar.gz"
        SHA1 "fc89c309edac42e1ec01d74c6cd6f757e72f2492"
        FILEPATH ${HUNTER_CONFIG})
else()
    # Empty to avoid error "unknown function"
    function(hunter_add_package)
    endfunction()
endif()

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
hunter_add_package(libp2p)
find_package(libp2p REQUIRED)

# library
file(GLOB_RECURSE CPP_SOURCES *.cpp *.cc *.c)
add_library(hello_world ${CPP_SOURCES} ${CXXBRIDGE_SOURCES})
install(TARGETS hello_world)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
add_custom_command(TARGET hello_world
    COMMAND ${CMAKE_COMMAND} -E create_symlink "${CMAKE_CURRENT_BINARY_DIR}/compile_commands.json" "${CMAKE_CURRENT_LIST_DIR}/compile_commands.json"
    DEPENDS compile_commands.json
    VERBATIM ON
)
