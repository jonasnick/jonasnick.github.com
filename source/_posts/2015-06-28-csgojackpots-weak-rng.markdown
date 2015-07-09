---
layout: post
title: "CSGOJackpot's weak RNG"
date: 2015-06-28 00:42
comments: true
categories: [C, javascript, security]
---

[CSGOJackpot](https://csgojackpot.com) is a gambling website where players bet and win Counter Strike Go 'skins' (weapon textures).
Because these items can only be found by playing a lot of CSGo, they are quite rare and valuable,  
and can be exchanged for example in Steam's own Marketplace. 
What is fascinating about CSGOJackpot and initially captured my attention is the sheer amount
of value that is gambled away. On average, more than 20,000$ are thrown into the pots per hour. 

**TL;DR**: CSGOJackpot is a node.js app that uses *Math.random()* to determine the winning ticket. Of course, it's not cryptographically
secure and trivial to predict the next number given two outputs of the random number generator.
I did not try to profit from this vulnerability but for the lulz I set up a twitch stream and revealed the next winning percentage
in exchange for a drawing of Gabe Newell. See the [submission gallery](https://github.com/jonasnick/jonasnick.github.com/blob/source/source/images/gaben/README.md) and a [recording of the stream](https://www.youtube.com/watch?v=DZrDQKbQ7r0).

<!-- more -->

Game Mechanics
---
CSGOJackpot works like this:

1. Start of a new round, the pot is empty.
2. A player puts up to 10 skins into the pot and receives a number of *tickets* relative to the total value of skins he deposited. For each cent he receives one ticket, the tickets are numbered and start at 0. The value of a skin is given by [SteamAnalyst](http://csgo.steamanalyst.com).
3. If there are less than 50 skins in the pot go to 2.
4. The site generated a random number (*winning percentage*) between 0 and 1, which is multiplied with the total number of 
tickets to determine the winning ticket.
5. The player with the winning ticket wins the whole pot, except up to 5% which is kept by CSGOJackpot.

In addition to guessing the winning percentage, an attacker has to know the total number of tickets to be sure to win the pot.
So, he has to try to place the last bet which can be tricky and is very difficult during times of high traffic because of huge lags.

"Breaking" the RNG
---
The HTML showed some signs of node.js, so my hypothesis was that the site simply uses javascript's Math.random() to determine the winning percentage.
Fortunately, the full winning percentage with up to 16 digits is published after the end of a round, which is exactly the amount of digits I 
got when I executed Math.random() on my machine.
Node.js uses the V8 javascript engine and its [implementation](https://github.com/joyent/node/blob/61c6abf00898fe00eb7fcf2c23ba0b01cf12034c/deps/v8/src/math.js#L146) of Math.random() (nodejs 0.12.X) is as follows:
``` javascript
function MathRandom() {
  var r0 = (MathImul(18273, rngstate[0] & 0xFFFF) + (rngstate[0] >>> 16)) | 0;
  rngstate[0] = r0;
  var r1 = (MathImul(36969, rngstate[1] & 0xFFFF) + (rngstate[1] >>> 16)) | 0;
  rngstate[1] = r1;
  var x = ((r0 << 16) + (r1 & 0xFFFF)) | 0;
  // Division by 0x100000000 through multiplication by reciprocal.
  return (x < 0 ? (x + 0x100000000) : x) * 2.3283064365386962890625e-10;
}
```
This is known as [Marsaglia's Multiply-with-Carry](https://groups.google.com/forum/#!msg/sci.stat.math/5yb0jwf1stw/ApaXM3IRy-0J).
Note that the implementation used in nodejs 0.10.X uses a very similar algorithm, but it's implemented in C and the conversion to floating point is done differently.

So the RNG state has 64 bits and 32 bits immediately leak from a single output. Given two subsequent outputs one can bruteforce the remaining
32 bits of the states which takes about 30 seconds on a 3.0Ghz i7 core (implemented in C).
However, this failed to produce the correct state, so my guess was that there are some calls to Math.random() in between two winning percentages.
It turned out that the the number of calls between varies between 8 and 35 and brute forcing this required a third winning percentage and around
5 hours in expectancy. So now I had the correct state, which I verified by creating the next 50 numbers and checking if they contained the next winning percentages.
But I didn't find any pattern by which I could determine which of the next random numbers is going to be winning percentage.
Fortunately, there is another feature of CSGOJackpot which made this trivial.


"Provably Fair"
---
The site claims to be *provably fair*. But this is not really the case. What they are doing is a simple commitment to the winning percentage
, by publishing a hash `md5(blinding + winning percentage)` before the round (where the blinding is a uniformly random hexstring) 
and revealing the blinding and winning percentage at the end of the round. Thus, they can not adjust the winning percentage to their
liking during or after the round. But, naturally, provable fairness implies that even the server does not know the winning percentage ahead of time.

However, this feature made it possible to reliably predict the next winning percentage.
I observed that the blinding just consists of two calls to Math.random() which were converted to hex with `toString(16).substr(2,4)`
and then concatenated. So now I just had to step through the next winning percentage candidates and the next blinding candidates and
check if their hash matched the commitment.

One more word to provably fairness. It's quite annoying to see CSGOJackpot and the many other sites that work similarly to 
make exactly the same false claim.
I'm not a cryptographer so take the following with a grain of salt and I'd be happy learn if I'm missing something important.
A truly fair scheme seems to be possible although much more complex to implement. 
The underlying problem is known as [coin flipping](https://en.wikipedia.org/wiki/Commitment_scheme#Coin_flipping).
In a two player setting you can have each player commit to a value
and then XOR the value in the reveal phase to get a statistically independent result. 
This is how for example [Satoshi Dice](https://satoshidice.com/provably-fair/) achieves some level of fairness.

However, in a multi-party setting (assuming the existence of a broadcast channel), this can be trivially [Sybil attacked](https://en.wikipedia.org/wiki/Sybil_attack). An attacker could create multiple identities and refuse to reveal one of his commitments, if another one of his identities wins the pot.
A trivial Sybil-resistant construction would have each player loose more when not revealing than what is in the pot, but this does not seem really practical.
Another approach is to use [time-lock encryption](http://www.hashcash.org/papers/time-lock.pdf) instead of commitments, which means that after a some time everybody can decrypt the value without having access to the key.

Exploitation
---
I didn't play this game at all (it would have been unfair :) ), but for the lulz I had to at least troll them a bit.
So I set up a twitch stream where I was revealing the next winning percentages in exchange for a drawing of Gabe Newell.
I privately disclosed the bug to the administrator the moment I started the stream.
<iframe width="560" height="315" src="https://www.youtube.com/embed/DZrDQKbQ7r0" frameborder="0" allowfullscreen></iframe>
See also the [submission gallery](https://github.com/jonasnick/jonasnick.github.com/blob/source/source/images/gaben/README.md).
After 2 hours of fun they fixed the issue.
Interestingly, googling "nodejs cryptographically secure random number generator" did not really result in plug-and-play solutions for me.
Without knowing about the pitfalls of javascript I suggested to use `crypto.randomBytes(4).readUIntLE(0, 4) / 0xFFFFFFFF` (if this is somehow wrong please
write me a message).
Unfortunately, so far they didn't remove the "provable fairness" claim.
