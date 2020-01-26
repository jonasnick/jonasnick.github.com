---
layout: post
title: "X-only Pubkeys and Insecure MuSig Shortcuts"
date: 2019-11-19 13:35
comments: true
categories: [bitcoin, crypto]
---

There are two posts I recently contributed to [Blockstream's engineering blog](https://medium.com/blockstream) expanding on the talk I gave at [The Lightning Conference 2019](https://www.thelightningconference.com/). Cross-posting them here because they fit the theme of this blog:

* [Reducing Bitcoin Transaction Sizes with x-only Pubkeys](https://medium.com/blockstream/reducing-bitcoin-transaction-sizes-with-x-only-pubkeys-f86476af05d7)

  > This article is about the recent introduction of so-called x-only pubkeys to the Bitcoin Improvement Proposal [BIP-schnorr](https://github.com/bitcoin/bips/blob/master/bip-0340.mediawiki) [...] significantly reducing the weight of every transaction output without any loss in security. By removing the Y-coordinate byte from compressed public keys currently used in Bitcoin, public keys end up with a 32-byte representation. We are going to look at how it works, why that’s useful, and sketch a security proof.
* [Insecure Shortcuts in MuSig](https://medium.com/blockstream/insecure-shortcuts-in-musig-2ad0d38a97da)

  > Using BIP-Schnorr-based multisignatures, no matter how many signers are involved, the result is a single public key and a single signature indistinguishable from a regular, single-signer BIP-Schnorr signature. This article is about optimizing implementations of multisignature protocols and why seemingly harmless changes can totally break the security. 
