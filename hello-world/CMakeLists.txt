cmake_minimum_required(VERSION 3.12)
cmake_policy(SET CMP0048 NEW)
cmake_policy(SET CMP0135 NEW)

file(GLOB HUNTER_CONFIG "${CMAKE_CURRENT_LIST_DIR}/../cmake/config.cmake")
include(../cmake/HunterGate.cmake)
HunterGate(
    URL "https://github.com/soramitsu/soramitsu-hunter/archive/v0.23.257-soramitsu31.tar.gz"
    SHA1 "fc89c309edac42e1ec01d74c6cd6f757e72f2492"
    FILEPATH ${HUNTER_CONFIG}
)

project(HelloWorld)

# dependencies
hunter_add_package(libp2p)
find_package(libp2p REQUIRED)

if(NOT DEFINED CXXBRIDGE_OUT)
  message(FATAL_ERROR "no cxx bridge sources found!")
endif()
file(GLOB_RECURSE CXXBRIDGE_SOURCES ${CXXBRIDGE_OUT}/*.cc)
message("CXXBRIDGE_SOURCES: ${CXXBRIDGE_SOURCES}")

add_library(hello_world src/hello.cpp ${CXXBRIDGE_SOURCES})
