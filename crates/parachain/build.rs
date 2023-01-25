fn main() {
    #[cfg(feature = "std")]
    compile_with_cxx();
}

#[cfg(feature = "std")]
fn compile_with_cxx() {
    let out_dir = std::env::var("OUT_DIR").expect("OUT_DIR set during compilation");
    let mut cxx = cxx_build::bridges(vec!["src/primitives_ffi.rs"]);
    cxx.flag_if_supported("-std=c++20");

    let out = cmake::Config::new(".")
        .init_cxx_cfg(cxx)
        .build_target("polkadot_parachain")
        .profile("RelWithDebInfo")
        .define("CXXBRIDGE_OUT", format!("{}/cxxbridge/sources", out_dir))
        .build();

    println!("cargo:rustc-link-search=native={}/build", out.display());
    println!("cargo:rustc-link-lib=static=polkadot_parachain");

    println!("cargo:rerun-if-changed=CMakeLists.txt");
    println!("cargo:rerun-if-changed=include/");
    println!("cargo:rerun-if-changed=src/");
}
