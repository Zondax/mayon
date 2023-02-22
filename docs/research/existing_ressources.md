---
title: "Assessment of existing resources"
sidebar_position: 1
---

### Review of specifications and conformance tests
Though there are official specifications for the host node, there is a collective 
evolution and experience beyond the official specifications. Indeed, looking into 
the Web3 foundation's [official specifications](https://spec.polkadot.
network/#part-polkadot-host) and [test suite](https://github.com/w3f/polkadot-tests), 
and 
comparing them 
to the only host node in production (that of [Parity Technologies](https://www.parity.io/technologies/polkadot/)), it is clear 
that a substantial amount of the documentation is missing. Furthermore, it is not 
uncommon to find errors, or poorly defined notions, which could lead to potential 
errors in the implementation. Regarding the specification tests, whose purpose 
is to be ran against the different implementations of Polkadot, these do not 
cover all requirements of a host node (there are many aspects deep inside APIs 
that are difficult to test); but rather exist to tangibly demonstrate the growth 
of a project implementing Polkadot, which should pass increasingly many tests in 
that suite. 

### Existing implementations

##### Production level host node
Parity Technologies has developed an implementation of the Polkadot host node, 
which is the central component of the Polkadot network, responsible for managing 
and facilitating communication between different blockchain networks. 
This host node (`[paritytech/polkadot](https://github.com/paritytech/polkadot)`) 
is written in Rust and is designed to be fast, scalable, and secure. It is used in production as the reference implementation of the host node and is the most widely used implementation. It is an important part of the Polkadot network and is constantly being updated and improved by Parity Technologies and a wide community of developers.
Notably, this is the only Polkadot host node which has reached production level. 

##### Other host node implementations (not yet production level)
Gossamer is a project developed and maintained by Chainsafe Systems, 
written in the Go programming language which includes its own implementation 
of the host node.
In parallel, KAGOME, which is developed and maintained by Soramitsu, 
also has its own C++ implementation of the host node.
Neither of these implementations have yet reached production level, 
and both are being written from scratch, based on the official specifications 
for the Polkadot host node.

As seen in previous paragraphs, the specifications alone are not reliable 
enough to build a production-level host node, and the `paritytech/polkadot` 
code base changes at too fast a rate (ahead of the specifications) for projects 
building a host node _from scratch_ to successfully adapt and follow Parity's rhythm.
We believe this is one of the main reasons Kagome and Gossamer have not yet reached production level.

### Review of Polkadot Host (Parity)
Due to the fact that the specifications alone are not sufficient to build a 
host node, we suggest also using the code-base of Parity's host node as a 
reference. Jumping ahead a little, our proposed approach to building a host 
node on the Polkadot network is modular, starting from a fork of `paritytech/polkadot`, and replacing components with our own C++ implementations one at a time. The goal here is to divide the task into smaller, more manageable modules, that can be implemented and tested separately.
As Parity's note is written in Rust, it is cut into crates. Hence, the 
minimal units we can replace will be these crates, and we are somewhat 
restricted to follow the architecture of their project.

We hereby expose challenges related to such a dependence on the `paritytech/polkadot` code base. 

##### Code churn & dependencies
Though the host node is meant to be stable, the `paritytech/polkadot` code base continuously evolves. This complicates the re-writing process, and implies the need for a strategy ensuring that modules, which have been re-written, stay up to date with Parity's host node.

As Parity's node implementation is written in Rust, crates split the code into reusable and composable pieces. We will take the crates as areas of the Polkadot host node which we believe can be implemented independently.

For evaluation of code stability, we use a tool called [Hercules](https://github.com/src-d/hercules) to get a variety of stats on the history of project files. We thus obtained an objective evaluation of which crates are most stable, as opposed to those that are subject to high levels of change.
Since the project also heavily depends on external crates -- namely from Substrate -- we also evaluated the number of updates the `Cargo.toml` files, and the complexity and code churn of these dependencies.

The large graph of dependencies, involving crates from Substrate, is a risk factor of our proposed approach. Firstly because Rust's Cargo provides a more streamlined and integrated experience for managing dependencies compared to the use of third-party tools in C++; secondly because some of the Substrate crates will also require re-implementing; and finally, as we will be moving some parts of the host node’s code to C++, while still having crates in rust which depend on the original (Rust) crate, these dependencies will most likely cause a number of compile-time errors (in the event of e.g. changes on dependencies or types). 

##### Rust macros
Parity's Polkadot node makes extensive use of macros in Rust throughout the code, which will make the task of re-writing the project in C++ more challenging. This is because macros in Rust are expanded at compile-time, and they can generate complex code that may not be straightforward to translate to C++.

To re-implement macros in C++, we will need to manually translate the macro logic to C++ code. This can be a time-consuming and error-prone process, as we will need to understand the behavior of the macros and ensure that the C++ code behaves the same way.