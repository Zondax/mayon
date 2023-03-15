# Mayon Repository

This repository will contain all of our C++ code, as well as the wrapping Rust crates that will be depended on by our fork of the Polkadot node.
The idea is to have a central repository with all our modules and then make it painless and seamless to integrate with the existing node, simply by depending to the corresponding crate in the repository.

# Quick start
The easiest and recommended way is to use `nix` by means of `nix-shell`, 
this will prepare an environemtn with all the dependencies necessary to 
build the project or run unit tests with `cargo test`.

We also provide a `Dockerfile` to build an image with the same environment as outlined above.
To build the image a script is provided at `./scripts/build_docker.sh <image_name>`.
The purpose of the script is to attempt to speed up the image build using the host nix store if present, 
otherwise everything will be built from inside the image during the build.

# Proofs of concepts
### The core_primitives re-write
While analyzing the code stability we observed that some important crates in the
Polkadot node depend on _primitives_ modules. The primitives are mostly
re-exports of types that are defined in Substrate but with a concrete type bound.
This makes the primitives crates a good target to get an insight on how this
process is going to be. We selected two primitives crates as follows:
- [`core-primitives`](https://github.com/paritytech/polkadot/tree/master/core-primitives)
- [`parachain primitives`](https://github.com/paritytech/polkadot/blob/master/parachain/src/primitives.rs)

The [`crates`](https://github.com/Zondax/mayon/tree/main/crates) 
repository contains our re-write of
[`core-primitives`](https://github.com/Zondax/mayon/tree/main/crates/core-primitives) and 
[`parachain`](https://github.com/Zondax/mayon/tree/main/crates/parachain).

### Reproducible builds with `Nix`
To handle the dependencies and build of the C++ libraries,
we have looked into is using `Nix`.

`Nix` is a powerful package manager that offers several benefits for managing project dependencies. 
It ensures reproducible builds, allows for easy creation of isolated development environments 
and can be used for different programming languages, including C++ and Rust.

### Asynchronous C++/Rust tasks with Asio
In order to make a proper assessment regarding interoperability between Rust
async and C++ async paradigms, we wrote a 
[proof of concept](https://github.com/Zondax/mayon/tree/main/crates/asio-poc) 
that has asynchronous Rust tasks interacting with C++ tasks using 
[`Asio`](https://think-async.com/Asio/). 
The tasks use async channels to talk to each other, 
this model resembles the current Polkadot design which makes use of channels 
also to decouple subsystems.

# How crates are built
All crates in the project are under the `crates` folder, with each subfolder being a separate crate.
Each crate is responsible for it's own build, but they should also be fairly similar.

The core of each crate is the `build.rs` and `CMakeLists.txt`, 
these 2 work in conjunction to allow seamless interoperabilty 
and building of each crate and/or C++ library.

We decided to use `cxx` for our crates to provide a better experience, considering we'll be writing these modules from scratch and we don't need to interface via some kind of already made C API. 
The mechanism isn't too complicated, but there are some workarounds for different issues, see [build quirks](./docs/Build.md) for more info.

# Adding new crates
A template (via `ffizer`) is provided to allow easy and quick creation of a new crate, 
taking care of creating the right files and preparing the crate to orchestrate the build, 
simply use `just new` (if you have [`just`](https://github.com/casey/just) installed, otherwise take a look at the root [`Justfile`](./Justfile)) 
to instantiate the template.

An example `hello-world` crate is also present, 
which is what the template is based off and shows how it can be used as a dependency 
(in the [`bin/hello_world.rs`](./crates/hello-world/src/bin/hello_world.rs) file), 
as there's no need for any special machinery to build and use the crate.

# Final report

Our final research report can be found [here](https://github.com/Zondax/mayon/blob/main/docs/report/HybridHost_Zondax_Report.pdf)

It  summarizes our findings and analysis to create an alternate host node for the Polkadot network, using a hybrid and progressive approach. 
