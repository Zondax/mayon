#pragma once

#include "rust/cxx.h"
#include <memory>
#include "hello-world/include/types.h"

class TimerTask {
    public:
        TimerTask(long unsigned int interval, rust::Box<RustSender> call);//: impl(new class TimerTask::Impl(interval, call)){};
        void start();

    private:
        class Impl;
        std::unique_ptr<Impl> impl;
};


// will take in a sender
// that is used to send messages to a rust async task  
// once the timer triggers
TimerTask *newTimerTask(rust::Box<RustSender> call, long unsigned interval);

void deleteTimerTask(TimerTask *task);
void start(TimerTask *timer);

