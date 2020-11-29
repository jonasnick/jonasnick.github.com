---
layout: post
title: "MuSig-DN: Schnorr Multisignatures with Verifiably Deterministic Nonces"
date: 2020-11-29 22:53
comments: true
categories: [bitcoin, crypto]
---

<a href="https://www.youtube.com/watch?v=n19vDaVrwY4"><img src="/images/2020-musig-dn.png" width="560"></a>

**Abstract**: MuSig is a multi-signature scheme for Schnorr signatures, which supports key aggregation and is secure in the plain public key model. Standard derandomization techniques for discrete logarithm-based signatures such as RFC 6979, which make the signing procedure immune to catastrophic failures in the randomness generation, are not applicable to multi-signatures as an attacker could trick an honest user into producing two different partial signatures with the same randomness, which would reveal the user's secret key.

In this paper, we propose a variant of MuSig in which signers generate their nonce deterministically as a pseudorandom function of the message and all signers' public keys and prove that they did so by providing a non-interactive zero-knowledge proof to their cosigners. The resulting scheme, which we call MuSig-DN, is the first Schnorr multi-signature scheme with deterministic signing. Therefore its signing protocol is robust against failures in the randomness generation as well as attacks trying to exploit the statefulness of the signing procedure, e.g., virtual machine rewinding attacks. As an additional benefit, a signing session in MuSig-DN requires only two rounds instead of three as required by all previous Schnorr multi-signatures including MuSig. To instantiate our construction, we identify a suitable algebraic pseudorandom function and provide an efficient implementation of this function as an arithmetic circuit. This makes it possible to realize MuSig-DN efficiently using zero-knowledge proof frameworks for arithmetic circuits which support inputs given in Pedersen commitments, e.g., Bulletproofs. We demonstrate the practicality of our technique by implementing it for the secp256k1 elliptic curve used in Bitcoin.

Read more on [the Blockstream Blog](https://medium.com/blockstream/musig-dn-schnorr-multisignatures-with-verifiably-deterministic-nonces-27424b5df9d6) or watch the [pre-recorded talk](https://www.youtube.com/watch?v=n19vDaVrwY4) we presented at the CCS 2020 conference.
