#pragma once

#include <thread>
#include <boost/asio.hpp>

static boost::asio::io_context &get_io_instance();
void  start_context_loop();

static boost::asio::io_context &get_io_instance()
{

    static boost::asio::io_context io;
    static bool once = [](){
        std::thread t(start_context_loop);
        t.detach();
        return true;
    } ();
    return io;
}

void  start_context_loop() {
    boost::asio::io_context &io = get_io_instance();
    boost::asio::executor_work_guard<boost::asio::io_context::executor_type> work = boost::asio::make_work_guard(io);
    //boost::asio::executor_work_guard<decltype(io.get_executor())> work{io.get_executor()};
    io.run();
}
