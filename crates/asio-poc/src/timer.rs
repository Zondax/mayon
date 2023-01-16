use tokio::sync::mpsc::{error::TrySendError, Sender};

#[cxx::bridge]
mod ffi {
    // message type that is sent  between
    // async tasks
    pub struct Message {
        pub count: usize,
        pub msg: String,
    }

    unsafe extern "C++" {
        include!("cpp-asio-poc/include/timer.h");

        type TimerTask;

        fn newTimerTask(call: Box<RustSender>, interval: u64) -> *mut TimerTask;
        unsafe fn deleteTimerTask(task: *mut TimerTask);
        unsafe fn start(timer: *mut TimerTask);
    }

    extern "Rust" {
        type RustSender;

        pub fn try_send(sender: &RustSender, msg: Message);
    }
}

pub struct RustSender(Sender<ffi::Message>);

impl RustSender {
    pub fn new(sender: Sender<ffi::Message>) -> Self {
        Self(sender)
    }
}

pub struct TimerTask(*mut ffi::TimerTask);

unsafe impl Send for TimerTask {}

impl TimerTask {
    pub fn new(sender: Sender<ffi::Message>, interval: u64) -> Self {
        let sender = Box::new(RustSender::new(sender));
        let ptr = ffi::newTimerTask(sender, interval);
        Self(ptr)
    }

    // might need self to be pinned?
    pub fn start(&self) {
        unsafe { ffi::start(self.0) }
    }
}

impl Drop for TimerTask {
    fn drop(&mut self) {
        unsafe {
            ffi::deleteTimerTask(self.0);
        }
    }
}

pub fn try_send(sender: &RustSender, msg: ffi::Message) {
    match sender.0.try_send(msg) {
        Ok(_) => {}
        Err(TrySendError::Full(_)) => {
            log::warn!("Channel full ignoring");
        }
        Err(TrySendError::Closed(_)) => log::error!("Channel closed!"),
    }
}

pub use ffi::Message;
