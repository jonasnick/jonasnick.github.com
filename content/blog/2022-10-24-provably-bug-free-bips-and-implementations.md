+++
title = "Provably Bug-Free BIPs & Implementations"
date = 2022-10-24T12:00:00Z
path = "blog/2022/10/24/provably-bug-free-bips-and-implementations"

[taxonomies]
categories = ["bitcoin", "crypto"]
+++

At TABConf 2022, I gave a talk titled "Provably Bug-Free BIPs & Implementations".

Specifications should be free of bugs, easy to implement, and hard to misinterpret, which makes writing them a slow and exhausting process.
Cryptographic BIPs such as BIP-MuSig2 contain pseudocode, which is not executable, and Python reference code, which is tested but means whatever the Python interpreter does.
Errors can creep in between the paper with its security proof, the specification, the reference code, and the implementations.

The talk presents a small step towards improving this.
The specification in the [draft BIP for half-aggregation](https://github.com/BlockstreamResearch/cross-input-aggregation/blob/master/half-aggregation.mediawiki) of BIP 340 signatures is written in [hacspec](https://github.com/hacspec/hacspec), a language for succinct, executable, and verifiable cryptographic specifications embedded in Rust.
Because hacspec has formal semantics, proof assistants can be used to prove that the specification is free of out-of-bounds array accesses and integer overflows, that it is complete (aggregating valid BIP 340 signatures always yields a valid half-aggregate signature), and that an implementation behaves exactly like the specification.
Such proofs, for example in Coq, currently require very specialized skills and a lot of work.
Perhaps proof engineering gets easier in the future.

[Slides](/slides/2022-tabconf.pdf)
