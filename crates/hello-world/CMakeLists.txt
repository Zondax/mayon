cmake_minimum_required(VERSION 3.12)
cmake_policy(SET CMP0048 NEW)
cmake_policy(SET CMP0135 NEW)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

file(GLOB HUNTER_CONFIG "${CMAKE_CURRENT_LIST_DIR}/../../cmake/config.cmake")
include(../../cmake/HunterGate.cmake)
HunterGate(
    URL "https://github.com/cpp-pm/hunter/archive/v0.23.297.tar.gz"
    SHA1 "3319fe6a3b08090df7df98dee75134d68e2ef5a3"
    #URL "https://github.com/soramitsu/soramitsu-hunter/archive/v0.23.257-soramitsu31.tar.gz"
    #SHA1 "fc89c309edac42e1ec01d74c6cd6f757e72f2492"
    FILEPATH ${HUNTER_CONFIG}
)

project(HelloWorld)
    

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
message("cpp files ${CPP_SOURCES}")

add_library(hello_world ${CPP_SOURCES} ${CXXBRIDGE_SOURCES})

set(ASIO_INCLUDE "${CMAKE_CURRENT_LIST_DIR}/../../third-party/asio/asio/include")
target_include_directories(hello_world PUBLIC ${ASIO_INCLUDE})

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
add_custom_command(TARGET hello_world
    COMMAND ${CMAKE_COMMAND} -E create_symlink "${CMAKE_CURRENT_BINARY_DIR}/compile_commands.json" "${CMAKE_CURRENT_LIST_DIR}/compile_commands.json"
    DEPENDS compile_commands.json
    VERBATIM ON
)
