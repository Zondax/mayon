use std::{
    ffi::{OsStr, OsString},
    path::{Path, PathBuf},
    process::Command,
};

use crate::{Error, Result};

enum NixTarget {
    File(OsString),
    Flake(String),
}

impl Default for NixTarget {
    fn default() -> Self {
        Self::File(OsString::from("default.nix"))
    }
}

/// Build style configration for a pending build.
pub struct Config {
    path: PathBuf,
    nixfile: NixTarget,
    exprs: Vec<(String, String)>,
    out_dir: PathBuf,
}

impl Config {
    pub fn new(path: impl AsRef<Path>) -> Self {
        Self {
            path: std::env::current_dir().unwrap().join(path.as_ref()),
            nixfile: NixTarget::default(),
            exprs: vec![("pkgs".to_owned(), "import <nixpkgs> {}".to_owned())],
            out_dir: PathBuf::from(crate::abort::getenv_unwrap("OUT_DIR")),
        }
    }

    /// Add an argument to the invoked nix expression
    pub fn add_arg(&mut self, name: &str, value: &str) -> &mut Self {
        self.exprs.push((name.to_owned(), value.to_owned()));
        self
    }

    /// Build the derivation described by the given .nix file
    pub fn nix_file(&mut self, filename: impl AsRef<OsStr>) -> &mut Self {
        self.nixfile = NixTarget::File(filename.as_ref().to_owned());
        self
    }

    /// Build the derivation described by the given flake output
    pub fn flake(&mut self, flake: &str) -> &mut Self {
        self.nixfile = NixTarget::Flake(flake.to_owned());
        self
    }

    pub fn build(&mut self) -> Result<PathBuf> {
        let nix = crate::is_nix_available().ok_or(Error::NixNotAvailable)?;

        let mut cmd = Command::new(nix);
        cmd.current_dir(&self.path);
        cmd.arg("build");

        cmd.args(&[
            "-o",
            &format!("{}/build", self.out_dir.display().to_string()),
        ]);

        match &self.nixfile {
            NixTarget::File(file) => {
                cmd.args(&[OsStr::new("-f"), &file]);

                // make sure the build script is rerun if the file changes
                println!(
                    "cargo:rerun-if-changed={}",
                    AsRef::<Path>::as_ref(file).display()
                );
            }
            NixTarget::Flake(name) => {
                cmd.arg(&name);
            }
        }

        for (key, val) in &self.exprs {
            cmd.args(&["--arg", &key, &val]);
        }

        if !cmd
            .spawn()
            .expect("unable to spawn build job")
            .wait()
            .expect("unable to finish build job")
            .success()
        {
            return Err(Error::BuildFailed);
        }

        Ok(self.out_dir.clone())
    }
}
