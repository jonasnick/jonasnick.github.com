+++
title = "Shielded CSV: Private and Efficient Client-Side Validation"
date = 2024-09-20T18:15:00Z
path = "blog/2024/09/20/shielded-csv"

[taxonomies]
categories = ["bitcoin", "crypto", "privacy"]
+++

Liam Eagen, Robin Linus and I published [Shielded CSV](https://eprint.iacr.org/2025/068.pdf), the first fully private client-side validation (CSV) protocol, which hides the transaction history.

- The size and verification cost of a coin proof are independent of the transaction history.
- Every transaction costs 64 bytes on-chain, regardless of its size.
- It supports t-of-n accounts and atomic swaps.

Assuming a bridge to Bitcoin, Shielded CSV enables 100 private Bitcoin transactions per second.
Compared to private cryptocurrencies, the expensive zero-knowledge proofs never land on-chain and need not be verified by all full nodes.
The protocol specification is written in [Rust](https://github.com/ShieldedCSV/ShieldedCSV).

It took me a very long time to realize the potential of client-side validation, but I think this may be just the beginning.

Update: I gave a [talk about Shielded CSV](https://www.youtube.com/watch?v=aZa2zXp1Q2A) at the Bitcoin Conference 2025 ([slides](/slides/2025-bitcoin2025.pdf)).
This [write-up](https://insider.btcpp.dev/p/some-of-us-still-want-private-bitcoin) on the btc++ insider is a good introduction as well.
