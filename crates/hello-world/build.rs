use nix_build as nix;

fn main() {
    let out = if nix::is_nix_available().is_some() {
        let lockfile = "../../flake.lock";

        let pkgs = nix::exprs::nixpkgs_from_flake(lockfile, None);
        let fenix = nix::exprs::package_from_flake(lockfile, "fenix");
        let crane = nix::exprs::package_from_flake(lockfile, "crane");
        let crane = nix::exprs::nix_let(
            &[
                &format!("rust = ({fenix}).stable.toolchain"),
                &format!("crane = ({crane})"),
            ],
            "crane.overrideToolchain rust",
        );

        nix::Config::new(".")
            .add_expr("pkgs", &pkgs)
            .add_expr("crane", &crane)
            .build()
            .expect("nix build ok")
    } else {
        let out_dir = std::env::var("OUT_DIR").expect("OUT_DIR set during compilation");
        let cxxbridge_out = format!("{out_dir}/cxxbridge");

        let cxx = cxx_build::bridges(vec!["src/lib.rs", "src/foo/mod.rs"]);

        println!("cargo:rerun-if-changed=CMakeLists.txt");
        cmake::Config::new(".")
            .init_cxx_cfg(cxx)
            .build_target("hello_world")
            .profile("RelWithDebInfo")
            .define("CXXBRIDGE_OUT", &cxxbridge_out)
            .define("HUNTER_ENABLED", "ON")
            .build()
    };

    println!("cargo:rustc-link-search=native={}/build/lib", out.display());
    println!("cargo:rustc-link-lib=static=hello_world");
    println!("cargo:rerun-if-changed=include/");
    println!("cargo:rerun-if-changed=src/");
}
