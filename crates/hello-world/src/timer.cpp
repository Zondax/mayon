#include "hello-world/include/io_context.h"
#include "hello-world/include/timer.h"

#include "hello-world/src/lib.rs"
#include "hello-world/src/timer.rs"

#include <cstdint>
#include <iostream>


class TimerTask::Impl
{
    public:

    Impl(long unsigned interval, rust::Box<RustSender> call); 
    void start();

    private:
        void print();

        asio::steady_timer timer_;
        rust::Box<RustSender> call_;
        long unsigned  count;
};

TimerTask::Impl::Impl(long unsigned interval, rust::Box<RustSender> call) : 
    call_(std::move(call)),
    count(0),
    timer_(get_io_instance(), asio::chrono::seconds(interval)){
}

void TimerTask::Impl::start() {
    timer_.async_wait(std::bind(&TimerTask::Impl::print, this));
}

void TimerTask::Impl::print()
{
    
    std::string msg("From Cpp async task!!");
    Message message = { .count = count, .msg= msg };
    try_send(*call_, message);
    count += 1;
    timer_.expires_at(timer_.expiry() + asio::chrono::seconds(1));
    timer_.async_wait(std::bind(&TimerTask::Impl::print, this));
}

TimerTask::TimerTask(long unsigned int interval, rust::Box<RustSender> call): 
    impl(new class TimerTask::Impl::Impl(interval, std::move(call))) {}

void TimerTask::start() {
    // safe as inner object is different than null
    this->impl->start();
}

TimerTask *newTimerTask(rust::Box<RustSender> call, long unsigned interval) {
    auto timerTask = new TimerTask(interval, std::move(call));
    return timerTask;
}

void deleteTimerTask(TimerTask *task){
    if (task != nullptr)
        delete  task;
}

void start(TimerTask *timer) {
    if (timer != nullptr) {
        timer->start();
    }
}
