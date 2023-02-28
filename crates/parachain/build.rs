fn main() {
    #[cfg(feature = "std")]
    compile_lib();
}

#[cfg(feature = "std")]
fn compile_lib() {
    let out_dir = std::env::var("OUT_DIR").expect("OUT_DIR set during compilation");
    let cxxbridge_out = format!("{out_dir}/cxxbridge");

    let mut cxx = cxx_build::bridges(vec!["src/primitives_ffi.rs"]);

    let out = if nix_build::is_nix_available().is_some() {
        nix_build::Config::new(".")
            .add_expr("cxxbridge-out", &cxxbridge_out)
            .build()
            .expect("nix build ok")
    } else {
        println!("cargo:rerun-if-changed=CMakeLists.txt");
        cmake::Config::new(".")
            .init_cxx_cfg(cxx)
            .build_target("polkadot_parachain")
            .profile("RelWithDebInfo")
            .define("CXXBRIDGE_OUT", &cxxbridge_out)
            .define("HUNTER_ENABLED", "ON")
            .build()
    };

    println!("cargo:rustc-link-search=native={}/build/lib", out.display());
    println!("cargo:rustc-link-lib=static=polkadot_parachain");

    println!("cargo:rerun-if-changed=include/");
    println!("cargo:rerun-if-changed=src/");
}
