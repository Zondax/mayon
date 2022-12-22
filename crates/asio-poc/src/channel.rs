use std::mem;
use std::pin::Pin;
use std::{future::Future, marker::PhantomPinned};

//use cxx::UniquePtr;

pub use crate::future_void::FutureSend;
use crate::future_void::{FutureVoid, InvalidFuture};

#[cxx::bridge]
mod ffi {

    unsafe extern "C++" {
        include!("cpp-asio-poc/include/channel.h");

        type CppSender;
        type FutureVoid = crate::future_void::FutureVoid;

        fn newChannelService(capacity: u64) -> *mut CppSender;

        // send() change obj state so the need of Pin<&mut>
        fn send(self: Pin<&mut CppSender>, value: u64) -> *mut FutureVoid;
    }

    impl UniquePtr<FutureVoid> {}
}

pub struct Sender {
    _opaque: PhantomPinned,
}

impl Sender {
    pub fn new(capacity: u64) -> Pin<Box<Sender>> {
        let sender = ffi::newChannelService(capacity);
        unsafe { Self::from_ffi_owned(sender) }
    }

    pub fn send(
        self: Pin<&mut Self>,
        value: u64,
    ) -> impl Future<Output = Result<(), InvalidFuture>> {
        self.send_impl(value)
    }

    crate::unsafe_ffi_conversions!(ffi::CppSender);
}

pub trait SenderTrait: channel_pin::Sealed {
    fn send_impl(self: Pin<&mut Self>, value: u64) -> Pin<Box<FutureSend>> {
        let f = self.upcast_mut().send(value);
        FutureSend::new(f)
    }
}

mod channel_pin {
    use std::pin::Pin;

    use super::ffi;

    pub trait Sealed {
        fn upcast(&self) -> &ffi::CppSender;
        fn upcast_mut(self: Pin<&mut Self>) -> Pin<&mut ffi::CppSender>;
        unsafe fn upcast_mut_ptr(self: Pin<&mut Self>) -> *mut ffi::CppSender {
            self.upcast_mut().get_unchecked_mut() as *mut _
        }
    }
}

impl SenderTrait for Sender {}
// we can move the pointer as the obj
// is in the heap?
unsafe impl Send for Sender {}

impl channel_pin::Sealed for Sender {
    fn upcast(&self) -> &ffi::CppSender {
        unsafe { mem::transmute(self) }
    }

    fn upcast_mut(self: Pin<&mut Self>) -> Pin<&mut ffi::CppSender> {
        unsafe { mem::transmute(self) }
    }
}
