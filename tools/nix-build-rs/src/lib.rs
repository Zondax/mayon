use std::path::{Path, PathBuf};

mod config;
pub use config::Config;

mod abort;

#[derive(Debug)]
pub enum Error {
    NixNotAvailable,
    BuildFailed,
}

type Result<T> = std::result::Result<T, Error>;

const NIX_BIN_NAME: &str = "nix";

/// Returns the path to the found `nix` program
///
/// Will prioritize the `NIX` environment variable if set
pub fn is_nix_available() -> Option<PathBuf> {
    std::env::var_os("NIX")
        .map(PathBuf::from)
        .or_else(|| which::which(NIX_BIN_NAME).ok())
        .and_then(|nix| {
            if nix.try_exists().ok().unwrap_or_default() {
                Some(nix)
            } else {
                None
            }
        })
}

/// Builds the project found in `path` with the default options.
///
/// Returns the directory path in which the outputs were installed.
///
/// # Examples
/// ```no_run
/// use nix_build as nix;
///
/// # fn main() -> Result<(), nix::Error> {
/// let dst = nix::build("libfoo")?;
///
/// println!("cargo:rustc-link-search=native={}", dst.display());
/// println!("cargo:rustc-link-lib=static=foo");
/// # Ok(()) }
/// ```
pub fn build(path: impl AsRef<Path>) -> Result<PathBuf> {
    Config::new(path).build()
}
