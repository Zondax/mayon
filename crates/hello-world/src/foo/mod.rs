#[cxx::bridge]
mod ffi {
    extern "Rust" {
        fn foo();
    }
}

fn foo() {
    println!("Called `foo`")
}
