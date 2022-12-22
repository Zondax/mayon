//use cxx::UniquePtr;
pub use ffi::FutureVoid;
use std::task::Poll;
use std::{fmt::Display, future::Future, marker::PhantomPinned, mem, pin::Pin};

#[derive(Debug)]
pub struct InvalidFuture;

impl Display for InvalidFuture {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.write_str("std::future<void> invalid state")
    }
}

#[cxx::bridge]
mod ffi {

    unsafe extern "C++" {
        include!("cpp-asio-poc/include/future_void.h");

        pub type FutureVoid;

        fn ready(self: &FutureVoid) -> bool;

        fn valid(self: &FutureVoid) -> bool;

        // get changes the obj state which
        // requires the used of Pin<&mut>
        fn get(self: Pin<&mut FutureVoid>);

        unsafe fn deleteFutureVoid(f: *mut FutureVoid);

    }
}

pub struct FutureSend {
    _inner: PhantomPinned,
}

impl FutureSend {
    pub fn new(f: *mut ffi::FutureVoid) -> Pin<Box<FutureSend>> {
        unsafe { Self::from_ffi_owned(f) }
    }

    // macro taken form another project that uses Cxx
    // protobuf-native
    crate::unsafe_ffi_conversions!(ffi::FutureVoid);
}

impl FutureSend {
    pub fn ready(self: Pin<&mut Self>) -> Result<bool, InvalidFuture> {
        let ready = {
            let ffi = self.as_ffi();
            if !ffi.valid() {
                return Err(InvalidFuture);
            }
            ffi.ready()
        };
        if ready {
            self.upcast_mut().get();
        }
        Ok(ready)
    }

    fn upcast_mut(self: Pin<&mut Self>) -> Pin<&mut ffi::FutureVoid> {
        unsafe { mem::transmute(self) }
    }
}

impl Future for FutureSend {
    type Output = Result<(), InvalidFuture>;

    fn poll(self: Pin<&mut Self>, cx: &mut std::task::Context<'_>) -> Poll<Self::Output> {
        let ready = self.ready();
        // The best option here is to spawn a thread
        // that pulls the FutureSend->transmute->FutureVoid->future.ready();
        // and exits when it is ready, this would need a waker so we tell the runtime
        // to pull this future again. all this for treating a std::promise<>/std::future<>
        // pair as a sort of oneshot channel.
        // another solution is to pass a rust-oneshot channel to any C++ coroutine
        // so when it completes triggers the receiver which is a rust future, so  need
        // of a waker but would require other artifacts so C++ deal with that.
        match ready {
            Ok(true) => Poll::Ready(Ok(())),
            Ok(false) => Poll::Pending,
            _ => Poll::Ready(Err(InvalidFuture)),
        }
    }
}

impl Drop for FutureSend {
    fn drop(&mut self) {
        // this might not be necessary depending if the type has mutable methods.
        // if that is not the case, we can wrap it in an UniquePtr type, which takes care of
        // calling its C++ destructor.
        unsafe { ffi::deleteFutureVoid(self.as_ffi_mut_ptr_unpinned()) }
    }
}
