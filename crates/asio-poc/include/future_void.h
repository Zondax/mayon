#pragma once

#include <future>

class FutureVoid {
    public:
      explicit FutureVoid() noexcept;
      FutureVoid(const FutureVoid&) = delete;
      FutureVoid& operator=(const FutureVoid&) = delete;

      bool valid() const {
        auto valid = future.valid();
        return valid; 
      }

      bool ready() const;

      void get();

      // The Cpp equivalent to a oneshot channel.
      std::future<void> future;
      std::promise<void> promise;


    private:
};

void deleteFutureVoid(FutureVoid *f);
