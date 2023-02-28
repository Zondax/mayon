---
title: "Our proposed approach"
sidebar_position: 2
---
Our suggested approach to build an alternative Polkatot host node is modular, starting from a fork of the parity host node implementation, and gradually replacing crates with our own C++ implementations.

### From Rust to C++
We feel that re-writing the host node in C++ is the most appropriate choice of programming language.
C++ is a lower-level language than Rust and is closer to the metal. It provides greater control over system resources and over the code. This can be helpful for fine-tuning and optimizing performance, and can lead to more efficient and faster code. Furthermore, due to its long history and large user base, it is likely that we will find existing code libraries, tools, resources and examples to work with.

##### A unique approach
Despite being in C++, our proposed approach is very different to that of Soramitsu, due to our architectural vision. Indeed, our approach is modular, starting from a fork of the Parity node, and re-writing their code in C++ component by component. Consequently we should be able to have a testnet running in the early days of development, and should a component fail, it will be interchangeable with Parity's rust crates, guaranteeing high robustness of the system.

### Project structure
To maintain a modular structure, we create a separate repository for all the 
developed C++ code. This repository, called `mayon`, will also contain Rust crates, 
which act as wrappers for the C++ code. The fork will depend directly on these crates. 
Our goal is for it to be as simple as possible to switch out the original 
implementation for our own by simply changing dependencies from the original 
module to our crates within `mayon`. We achieve this structure using the `cxx` crate.
Details on our proof of concept for interfacing Rust and C++ using `cxx` are 
provided in [Mayon](../poc/mayon.md) repository.

### Navigating and improving the specifications
We suggest combining the information provided in the Polkadot specifications with help available on the  [Polkadot forum](https://forum.polkadot.network/), as well as via the Host Implementers Element channel, so as to clarify aspects of the specifications. Furthermore, we suggest collaborating with the Spec team from the Web3 Foundation, to bring the specifications up to standard. The goal, in the long run, is to have specifications which precede the implementation of changes in the Polkadot ecosystem.
This will benefit future alternate implementations of host nodes, thereby facilitating the establishment of a truly decentralized ecosystem for Polkadot. Additionally, high quality specifications mitigate the risks related to the loss of expertise, when key members -- which are holders of crucial knowledge -- leave the Polkadot ecosystem.

### Foreseen challenges
##### Async code
Handling asynchronous calls between the fork of the original Rust code and our 
C++ crates will likely present challenges. 
To make a proper assessment of interoperability between Rust async and C++ 
async paradigm, we wrote a proof of concept, detailed in [Proof of Concepts 
-- Async](../poc/async.md).

##### Handling dependencies
The proposed project requires effective package management due to the numerous dependencies involved.
We have attempted to untangle the dependencies in the original Rust project as we are re-writing certain crates in C++, but not all of those in `paritytech/polkadot` will be translated.
We used the Cargo dependency manager to track the dependencies in Parity's project. This helped us identify which crates depend on others, and potential issues that may arise as we begin to substitute C++ "crates" for the original Rust crates.
We further believe that using `nix` for building the C++ project would, in the long run, be highly beneficial, as it has advantages such as declarative package management, reproducibility, and isolation.
Hence, we created a proof of concept for the use of nix to manage the build 
process, see [Proof of Concepts
-- Reproducible builds with nix](../poc/nix.md) for details.

##### Translating Rust macros to C++
The Rust ecosystem has a tool that allows developers to expand a Rust macro into normal Rust code. For example, we used this tool to expand the [context bound](https://docs.rs/orchestra/0.0.4/orchestra/attr.contextbounds.html) macro that is used in all the subsystems that comprise the Polkadot node. 
We thus understood that this macro defines the concrete protocol, and the specific subsystem it will work with.
It is worth noting that C++ also has ways to perform compile-time code generation and manipulation, such as `constexpr` functions and `constexpr` variables, that we will use to achieve similar functionality as Rust macros.