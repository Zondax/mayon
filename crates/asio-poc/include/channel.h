#pragma once

#include <cstdint>
#include <iostream>
#include <memory>
#include <future>

#include <asio.hpp>
#include <asio/experimental/awaitable_operators.hpp>
#include <asio/experimental/concurrent_channel.hpp>

#include "cpp-asio-poc/include/types.h"
#include "cpp-asio-poc/include/future_void.h"
#include "rust/cxx.h"

using asio::experimental::concurrent_channel;

using msg_channel =
    concurrent_channel<void(asio::error_code, long unsigned int)>;

class CppSender {
public:
  CppSender(msg_channel tx) : tx(std::move(tx)){};
  CppSender(const CppSender&) = delete;
  CppSender& operator=(const CppSender&) = delete;

  ~CppSender() { 
      tx.close(); 
  }

  FutureVoid *send(long unsigned int value);
  void close();

  msg_channel tx;

};


CppSender *newChannelService(long unsigned int capacity);
