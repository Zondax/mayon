cmake_minimum_required(VERSION 3.14.7)

project(asio LANGUAGES CXX)

option(asio_GIT_REPOSITORY "asio git repository URL" "https://github.com/chriskohlhoff/asio")
option(asio_GIT_TAG "asio git commit hash" "a71f5232d207b4f3bbd253eb1041e30b5e4ea606")

include(FetchContent)
FetchContent_Declare(asio
  GIT_REPOSITORY ${asio_GIT_REPOSITORY}
  GIT_TAG ${asio_GIT_TAG}
  CONFIGURE_COMMAND ""
  BUILD_COMMAND "")

set(asio_INCLUDE_DIR ${asio_SOURCE_DIR}/asio/include)

add_library(asio INTERFACE)
target_include_directories(asio INTERFACE ${asio_INCLUDE_DIR})

find_package(Threads)
target_link_libraries(asio INTERFACE Threads::Threads)
