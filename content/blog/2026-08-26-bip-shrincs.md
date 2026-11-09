+++
title = "BIP SHRINCS"
date = 2026-08-26T22:26:00Z
path = "blog/2026/08/26/bip-shrincs"

[taxonomies]
categories = ["bitcoin", "crypto", "post-quantum"]
+++

We published [BIP SHRINCS](https://github.com/SHRINCS/shrincs-bip/blob/main/SHRINCS.md), the first concrete proposal for a post-quantum signature scheme designed specifically for Bitcoin.
The draft BIP turns what began as a rough idea into exact algorithms with an executable reference implementation.
The discussion can now focus on analyzing, criticizing, and improving a concrete proposal.

The BIP makes choices ranging from major design questions, such as whether to support flexible XMSS and how to balance signature size against verification time, to the many smaller decisions involved in saving a byte here or there.
All of these choices are up for debate.

A lot more work lies ahead:

- The draft BIP specifies only the cryptography.
  Using SHRINCS in Bitcoin Script will require a separate BIP.
- We are working on a security proof for the exact construction and parameters.
- Wallet integration and user experience, for example around backups and recovery after state loss, are still at an early stage.

SHRINCS is not intended to be Bitcoin's "final" signature scheme, and it is not optimal along every axis.
I do think it is a very good trade-off among the options we have now.

Thanks to Mike Casey, conduition, Ethan Heilman, Mikhail Kudinov, Oleksandr Kurbatov, Boris Nagaev, and remix7531 for their contributions.
The announcement is on the [bitcoin-dev mailing list](https://groups.google.com/g/bitcoindev/c/HbVboXIFiG8).

## Background

SHRINCS combines a stateful and a stateless hash-based signature scheme.
The signer primarily uses the stateful scheme and falls back to the stateless scheme when the signing state is unavailable, for example after seed recovery.
In the current version of the draft BIP, stateful signatures are 548 to 4,619 bytes, depending on the shape of the signer's tree and how often the key has signed, and stateless signatures are 5,777 bytes.
These numbers may still change.

The stateful scheme is limited to a single device.
[SHRIMPS](https://delvingbitcoin.org/t/shrimps-2-5-kb-post-quantum-signatures-across-multiple-stateful-devices/2355) addresses multiple devices: assuming an upper bound on the number of devices initialized from the same seed (e.g., 1024), any of them creates signatures of about 2.5 KB, three times smaller than SLH-DSA.
Combined, the primary device signs with SHRINCS and backup devices with SHRIMPS, all from the same static seed backup.

At OP_NEXT 2026, I presented a toy proposal for hash-based signatures in Bitcoin that includes SHRINCS ([video](https://www.youtube.com/watch?v=ed1K_1mp9mU), [slides](/slides/2026-opnext.pdf)).
remix7531 and I also published [libshrincs](https://delvingbitcoin.org/t/libshrincs-a-c-implementation-with-a-machine-checked-security-proof/2795), a proof-of-concept C implementation of WOTS+C, the one-time signature used by SHRINCS.
Its machine-checked proofs connect the C implementation to an unforgeability theorem, which does not yet give a full post-quantum security bound.
