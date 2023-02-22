---
title: "Mayon"
sidebar_position: 1
---

The [`mayon`](https://github.com/Zondax/mayon) repository will contain all of our C++ code, as well as the wrappers for this code, wrapping it into Rust crates, which the forked node will depend on.
`mayon`'s goal is to facilitate the integration of re-written modules into the existing node; the latter should simply depend on corresponding crates within `mayon` in a seamless manner.

##### Structure
All crates associated with this project are located within the [`crates`](https://github.com/Zondax/mayon/tree/main/crates) folder, with each sub-folder representing a distinct crate. Each crate is responsible for its own build process, though they should be relatively similar in structure.

The core of each crate comprises the `build.rs` and `CMakeLists.txt` files. 
These files are used in conjunction to enable seamless interoperability and build processes for each crate or C++ library. As mentioned above, we have decided to use `cxx` for our crates, to provide an improved experience, given that these modules are being written from scratch and will not require interfacing through a pre-existing C API. The mechanism is relatively straightforward, but certain workarounds are required to address specific issues, as detailed in [build quirks](https://github.com/Zondax/mayon/blob/main/docs/Build.md).

A template, available via [ffizer](https://github.com/ffizer/ffizer), facilitates the swift creation of new crates. This template takes care of creating the necessary files and preparing the crate for the build process. To instantiate the template, it is recommended to use the `just new` command (if [`just`](https://github.com/casey/just) is installed on your system, if not, examine the root `Justfile`).

In addition, an example [hello-world](https://github.com/Zondax/mayon/tree/main/crates/hello-world) crate has been included to demonstrate how a crate can be used as a dependency. The example can be found in the [src/bin/hello_world.rs](https://github.com/Zondax/mayon/blob/main/crates/hello-world/src/bin/hello_world.rs) file. It highlights that there is no need for specialized machinery to build and use the crate.