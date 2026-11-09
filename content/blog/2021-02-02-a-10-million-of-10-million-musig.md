+++
title = "A 10,000,000-of-10,000,000 MuSig"
date = 2021-02-02T16:29:00Z
path = "blog/2021/02/02/a-10-million-of-10-million-musig"

[taxonomies]
categories = ["bitcoin", "crypto"]
+++

This is a Taproot output for a 10,000,000-of-10,000,000 MuSig multisig:

```
01F137781B753B22F8CA5450A64104072DAC55A0CCE2B67B3797ED8131E1194D23
```

Creating it took 70 seconds on a single core with this [basic tool](https://github.com/jonasnick/musig-benchmark).
Perhaps there is an application for very large n-of-n.

Producing a signature is a different matter.
With a simple tool like this, the quadratic communication cost of MuSig1 quickly makes signing infeasible for large n: 5,000-of-5,000 already takes 140 seconds.

Update: With the new [MuSig2 module](https://github.com/ElementsProject/secp256k1-zkp/pull/131) in secp256k1-zkp, signing scales linearly, and creating a 1,000,000-of-1,000,000 signature takes about 2 minutes on a single machine.
