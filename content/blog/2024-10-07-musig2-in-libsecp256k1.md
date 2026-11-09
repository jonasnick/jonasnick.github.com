+++
title = "MuSig2 in libsecp256k1"
date = 2024-10-07T15:25:00Z
path = "blog/2024/10/07/musig2-in-libsecp256k1"

[taxonomies]
categories = ["bitcoin", "crypto"]
+++

The MuSig2 module has been merged into libsecp256k1 and will be part of the next release.
This makes [MuSig2](/blog/2020/11/29/musig2-simple-two-round-schnorr-multisignatures/) available to all projects that use libsecp256k1.

The module is designed to be as safe to use as possible.
Its [documentation](https://github.com/bitcoin-core/secp256k1/blob/master/include/secp256k1_musig.h) gives two rules that prevent nonce reuse if the implementer follows them.
See the [example](https://github.com/bitcoin-core/secp256k1/blob/master/examples/musig.c) for how to use it.

Since its merge into libsecp256k1-zkp, the module received 333 review comments, and no significant security issue was found.
Thanks to the reviewers Tim Ruffing, Sebastian Falbesoner, Pieter Wuille, Josie Baker, Sivaram Dhakshinamoorthy, Martin Habovštiak, and Bastien Teinturier.

Update: The module was released in [libsecp256k1 v0.6.0](https://github.com/bitcoin-core/secp256k1/releases/tag/v0.6.0) on November 4, 2024.
