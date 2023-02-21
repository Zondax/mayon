# Mayon Repository

This repository will contain all of our C++ code, as well as the wrapping Rust crates that will be depended on by our fork of the Polkadot node.
The idea is to have a central repository with all our modules and then make it painless and seamless to integrate with the existing node, simply by depending to the corresponding crate in the repository.

# How crates are built
All crates in the project are under the `crates` folder, with each subfolder being a separate crate.
Each crate is responsible for it's own build, but they should also be fairly similar.

The core of each crate is the `build.rs` and `CMakeLists.txt`, these 2 work in conjunction to allow seamless interoperabilty and building of each crate and/or C++ library. 
We decided to use `cxx` for our crates to provide a better experience, considering we'll be writing these modules from scratch and we don't need to interface via some kind of already made C API. 
The mechanism isn't too complicated, but there are some workarounds for different issues, see [build quirks](./docs/Build.md) for more info.

# Adding new crates
A template (via `ffizer`) is provided to allow easy and quick creation of a new crate, taking care of creating the right files and preparing the crate to orchestrate the build, simply use `just new` (if you have [`just`](https://github.com/casey/just) installed, otherwise take a look at the root [`Justfile`](./Justfile)) to instantiate the template.

An example `hello-world` crate is also present, which is what the template is based off and shows how it can be used as a dependency (in the [`bin/hello_world.rs`](./crates/hello-world/src/bin/hello_world.rs) file), as there's no need for any special machinery to build and use the crate.
