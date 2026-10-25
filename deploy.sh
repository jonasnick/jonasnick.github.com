#!/usr/bin/env bash
# Deploy public/ to nickler.ninja.
#
# Slides are copied from source/slides/ into public/ here, so adding a talk
# only needs a commit. Any other change under source/ needs `rake generate`
# (in the Docker container) before running this.
#
# Arguments are passed on to rsync, e.g. `./deploy.sh -n` for a dry run.
set -euo pipefail
cd "$(dirname "$0")"

if [ -n "$(git status --porcelain -- source)" ]; then
    echo "Refusing to deploy uncommitted changes under source/:" >&2
    git status --short -- source >&2
    exit 1
fi

rsync -a source/slides/ public/slides/
# Without a trailing slash on public, this updates /var/www/nickler.ninja/public.
rsync -av --delete "$@" public root@tommen:/var/www/nickler.ninja
