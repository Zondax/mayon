fn main() {
    let out_dir = std::env::var("OUT_DIR").expect("OUT_DIR set during compilation");
    let mut cxx = cxx_build::bridges(vec!["src/timer.rs", "src/channel.rs", "src/future_void.rs"]);
    cxx.flag_if_supported("-std=c++20");

    let out = cmake::Config::new(".")
        .init_cxx_cfg(cxx)
        .build_target("cpp_asio_poc")
        .profile("RelWithDebInfo")
        .define("CXXBRIDGE_OUT", format!("{}/cxxbridge/sources", out_dir))
        .build();

    println!("cargo:rustc-link-search=native={}/build", out.display());
    println!("cargo:rustc-link-lib=static=cpp_asio_poc");

    println!("cargo:rerun-if-changed=CMakeLists.txt");
    println!("cargo:rerun-if-changed=include/");
    println!("cargo:rerun-if-changed=src/");
}
