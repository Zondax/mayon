//use futures::channel::oneshot;
use tokio::sync::mpsc::{error::TrySendError, Sender};

#[cxx::bridge]
mod ffi {
    // message type that is sent  between
    // async tasks
    struct Message {
        count: usize,
        msg: String,
    }

    unsafe extern "C++" {
        include!("hello-world/include/hello.h");

        type CppSender;
        type TimerTask;

        fn newTimerTask(call: Box<RustSender>, interval: u64) -> *mut TimerTask;
        unsafe fn deleteTimerTask(task: *mut TimerTask);

        fn start_recv_task() -> UniquePtr<CppSender>;

        fn hello_from_cpp();
    }

    extern "Rust" {
        type RustSender;

        fn hello_from_rust();

        fn try_send(sender: &RustSender, msg: Message);
    }
}

pub struct RustSender(Sender<ffi::Message>);

//pub use crate::ffi::{start_recv_task, start_timer_task};

fn hello_from_rust() {
    println!("Hello from Rust!")
}

pub fn hello() {
    ffi::hello_from_cpp();
}

pub fn try_send(sender: &RustSender, msg: crate::ffi::Message) {
    println!("sending");
    match sender.0.try_send(msg) {
        Ok(_) => {}
        Err(TrySendError::Full(_)) => {
            log::warn!("Channel full ignoring");
        }
        Err(TrySendError::Closed(_)) => log::error!("Channel closed!"),
    }
}

mod foo;
