---
layout: post
title: "Intuition for Zero-Knowledge Proofs"
date: 2023-07-31 15:17
comments: true
categories: [zero-knowledge, crypto]
---

While working on [Bulletproofs++](https://eprint.iacr.org/2022/510.pdf) I realized there were gaps in my understanding of zero-knowledge proofs.
I did a quick search through the literature to find proofs for zero-knowledge that can help my understanding.
I found that either the protocols were too different to Bulletproofs(++) or the proofs seemed incomplete.

For example, in Bulletproofs, removing blinding values from the protocol does not affect the proof.
This would make it seem like the changed protocol is ZK, but upon closer inspection, it isn't.

To help developing an intuition for ZK, I created a little demo proof for a toy ZK protocol.
You can find at at

https://github.com/jonasnick/little-crypto-notebook

The toy protocol is a heavily simplified variant of Bulletproofs range proofs.
In short, it proves that a committed value is the product of two other committed values.

I hope you find the demo useful too.
My goal is to continue expanding the little crypto notebook if time permits.
