
---
title: "Milestone 1"
sidebar_position: 2
---

## Preengineering of hybrid node and research analysis


## Deliverables

This repository contains the work done - [Let's go to the ](https://github.com/Zondax/mayon) :arrow_upper_right:


| Number | Deliverable | Specification                                                                                                                                                                                                                                                                                           | Link                                                                                                             |
| -----: | ----------- |---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------|
| **0a.** | License | GPLv3                                                                                                                                                                                                                                                                                                   | [Link](#license)                                                                                                 |
| **0b.** | Documentation | We will provide an inline documentation of the code and a basic tutorial                                                                                                                                                                                                                                | [Link](https://github.com/Zondax/mayon/blob/add-docs/README.md)                                                  |
| **0c.** | Testing and Testing Guide | Core functions will be fully covered by comprehensive unit tests to ensure functionality and robustness. In the guide, we will describe how to run these tests. We plan to write integration tests at the boundary level                                                                                | [Link](../integration/testing.md)                                                                                |
| **0d.** | Docker | We will provide a Dockerfile(s) that can be used to test all the functionality delivered with this milestone.                                                                                                                                                                                           | [Link](https://github.com/Zondax/mayon/blob/main/Dockerfile)                                                                                                           |
| 0e. | Article | We will publish an article explaining the research analysis done                                                                                                                                                                                                                                        | [Link](https://zondax.ch/blog/polkadot-hybrid-host-node)                                                                                                              |
| 1. | Research Report | We will provide a detailed report covering the review of specifications and conformance tests, the review of Polkadot Host (Parity)and the findings from the re-work of the module and primitives including recommendation practices based on this proof of concept.                                    | [Link](https://github.com/Zondax/mayon/blob/main/docs/report/HybridHost_Zondax_Report.pdf) 
| 2. | PoC code| We will provide the code from the re-worked primitives.We plan to promote modularity and replace parts of the reference node by rewriting them in C/C++.  <br/> Note: This will not be production-ready code. It is just meant to be used as a proof of concept and to inform future development plans. | [Mayon](https://github.com/Zondax/mayon) / [Host node fork](https://github.com/Zondax/polkadot/tree/poc_hybrid) |


## License

The repositories referenced in this milestone have all been published under
GNU GPLv3.

| Repository                                                                      | License   | Link                                                                                            |
|---------------------------------------------------------------------------------|-----------|-------------------------------------------------------------------------------------------------|
| [Zondax/web-docs-polkadot-node](https://github.com/Zondax/mayon/tree/main/docs) | GNU GPLv3 | [License](https://github.com/Zondax/mayon/tree/main/docs/LICENSE)              |
| [Zondax/polkadot](https://github.com/Zondax/polkadot/tree/poc_hybrid)          | GNU GPLv3 | [License](https://github.com/Zondax/polkadot/blob/hybrid_node/LICENSE) |
| [Zondax/mayon](https://github.com/Zondax/mayon)                          | GNU GPLv3 | [License](https://github.com/Zondax/mayon/LICENSE)      |
