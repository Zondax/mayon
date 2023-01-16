#include <chrono>
using namespace std::chrono_literals;

#include "cpp-asio-poc/include/future_void.h"
#include "cpp-asio-poc/src/future_void.rs"

FutureVoid::FutureVoid() noexcept{
    promise = std::promise<void>();
    std::future<void> f = promise.get_future();
    future = std::move(f);
}

bool FutureVoid::ready() const {
    // The initial idea was to call 
    // future.wait_for(0s) which does not block
    // but this would require passing a waker to the upper 
    // Rust future that wrap-up  FutureVoid, to that it can 
    // "wake" the future to poll it when ready.
    future.wait();
    return true;
}

void FutureVoid::get() {
    future.get();
}

void deleteFutureVoid(FutureVoid *f) {
    delete f;
}
