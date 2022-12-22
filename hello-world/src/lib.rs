#[cxx::bridge]
mod ffi {
    unsafe extern "C++" {
        include!("hello-world/include/hello.h");

        fn hello_from_cpp();
    }

    extern "Rust" {
        fn hello_from_rust();
    }
}

fn hello_from_rust() {
    println!("Hello from Rust!")
}

pub fn hello() {
    ffi::hello_from_cpp();
}

mod foo;
