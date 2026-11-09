+++
title = "gpg --verify Needs the Data File"
date = 2026-09-09T17:08:00Z
path = "blog/2026/09/09/gpg-verify-needs-the-data-file"

[taxonomies]
categories = ["security", "nix"]
+++

For detached signatures, this command is easily bypassable:

```
gpg --verify SHA256SUMS.asc
```

The correct command requires the data file:

```
gpg --verify SHA256SUMS.asc SHA256SUMS
```

Without the second argument, gpg succeeds even if the `.asc` file contains an arbitrary embedded message instead of a signature of the actual `SHA256SUMS` file.
gpg prints a warning, but it is easily missed in its output.
The gpg manpage explicitly discourages the single-argument form and keeps it only for backward compatibility.

This appears to be a common mistake.
I keep a list of gpg pitfalls, and this is number 8.
Mehdi Kerimov reported it in nix-bitcoin's self-updater through the nix-bitcoin bounty program.
nix-bitcoin had originally followed the verification instructions on bitcoincore.org, which had the same issue and have since been fixed.
That this sat unnoticed on bitcoincore.org since 2018 shows how little known this footgun is.

It is unlikely that bad signatures were ever published at scale, because anyone noticing the warning or using the two-argument command would have caught it immediately.
