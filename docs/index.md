---
title: "An Hybrid alternative Polkadot Host Node"
sidebar_position: 1
---

:::info The following project has been funded by the [Web3 Foundation](https://web3.foundation/).

<img
src={require('./web3grant.png').default}
alt="drawing"
width="300"
/>

:::

A Polkadot host provides the environment in which the runtime executes. For this reason, hosts typically evolve slowly and are based on the Polkadot specification. This specification defines the boundaries and interactions between the host implementation and the network runtime.

The polkadot network (and other related chains) have been successfully running for a few years already. There is a collective evolution and experience beyond the specifications themselves. Moreover, there are already a few other alternative implementations that have not reached production level quality yet. We consider that starting from scratch will require a significant effort and high risk objective. 

For this reason, we consider that building an alternative implementation based on a hybrid and progressive approach can minimize risk and ensure a successful roadmap. By hybrid and progressive, we mean that we will start by taking the existing Parity host based on Rust and progressively replacing substantial areas using a combination of new C++ or Rust implementations.

Given the risk and complexity of this project, we would like to propose an initial pre-engineering phase. We will focus on analysing the current situation and preparing a clear and detailed execution plan that takes into consideration possible risks and blockers.

## Project Details

This project will *not* provide a working alternative node. Instead, it will concentrate on analysing and providing a clear work plan aligned with our proposal of a hybrid approach.

As a proof of concept, we will also select a specific component (such as Keystore) and will show how our development process and be effectively used to progressively evolve the existing Parity node. 

Last but not least, a member of our research team will analyse existing specifications looking for possible gaps and risky areas. The objective is to determine possible mitigations and alternative plans beforehand.


## Technology and Languages

To minimize extensive testing and validation, we will concentrate on Linux based systems only.  Our main technology focus will be to promote modularity and replace different parts of the reference node by rewriting them in C/C++. 

At the moment of this writing, we intend to concentrate on C++ 17/20, however, we don’t disregard the possibility of using Rust in some cases. In particular, to facilitate adequate FFI between official Parity code and rewritten C/C++ or Rust code by Zondax.

At the end of this project, we will summarize our experience and make a recommendation for future work.

