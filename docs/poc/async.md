---
title: "Asynchronous calls between Rust/C++ using Asio"
sidebar_position: 2
---

Managing asynchrony between the fork of the original Rust code and our C++ crates will likely present challenges. Though the C++ community’s knowledge regarding the async features in C++ is sparse, our team is working towards gaining a comprehensive understanding of the key concepts and libraries that will be utilized, in order to ensure a solid foundation for the project. We also note that C++20 introduces new features in the language that makes writing asynchronous code much more natural. We further intend to incorporate C++23 features as soon as they are available in the main compilers, one of the most important for this project is `std::expected`. This feature is meant to facilitate error handling without the need of throwing exceptions.
Let’s take a closer look at how this affects our proposed project. The Rust crate `cxx` allows calling C++ code from Rust using Rust’s FFI (Foreign Function Interface). It can be used to expose C++ code to a Rust project, but it does not provide any built-in support for handling asynchronous C++ code.
To call asynchronous C++ code from Rust, we will need to write the asynchronous code in C++, and then use `cxx` to call the C++ functions that perform the asynchronous operations. The asynchrony will thus be
handled at the level of C++ code. For example, using [`Asio`](https://think-async.com/Asio/), callbacks will be registered in C++ as completion handlers, and those callbacks will need to interact with Rust code through the FFI.

In order to make a proper assessment regarding interoperability between Rust 
async and C++ async paradigm, we decided to write a [proof of concept](https://github.com/Zondax/mayon/tree/main/crates/asio-poc),
that has asynchronous Rust tasks interacting with C++ tasks using [`Asio`](https://think-async.com/Asio/). The tasks use async channels to talk to each other, this model resembles the current Polkadot design which makes use of channels also to decouple subsystems.

Overall, using `cxx` to call asynchronous C++ code from Rust is possible, 
but it will be more challenging than using Rust's built-in `async/await` 
functionality, and it will require effort and care to handle the 
synchronization and communication between the Rust and C++ code correctly. 
This is due to a subtle difference between Rust async model and C++, the latter does not use a wake-up mechanism to tell the executor poll the task that is ready, so it would be necessary to add a layer between both to coordinate and connect tasks from both. We found an opinionated rust crate called [`cxx-async`](https://crates.io/crates/cxx-async), which is based on `cxx` and aims to facilitate this process. 