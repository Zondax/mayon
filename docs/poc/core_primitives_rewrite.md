---
title: "Rewrite of core primitives crates"
sidebar_position: 4
---
As a proof of concept, we have selected some components to show how our development process can be effectively used to progressively evolve the existing Parity node. This provides the opportunity to use the aforementioned libraries , while ensuring that our project structure and tooling are as useful as planned. 

### Selection of the replaced components

While analyzing the code stability we observed that some important crates in the 
Polkadot node depend on _primitives_ modules. The primitives are mostly 
re-exports of types that are defined in Substrate but with a concrete type bound. 
This makes the primitives crates a good target to get an insight on how this 
process is going to be. We selected two primitives crates as follows:
- [`core-primitives`](https://github.com/paritytech/polkadot/tree/polkadot-v0.9.39/core-primitives)
- [`parachain primitives`](https://github.com/paritytech/polkadot/blob/polkadot-v0.9.39/parachain/src/primitives.rs)

### Module replacement
The `core-primitives` component was relatively easy to [re-write](https://github.com/Zondax/mayon/tree/main/crates/core-primitives) as it is essentially a collection of type aliases and some re-exports with a proper type bound. 
We discovered that type aliases are difficult as they are not really an instance but a new name for a type. In C++ there is a `using` keyword, but this is not supported by the cxx crate. This module re-exports important blockchain primitives.


The `parachain/primitives` module is more complex as it defines various structs, though many of them are just wrappers around Rust's primitives types like integers.



We emphasize that our current re-write -- the [`core-primitives`](https://github.com/Zondax/mayon/tree/main/crates/core-primitives) and [`parachain`](https://github.com/Zondax/mayon/tree/main/crates/parachain) repositories in [`mayon/crates`](https://github.com/Zondax/mayon/tree/main/crates) -- mostly interfaces some types to C++, so that other C++ modules can import them. We believe that it is better to
implement an FFI layer which interfaces with the  definitions of imported types.
This implies that at some point we will need to re-write the most used substrate modules and include them in our code base. We started doing this for the [`sp-primitives/runtime`](https://github.com/Zondax/mayon/tree/main/crates/sp-primitives/runtime) module, in order to define the generic types for some elements that the  core-primitives re-export from that crate. This re-write is not expected to cover all the modules from a substrate dependency but the ones that are required by the primitives definitions in Polkadot.

Substrate design separates Data from their functionality. This decouples functionality from the concrete type. This facilitates our implementation making it clear what are the methods our header instance provides, and that there would no be compilation errors from Rust due to differences between a Header instance.