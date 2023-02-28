---
title: "Reproducible builds with nix"
sidebar_position: 3
---

When we reached the proof of concept phase, we had to determine how we wanted the alternative modules to be integrated into the host.

Considering that Polkadot is a Rust project, making sure the crates are easy to use with cargo would render them ergonomic and idiomatic, greatly simplifying dependency management.

For this reason, we had initially investigated having a build script encapsulate the C++ build phase, which would be using CMake and Hunter (for package management), thus the crate could be easily be injected at a dependency without having to substantially change how the Polkadot Node is built, but rather just specifying a different source for a given crate.

With Hunter, one can manage dependencies for  CMake projects and automatically fetch the dependencies one need for a project.
Indeed, when using Hunter, one specifies the version of Hunter one wants to use in the CMake project. Hunter then uses this information to determine the correct versions of the dependencies needed, and fetches them. This eliminates the need to manually download and manage dependencies.

Another option we have looked into is using `Nix` to handle the dependencies 
and build of the C++ libraries. An application to `mayon` can be found in the  
[`nix`](https://github.com/Zondax/mayon/tree/main/nix) repository.

`Nix` is a powerful package manager that offers several benefits for managing project dependencies. It ensures reproducible builds,
allows for easy creation of isolated development environments and can be used for different programming languages, including C++ and Rust. Its atomic upgrades and rollbacks, along with its declarative configuration format, make it a reliable and convenient tool for managing dependencies.

With Nix, we would be using the [`crane`](https://github.com/ipetkov/crane) library to package the Rust project 
and pull in the required dependencies for a given crate, and the [`fenix`](https://github.com/nix-community/fenix) 
library to get the correct Rust version.
Due to the nature of the libraries used, some packages were not readily available in Nix and we had to package them ourselves.
To this end, between the many options, we adopted [`niv`](https://github.com/nmattia/niv). This allowed us to 
keep the repository's flake clean, whilst making it easy
to add a new source, to build a specific package for the project.

The issue with using Nix is that the build encapsulation we had previously 
developed can not be easily translated, so we came up with two different 
solutions:
- Do it the Nix way, and have Nix manage the build completely. This means 
supporting the build of the Polkadot Host entirely via Nix, by creating a Flake for the Host and pulling in the required dependencies (most directly by specifying the project's repository as input to retrieve the package with its dependencies). The advantage here is that we would have more control over the build process and the involved dependencies, but it would require users to at least get slightly familiar with Nix.
- Do it the Rust way, and have Cargo manage the build. This has the same 
  advantages as CMake + Hunter, and Nix would be invoked by the build script to pull in the dependencies for the C++ library, then build the library and make it available for linking by `Rustc`. One disadvantage with this approach is that it shifts the requirement from having cmake available to having nix available on the machine, with the latter being much less popular. It's worth mentioning that Nix portable exists, which would allow us to pull in nix as required during the build phase, but we do not have high confidence in this.

Another option exists, and that would be to support both: if Nix is available on the system then use it to pull the dependencies and manage a given library's build, so cargo can link it afterwards.
If not, then fallback to a different build system, like CMake + Hunter, to fetch the dependencies and build the project.
Of course, supporting both builds will require more effort, and we might find incompatibilities between the same dependencies pulled one way or the other.
However, with proper planning and testing, it should be possible to implement this approach and provide flexible yet robust builds for the Polkadot Host node.