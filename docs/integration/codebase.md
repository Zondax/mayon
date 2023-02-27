---
title: "Integration with fork of paritytech/polkadot"
sidebar_position: 1
---
The [core-primitives](../poc/core_primitives_rewrite.md) re-write has been 
integrated into Polkadot in our 
experimental [branch](https://github.com/Zondax/Polkadot/tree/hybrid_node). 
It allowed us to verify that compilation works, and that the node runs properly. 
We note that the integration we performed adds our changes directly to the 
[polkadot](https://github.com/Zondax/Polkadot/tree/hybrid_node) 
repository, and is not yet using the C++ 'crates' in `mayon`. However, in 
order to keep the fork light (the Polkadot repository is already quite large), 
we will be using the separate `mayon` repository in the short future.