#pragma once
#include <cstdint>
#include <memory>
#include "rust/cxx.h"

struct Message;
struct RustSender;
struct CppSender;
// Type cpp will use to send data
// to an async task in rust.
struct RustSender;

class CppSender {
    public:
        CppSender();
        void send() const;
        bool is_close();
    private:
        class impl;
        std::shared_ptr<impl> impl;

};

class TimerTask {
    public:
        //TimerTask(unsigned int interval, rust::Fn<void(rust::Box<RustSender>, Message msg)> call);
        //TimerTask(unsigned int interval, rust::Box<RustSender> call): impl(new class TimerTask::Impl(interval, call)){};
        TimerTask(long unsigned int interval, rust::Box<RustSender> call);//: impl(new class TimerTask::Impl(interval, call)){};
        void start();

    private:
        class Impl;
        std::unique_ptr<Impl> impl;
};

std::unique_ptr<CppSender> start_recv_task();
// will take in a sender
// that is used to send messages to a rust async task  
// once the timer triggers
//void start_timer_task(rust::Fn<void(rust::Box<RustSender>, Message msg)> call);
//void start_timer_task(rust::Box<RustSender> call, long unsigned interval); 
TimerTask *newTimerTask(rust::Box<RustSender> call, long unsigned interval);
void deleteTimerTask(TimerTask *task);

void hello_from_cpp();

