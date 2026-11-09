+++
title = "Hash-Based Signatures for Bitcoin"
date = 2025-12-09T14:59:00Z
path = "blog/2025/12/09/hash-based-signatures-for-bitcoin"

[taxonomies]
categories = ["bitcoin", "crypto", "post-quantum"]
+++

Mikhail Kudinov and I at Blockstream Research published [Hash-based Signatures for Bitcoin](https://eprint.iacr.org/2025/2203.pdf), an analysis of post-quantum signature schemes.
The paper is a gentle introduction to hash-based schemes and explores how to optimize them for Bitcoin.

Hash-based signatures are conceptually simple and rely solely on hash functions, a primitive Bitcoin already trusts.
NIST has standardized SLH-DSA (SPHINCS+), but the paper investigates alternatives that are better suited to Bitcoin's needs.
It explores in detail how optimizations and parameter choices affect size and performance.
Signatures can be reduced to about 3–4 KB, which is comparable to the lattice-based ML-DSA.

The paper also discusses:

- trade-offs between stateless and stateful schemes,
- compatibility with HD wallets,
- limitations of current approaches for multi- and threshold signatures,
- security targets.

We welcome feedback, particularly on hardware performance requirements and standardization choices.
The scripts that generate the parameter analysis are on [GitHub](https://github.com/BlockstreamResearch/SPHINCS-Parameters).
