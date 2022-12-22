cmake_minimum_required(VERSION 3.15)

include(FetchContent)
FetchContent_Declare(SetupHunter GIT_REPOSITORY https://github.com/cpp-pm/gate)
FetchContent_MakeAvailable(SetupHunter)

project(HelloWorld CXX)

# dependencies
hunter_add_package(libp2p)
find_package(libp2p REQUIRED)

if(NOT DEFINED CXXBRIDGE_OUT)
  message(FATAL_ERROR "no cxx bridge sources found!")
endif()
file(GLOB_RECURSE CXXBRIDGE_SOURCES ${CXXBRIDGE_OUT}/*.cc)
message("CXXBRIDGE_SOURCES: ${CXXBRIDGE_SOURCES}")

add_library(hello_world src/hello.cpp ${CXXBRIDGE_SOURCES})
