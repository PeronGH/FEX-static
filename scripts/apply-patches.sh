#!/usr/bin/env bash
# Reset the FEX submodule to its pinned commit and apply all patches on top.
# Idempotent: re-running discards previously applied patches first.
set -euo pipefail
cd "$(dirname "$0")/.."

git submodule update --init --force --checkout FEX
git -C FEX apply --3way "$PWD"/patches/*.patch
