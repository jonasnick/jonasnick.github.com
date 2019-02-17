---
layout: post
title: "Blind Signatures in Scriptless Scripts"
date: 2018-07-31 14:53
comments: true
categories: [bitcoin, lightning, crypto]
---

<a href="https://youtu.be/XORDEX-RrAI?t=25484"><img src="/images/bob-youtube.png" width="560"></a>

At the recent Building on Bitcoin conference in Lisbon I gave a talk about a few new ideas in the scriptless scripts framework.
The first part was mainly about [blind coinswaps](https://github.com/apoelstra/scriptless-scripts/pull/1), which is a way to swap bitcoins with a tumbler without revealing which coin are swapped.
The second part about how to exchange ecash tokens peer-to-peer using scriptless scripts and Brands credentials.
You can find the talk [on youtube](https://youtu.be/XORDEX-RrAI?t=25484) and the slides [here](slides/2018-bob.pdf).
Thanks to [kanzure](https://twitter.com/kanzure) there's also a [transcript](https://diyhpl.us/wiki/transcripts/building-on-bitcoin/2018/blind-signatures-and-scriptless-scripts/) of the talk.

EDIT: I've added a note about the security of Blind Schnorr signatures against forgery to the [slides](slides/2018-bob.pdf).
In short, a naive implementation of the scheme is vulnerable to [Wagner's attack](http://www.enseignement.polytechnique.fr/informatique/profs/Francois.Morain/Master1/Crypto/projects/Wagner02.pdf).
An attacker can forge a signature using 65536 parallel signing sessions and `O(2^32)` work.
