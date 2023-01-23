#include "cpp-asio-poc/include/channel.h"
#include "cpp-asio-poc/src/channel.rs"
#include "cpp-asio-poc/include/io_context.h"

#include <asio/use_future.hpp>

using asio::as_tuple;
using asio::awaitable;
using asio::buffer;
using asio::co_spawn;
using asio::detached;

using asio::io_context;
using asio::steady_timer;
using asio::use_awaitable;
using asio::ip::tcp;
namespace this_coro = asio::this_coro;
using namespace asio::experimental::awaitable_operators;
using namespace std::literals::chrono_literals;

FutureVoid *CppSender::send(long unsigned int value)
{

    auto future = new FutureVoid();

    try
    {
        tx.async_send(asio::error_code{}, value, [value, future](asio::error_code error)
                      {
            if (!error){
                future->promise.set_value();

            } else {
                std::printf("async_send fatal error\n");
            } });
    }
    catch (const std::exception &)
    {
        std::printf("async_send exception\n");
    }
    return future;
}

void receive(msg_channel &rx)
{
    try
    {
        // there are different flavors, use_awaitable, use_future, and this one where we pass
        // a callback.
        rx.async_receive([&rx](asio::error_code error, int i)
                         {
                             if (!error)
                             {
                                 std::printf("Cpp Async channel rx: %d \n", i);
                                 receive(rx);
                             }
                         });
    }
    catch (const std::exception &)
    {
        std::printf("async_recv exception\n");
    }
}
//   Other methods --------------------------------------------------------------->

CppSender *newChannelService(long unsigned int capacity)
{

    auto ex = get_io_instance().get_executor();

    msg_channel tx(ex, capacity);
    auto channels = new CppSender(std::move(tx));

    receive(channels->tx);

    return channels;
}
