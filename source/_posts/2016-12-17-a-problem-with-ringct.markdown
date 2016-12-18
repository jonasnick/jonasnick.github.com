---
layout: post
title: "A problem with Monero's RingCT"
date: 2016-12-17 17:33
comments: true
categories: [monero, Cpp]
---

The crypto-currency [Monero](https://getmonero.org/home) is about to introduce a new milestone in Blockchain technology: [RingCT](https://eprint.iacr.org/2015/1098).
This is a scheme that allows using [Confidential Transactions (CT)](https://people.xiph.org/~greg/confidential_values.txt) while keeping the non-interactive coin mixing typical for Monero.
CT enables hiding the transaction amounts from anyone but sender and receiver while full nodes are still able to verify that input amounts are equal to output amounts.
RingCT is currently not active in Monero; it is designed to be introduced as a hard fork early January.

I am a complete outsider to Monero and especially the Monero development community, but having reviewed the CT design and implementation ([in libsecp256k1](https://github.com/ElementsProject/secp256k1-zkp)) extensively during my day job, I was very interested in the design decisions underlying RingCT.
Very quickly I found a [red flag](https://twitter.com/n1ckler/status/801485209220718592) in the ring signature scheme called ASNL used in the range proofs.
This scheme is a new contribution by the paper and indeed turned out to be exploitable such that an **attacker would be able to create coins from nothing**.
You can find the exploit code on [GitHub](https://github.com/jonasnick/monero/commit/ad405e514c7c82bb81d7d49282fa11729420ea85) and a detailed explanation in this post.

While writing the exploit code and preparing this blog post I learned that [an anonymous person called RandomRun reported](https://github.com/monero-project/research-lab/issues/4) a flaw in the security proof of ASNL, which convinced the Monero devs to publish a [bugfix release](https://github.com/monero-project/monero/releases/tag/v0.10.1) that switches to [Borromean signatures](https://github.com/ElementsProject/borromean-signatures-writeup) (good call!).
As a result **the upcoming hard fork will not be vulnerable to this exploit**.
Interestingly, the error in the security proof is exactly the flip-side of the vulnerability I discovered.

<!-- more -->

I have the highest respect for RandomRun and parts of the Monero community.
It takes an incredibly strong character to drop an 0day worth tens of millions USD.
However, that the original hard fork schedule of RingCT remains unchanged despite a complete break of the system raises more than a few questions.
Even more so when the author of RingCT is [calling for more review](https://github.com/monero-project/research-lab/issues/4#issuecomment-256261207).

Aggregate Schnorr Non-linkable Ring Signature (ASNL)
---
Confidential transactions include a range proof to prevent negative amounts.
These range proofs use a generalization of ring signatures in which
the conjunction of multiple rings is proven, for example that the prover knows the discrete logarithm of `(Pk1 OR Pk2) AND (Pk1 OR Pk3) AND ...`
The original CT scheme introduced Borromean signatures for that purpose which are based on rings of hashes and provide space savings when public keys appear more than once.

Instead, the RingCT paper proposes a new scheme called Aggregate Schnorr Non-linkable Ring Signature because it has "perhaps simpler security proofs" (RingCT paper).

A ASNL signature consists tuples `(P1_j, P2_j, L1_j, s2_j)` for `j = 1, ..., n` and `s` which
is supposed to prove that the signer knows the DL of `(P1_1 OR P2_1) AND ... AND (P1_n OR P2_n)`.
Let's consider the `n = 1` case (no conjunction) informally.
The verifier checks that

```
L1 = s*G + H(s2*G + H(L1)*P2)*P1
```
where `H` is a hash function.

So either

* The prover knows the DL `x` of `P1` then sets
```
a, s2 <- random scalar
L1    <- a*G
s     <- a - H(s2*G + H(L1)*P2)*x
```
* Or the prover knows the DL `x` of `P2` then sets
```
a, s <- random scalar
L1   <- s*G +H(a*G)*P1
s2   <- a - x*H(L1)
```

In the case of multiple conjunctions (`n > 1`), the verifier computes `LHS <- L1_1 + ... L1_n` and `RHS <- s*G + H(s2_1*G + H(L1_1)P2_1)P1_1 + ... + H(s2_n*G + H(L1_n)P2_n)P1_n` and checks that `LHS = RHS`.
In short, this is vulnerable because you can just choose some `L1_j` such that it cancels out the summand on the right hand side where both DLs of P1 and P2 are unknown.
In contrast, the "proof" of security of ASNL assumes that any adversaries knows `a` s.t. `a*G = L1_j` for all `j`.

Forgery
---
[Implementation](https://github.com/jonasnick/monero/commit/ad405e514c7c82bb81d7d49282fa11729420ea85)
```
Theorem
Given any curve points P1_1, P2_1, an adversary is able to forge a ASNL signature
(P1_j, P2_j, L1_j, s2_j) for j=1, ..., n and s where n > 1 such that ASNL verify accepts.

Proof
Without loss of generality assume n = 2.
1. Let P1_2 = xG
    Set
    a, s2_1, s2_2 <- random scalar
    L1_1 <- a*G
    L1_2 <- H(s2_1*G + H(L1_1)*P2_1)*P1_1
    s <- a - H(s2_2*G + H(L1_2)*P2_2)*x
    Then during verification it holds that
    L1_1 + L1_2 = s*G + H(s2_1*G + H(L1_1)*P2_1)*P1_1 + H(s2_2*G + H(L1_2)*P2_2)*P1_2
    <=> L1_1 = (a - H(s2_2*G + H(L1_2)*P2_2)*x)*G + H(s2_2*G + H(L1_2)*P2_2)*P1_2
    <=> L1_1 = a*G
2. Let P2_2 = xG
    Set
    a, s, s2_1 <- random scalar
    L2_2 <- a*G
    L1_1 <- s*G + H(L2_2)*P1_2
    L1_2 <- H(s2_1*G + H(L1_1)*P2_1)*P1_1
    s2_2 <- a - H(L1_2)*x
    Then during verification it holds that
    L1_1 + L1_2 = s*G + H(s2_1*G + H(L1_1)*P2_1)*P1_1 + H(s2_2*G + H(L1_2)*P2_2)*P1_2
    <=> L1_1 = s*G + H(s2_2 + H(L1_2)*P2_2)*P1_2
    <=> L1_1 = s*G + H(a*G)*P1_2
```
