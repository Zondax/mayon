#include "cpp-asio-poc/include/timer.h"
#include "cpp-asio-poc/include/io_context.h"

#include "cpp-asio-poc/src/timer.rs"

#include <cstdint>
#include <iostream>

class TimerTask::Impl
{
public:
  Impl(long unsigned interval, rust::Box<RustSender> call);
  void start();
  void cancel();

private:
  void print();

  asio::steady_timer timer_;
  rust::Box<RustSender> call_;
  long unsigned count;
};

TimerTask::Impl::Impl(long unsigned interval, rust::Box<RustSender> call)
    : call_(std::move(call)), count(0),
      timer_(get_io_instance(), asio::chrono::seconds(interval)) {}

void TimerTask::Impl::start()
{
  timer_.async_wait(std::bind(&TimerTask::Impl::print, this));
}
void TimerTask::Impl::cancel()
{
  // This method is tagged as deprecated so user should use non_error_code overload?? what that means?
  timer_.cancel();
}

void TimerTask::Impl::print()
{

  count += 1;

  // timer_.async_wait(std::bind(&TimerTask::Impl::print, this));
  timer_.async_wait([&, this](const asio::error_code &error)
                    {
    if (error == asio::error::operation_aborted)  
        return;
    std::string msg("From Cpp async task!!");
    Message message = {.count = count, .msg = msg};
    try_send(*call_, message);
    timer_.expires_at(timer_.expiry() + asio::chrono::seconds(1));
    this->print(); });
}

TimerTask::TimerTask(long unsigned int interval, rust::Box<RustSender> call)
    : impl(new class TimerTask::Impl::Impl(interval, std::move(call))) {}

void TimerTask::start()
{
  // safe as inner object is different than null
  this->impl->start();
}

void TimerTask::cancel()
{
  this->impl->cancel();
}

TimerTask *newTimerTask(rust::Box<RustSender> call, long unsigned interval)
{
  auto timerTask = new TimerTask(interval, std::move(call));
  return timerTask;
}

void deleteTimerTask(TimerTask *task)
{
  if (task != nullptr)
  {
    task->cancel();
    delete task;
  }
}

void start(TimerTask *timer)
{
  if (timer != nullptr)
  {
    timer->start();
  }
}
