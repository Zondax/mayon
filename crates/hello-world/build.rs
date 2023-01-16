fn main() {
    let out_dir = std::env::var("OUT_DIR").expect("OUT_DIR set during compilation");
    let cxx = cxx_build::bridges(vec!["src/lib.rs", "src/foo/mod.rs"]);

    let out = cmake::Config::new(".")
        .init_cxx_cfg(cxx)
        .build_target("hello_world")
        .profile("RelWithDebInfo")
        .define("CXXBRIDGE_OUT", format!("{}/cxxbridge/sources", out_dir))
        .build();

    println!("cargo:rustc-link-search=native={}/build", out.display());
    println!("cargo:rustc-link-lib=static=hello_world");

    println!("cargo:rerun-if-changed=CMakeLists.txt");
    println!("cargo:rerun-if-changed=include/");
    println!("cargo:rerun-if-changed=src/");
}
