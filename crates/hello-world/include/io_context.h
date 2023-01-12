#pragma once

#include <thread>
#include <asio.hpp>

asio::io_context &get_io_instance();
