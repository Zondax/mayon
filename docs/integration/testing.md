---
title: "Testing our integration"
sidebar_position: 2
---
### Unit testing
At the moment, our C++ code is compiled as part of the Rust compilation step. Attempting to compile the C++ code directly for testing will result in failure, as the `cxx` crate generates header files that contain type definitions required by the C++ code.
To ensure that unit testing the Rust code will test the C++ code, we will 
write our unit tests as special Rust code that calls the Rust-C++ modules we want to test. A similar approach is used in Substrate, and we believe this should work effectively.
Precisely, we will have a Rust layer that interacts with C++, and it is the layer that our unit tests use.

There may also be some C++ code that is not used by the FFI interface, but is used in our C++ implementation.
The C++ code in question may include core functions such as serialization 
and deserialization, encoding and decoding, getting hashes, performing verification, and 
performing type conversions.
This code can be tested directly with C++ unit testing using the 
[doctests](https://github.com/doctest/doctest) library which also provides 
compatibility with Rust. Moreover, a make rule can be created to run the tests. 

### Integration tests
As our proof of concept is built upon a fork of the [`paritytech/polkadot`](https://github.com/paritytech/polkadot) 
repository, we can run the test suite defined in Parity's repository.
So far running Parity's `cargo` tests on our hybrid node is successful.

To run the aforementioned tests, clone our fork of the polkadot host node, 
and checkout the `hybrid_node` branch:

```
git clone git@github.com:Zondax/polkadot.git
git checkout hybrid_node
```

Then follow the [README](https://github.com/Zondax/polkadot/blob/hybrid_node/README.md) instructions to build and test the project. 
As the code-base evolves, one should use our already defined C++ testing 
framework, and add additional unit tests while writing C++ code. 