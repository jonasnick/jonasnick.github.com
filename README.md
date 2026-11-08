# nickler.ninja

Source of [nickler.ninja](https://nickler.ninja), built with [Zola](https://www.getzola.org).
`shell.nix` pins the Zola version.

## Writing

Posts live in `content/blog/`, one Markdown file per post:

```toml
+++
title = "Title"
date = 2026-11-08T12:00:00Z
path = "blog/2026/11/08/title"

[taxonomies]
categories = ["bitcoin"]
+++
```

The explicit `path` keeps the URL scheme of the old Octopress blog.
Text above `<!-- more -->` becomes the summary on the index pages.
Set `mathjax = true` under `[extra]` to load MathJax.

Slides and other files go into `static/`, e.g. `static/slides/2026-talk.pdf` is served at `/slides/2026-talk.pdf`.

## Building and deploying

```sh
nix-shell --run "zola serve"   # preview at http://127.0.0.1:1111
./deploy.sh -n                 # dry run: show what would change
./deploy.sh                    # build and rsync to nickler.ninja
```

`deploy.sh` refuses to run with uncommitted changes.

## Feeds

Atom IDs are built from `extra.atom_id_base` in `zola.toml`, not from `base_url`.
Never change it: changing the IDs makes feed readers show every post as new.
