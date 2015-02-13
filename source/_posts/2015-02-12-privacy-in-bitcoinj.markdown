---
layout: post
title: "Privacy in BitcoinJ"
date: 2015-02-12 15:53
comments: true
categories: [bitcoin, privacy]
---

As part of my [epic quest](https://github.com/jonasnick/FCW-Kernel) to apply supervised machine learning to the blockchain in order to discover transaction patterns, I reviewed various wallet implementations in the hope of finding privacy leaks.

**tl;dr** If you are using a wallet that is built upon BitcoinJ, such as Android Wallet, Multibit and Hive Wallet, you have almost zero *wire privacy*.
An attacker who manages to connect to your wallet is easily able to figure out all addresses you control.
This is not very likely to get fixed in the near future.

<!-- more -->

Bloom Filters for SPV Nodes
---
A [Bloom filter](https://en.wikipedia.org/wiki/Bloom_filter) is a probabilistic data structure that is used to test whether an element is a member of a set.
Bitcoin SPV nodes that use [BIP 37](https://github.com/bitcoin/bips/blob/master/bip-0037.mediawiki) (we call them *thin clients* from now on) `put` all public keys they are interested in into the Bloom filter and send the filter to their peers. Upon receiving a new transaction, peers `query` the Bloom filter and only relay the transaction to the BIP 37 node if the query returned true. 
Thus, thin clients normally only receive the transactions they are really interested in, i.e. mostly transactions that include one of the wallet's keys.

The advantage of using a Bloom filter instead of just broadcasting all your pubkeys is that a Bloom filter is faster and more space-efficient 
at the cost of some *false positives*. 
That means the thin client will receive transactions that include pubkeys which were not put into the filter.
Usually, the parameters of a Bloom filter are computed such that a certain target false positive rate (`fp`) is achieved.
We want the fp rate to be relatively small (say 0.05%) to reduce bandwidth usage.

Bloom Filters and Privacy
---
BIP 37 states:
{% blockquote %}
Privacy: Because Bloom filters are probabilistic, with the false positive rate chosen by the client, nodes can trade off precision vs bandwidth usage. A node with access to lots of bandwidth may choose to have a high fp rate, meaning the remote peer cannot accurately know which transactions belong to the client and which don't.
{% endblockquote %}

This has created a misunderstanding between what is ideally possible with Bloom filters and how the reality looks like.
I'll focus on BitcoinJ because it is the most widely used implementation of BIP 37, but similar vulnerabilities might exist in other implementations as well.
Unfortunately, in the current BitcoinJ implementation Bloom filters are just as bad for your privacy as broadcasting your pubkeys directly to your peers.

A Simple Attack
---
The main idea behind this vulnerability is that BitcoinJ puts both pubkey and pubkeyhash into the Bloom filter which substantially reduces the false positive rate.

If you create a completely fresh wallet, BitcoinJ holds 271 pubkeys and computes the parameters
of the Bloom filter such that the fp rate for (271\*2)+100 elements is equal to 0.05%.
Because bitcoinj initially puts only 271\*2 elements into the filter (pubkey and corresponding pubkeyhash) the effective false positive rate is `fp=0.000146`. 

The vulnerability is that if a pubkey is truly in the filter then querying both pubkey and pubkeyhash must return true. 
Because the pubkeyhash is just another almost uniformly random string, the probability of a false positive for the attacker is `fp' = fp^2 = 0.0000000021555`.
I obtained around 56 million pubkeys from the blockchain (mid-January), which theoretically results in `56 million * fp' = 1.29` expected false positives when scanning the blockchain.

Experimental results
---
I ran 20 crawlers since the beginning of December and collected 70,000 distinct filters until now.
These crawlers just listen for a filterload message and try to be really polite by disconnecting after 2 minutes and not sending anything.
The probability that a randomly selected DNS seed returns at least one of the crawlers is 4.3%.

In fact, most of the Bloom filters from recent BitcoinJ versions show a experimental false positive rate around 0.000146.
The experimental fp rate is computed by querying the filter with millions of elements which are certainly not pubkeys.
Android Wallet 4.16, 4.17, 4.18 for example use the most recent BitcoinJ version (12.2) and make up 52% of the data.
However, there is also MultiBit 0.5.18 whose effective fp rate is smaller than 0.00000001.

We are currently starting to analyze all filters using the described "attack" and we expect that this will take several weeks.
What we've already seen is that the theoretical `fp'` really holds, i.e. if you create a fresh wallet and scan the whole blockchain you most likely get one false positive pubkey.

(Slightly) More Difficult Attacks
---
You might think that the problem is easily fixed by trading off bandwidth for more privacy and increase the fp rate to `fp = sqrt(0.0005) = 0.0224`.
On the one hand this might seriously impact the bandwidth of mobile clients, and on the other, there is another another general class of vulnerabilities concerning Bloom filters: 
If an attacker manages to obtain multiple, different filters from the same Wallet, 
he can compute the intersection of pubkeys that match the filters and therefore removes the false positive noise similar to the "simple attack".
Different filters mean that they have different total size of a different Nonce. 
Sending different filters can happen in BitcoinJ due to multiple reasons, for example

* *Restart*. BitcoinJ stores the filter's nonce in volatile memory.
* *Creation of new keys*. When the wallet creates many new keys the filter gets 'full' and thus has to be recomputed.
* *Measured false positive rate is too high*. BitcoinJ measures the false positive rate of transactions it receives. When it becomes too high the filter is recomputed.

Conclusion
---
I do think this is a critical privacy leak as it doesn't require a sophisticated attack and wallets have practically been broadcasting all their pubkeys for years.
Not only the addresses you see in your wallet, but also a lot of your future addresses have been exposed.
From now on you should assume that the kind of bulk data collection I did is happening.
It is difficult to say how accurate and stealthy targeted attacks would be.

According to Mike Hearn, the creator of BitcoinJ, the problems have been known from the start but fixing these issues is far from trivial because "lying consistently is hard". 
I fully agree with this.
**Someone needs to make it their project for a few months**.

There are some simple ideas to slightly improve the current status such as [deploying nodes that broadcast fake bloom filters](https://twitter.com/petertoddbtc/status/559921997027610624).
But with [Arthur Gervais et al., 2014](http://www.syssec.ethz.ch/content/dam/ethz/special-interest/infk/inst-infsec/system-security-group-dam/research/publications/pub2014/acsac_gervais.pdf) there is also academic research on the topic resulting in more or less reasonable suggestions.
One idea I find interesting is that thin clients should be able to install multiple filters at their peers such that no pubkey is shared between the filters.
Thus, instead of recomputing the filter when the wallet creates new addresses, it would create an entirely fresh filter for the next keys.
One disadvantage is that at the moment multiple filters per peer is not supported by the bitcoin wire protocol.
Another issue with Bloom filters is that an attacker could safely assume that the probability is higher for two pubkeys to belong to the same person if they are closer in the transaction graph. As a countermeasure the wallet could deliberately put existing foreign pubkeys that are close into the filter.

I feel sorry for the people whose privacy has been potentially compromised unknowingly by malicious parties and we certainly won't give away the data set but nonetheless it is really exciting what can be found in the data. 
If you have suggestions what to look out for and what would be interesting (not necessarily concerning machine learning) feel free to contact me.

Update
---
[Mike Hearn's reply](https://groups.google.com/forum/#!msg/bitcoinj/Ys13qkTwcNg/9qxnhwnkeoIJ) addresses additional problems and improvements.

