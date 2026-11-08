#!/usr/bin/env bash
# Build the site and deploy it to nickler.ninja.
#
# Arguments are passed on to rsync, e.g. `./deploy.sh -n` for a dry run.
set -euo pipefail
cd "$(dirname "$0")"

if [ -n "$(git status --porcelain)" ]; then
    echo "Refusing to deploy uncommitted changes:" >&2
    git status --short >&2
    exit 1
fi

nix-shell --run "zola build"
# zola build rewrites every file, so compare by content, not modification time.
# Without a trailing slash on public, this updates /var/www/nickler.ninja/public.
rsync -av --checksum --delete "$@" public root@tommen:/var/www/nickler.ninja
