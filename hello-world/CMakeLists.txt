cmake_minimum_required(VERSION 3.15)

file(GLOB HUNTER_CONFIG "${CMAKE_CURRENT_LIST_DIR}/../cmake/config.cmake")
include(../cmake/HunterGate.cmake)
HunterGate(
    URL "https://github.com/cpp-pm/hunter/archive/v0.24.12.tar.gz"
    SHA1 "dd581578f2fa63deb89eaf4816fa7a4b3f27dac3"
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
