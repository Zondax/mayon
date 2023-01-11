#include <boost/bind/bind.hpp>

#include "hello-world/include/hello.h"
#include "hello-world/include/io_context.h"

#include "hello-world/src/foo/mod.rs"
#include "hello-world/src/lib.rs"

#include <cstdint>
#include <iostream>
#include "rust/cxx.h"


void hello_from_cpp() {
  hello_from_rust();
  foo();
  std::cout << "Hello from C++!" << std::endl;
}

class TimerTask::Impl
{
    public:

    Impl(long unsigned interval, rust::Box<RustSender> call); 
    void start();

    private:
        void print();

        boost::asio::steady_timer timer_;
        rust::Box<RustSender> call_;
        long unsigned  count;
};

TimerTask::Impl::Impl(long unsigned interval, rust::Box<RustSender> call) : 
    call_(std::move(call)),
    count(0),
    timer_(get_io_instance(), boost::asio::chrono::seconds(interval)){
        //auto  io = get_io_instance();
        //boost::asio::io_context  ctx = &*io; 
        //timer_(ctx, boost::asio::chrono::seconds(interval));
    }

void TimerTask::Impl::start() {
    timer_.async_wait(boost::bind(&TimerTask::Impl::print, this));
}

void TimerTask::Impl::print()
{
    
    std::string msg("From Cpp async task!!");
    Message message = { .count = count, .msg= msg };
    try_send(*call_, message);
    count += 1;
    timer_.expires_at(timer_.expiry() + boost::asio::chrono::seconds(1));
    timer_.async_wait(boost::bind(&TimerTask::Impl::print, this));
}

TimerTask::TimerTask(long unsigned int interval, rust::Box<RustSender> call): impl(new class TimerTask::Impl::Impl(interval, std::move(call))){
}


TimerTask *newTimerTask(rust::Box<RustSender> call, long unsigned interval) {
    auto timerTask = new TimerTask(interval, std::move(call));
    return timerTask;
}
void deleteTimerTask(TimerTask *task){
    delete  task;
}


