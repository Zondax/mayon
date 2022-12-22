mod channel;
mod future_void;
mod timer;

pub use channel::Sender;
pub use future_void::FutureSend;
pub use timer::{Message, TimerTask};

// taken from project that uses cxx.
// protobuf-native
macro_rules! unsafe_ffi_conversions {
    ($ty:ty) => {
        #[allow(dead_code)]
        pub(crate) unsafe fn from_ffi_owned(from: *mut $ty) -> Pin<Box<Self>> {
            std::mem::transmute(from)
        }

        #[allow(dead_code)]
        pub(crate) unsafe fn from_ffi_ptr<'_a>(from: *const $ty) -> &'_a Self {
            std::mem::transmute(from)
        }

        #[allow(dead_code)]
        pub(crate) fn from_ffi_ref(from: &$ty) -> &Self {
            unsafe { std::mem::transmute(from) }
        }

        #[allow(dead_code)]
        pub(crate) unsafe fn from_ffi_mut<'_a>(from: *mut $ty) -> Pin<&'_a mut Self> {
            std::mem::transmute(from)
        }

        #[allow(dead_code)]
        pub(crate) fn as_ffi(&self) -> &$ty {
            unsafe { std::mem::transmute(self) }
        }

        #[allow(dead_code)]
        pub(crate) fn as_ffi_mut(self: Pin<&mut Self>) -> Pin<&mut $ty> {
            unsafe { std::mem::transmute(self) }
        }

        #[allow(dead_code)]
        pub(crate) fn as_ffi_mut_ptr(self: Pin<&mut Self>) -> *mut $ty {
            unsafe { std::mem::transmute(self) }
        }

        #[allow(dead_code)]
        pub(crate) unsafe fn as_ffi_mut_ptr_unpinned(&mut self) -> *mut $ty {
            std::mem::transmute(self)
        }
    };
}
pub(crate) use unsafe_ffi_conversions;
