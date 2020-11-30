---
layout: post
title: "BIP-{Schnorr,Taproot,Tapscript}"
date: 2020-11-29 22:59
comments: true
categories: [bitcoin, crypto]
---

<img src="/images/2020-taproot.png" width="800">

1. **BIP-Schnorr Abstract**: This document proposes a standard for 64-byte Schnorr signatures over the elliptic curve secp256k1.

2. **BIP-Taproot Abstract**: This document proposes a new SegWit version 1 output type, with spending rules based on Taproot, Schnorr signatures, and Merkle branches.

3. **BIP-Tapscript Abstract**: This document specifies the semantics of the initial scripting system under BIP341 [BIP-Taproot].

## Some highlights:

- **2018-01-23**: Taproot idea [is proposed](https://lists.linuxfoundation.org/pipermail/bitcoin-dev/2018-January/015614.html)
- **2018-04-28**: Work on BIP-Schnorr and what was known as "BIP-metas" (MErkle branches, TAproot, and Schnorr signatures) begins
- **2018-07-06**: BIP-Schnorr draft [is published](https://lists.linuxfoundation.org/pipermail/bitcoin-dev/2018-July/016203.html)
- **2018-09-25**: libsecp256k1 [schnorrsig PR opened](https://github.com/bitcoin-core/secp256k1/pull/558)
- **2019-05-06**: BIP-Taproot and BIP-Tapscript proposals [are published](https://lists.linuxfoundation.org/pipermail/bitcoin-dev/2019-May/016914.html)
- **2020-01-21**: Bitcoin Core [taproot PR opened](https://github.com/bitcoin/bitcoin/pull/17977)
- **2020-09-11**: libsecp256k1 schnorrsig PR merged
- **2020-10-15**: Bitcoin Core [taproot PR merged](https://github.com/bitcoin/bitcoin/pull/19953)
- **?**: Bitcoin Core release with activation parameters
- **?**: Taproot activation

Protip: If you have troubles memorizing BIP numbers (like me), achow101 observed that BIP-Taproot's number, 341, are the reversed digits of BIP-143. Segwit program version 0 is defined in BIP-143 and version 1 is defined in BIP-341.
