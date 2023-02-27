---
title: "Overview"
sidebar_position: 1
---

In this project, we identified challenges and evaluated the feasibility of creating an alternative Polkadot host node.
To this end, we first conducted an initial research phase, in order to evaluate the state of available resources; 
in particular that of specifications and existing implementations.
This analysis guided our proposal of a hybrid approach, which will create an alternative node in a modular fashion, 
starting from a fork of the only existing production level node (that or Parity Technologies, written in Rust), 
and replacing crate by crate their code with our own implementation in C++.
In a second phase, we implemented a number of proofs of concepts, in order to demonstrate the feasibility of our 
proposal. The knowledge gained from these proofs of concepts then benefitted our proof of concept for actual integration 
with a fork of the Polkadot node.