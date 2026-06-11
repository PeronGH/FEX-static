#!/usr/bin/env bash
# Reset the FEX submodule to its pinned commit and apply all patches on top.
# Idempotent: re-running discards previously applied patches first.
set -euo pipefail
cd "$(dirname "$0")/.."

git submodule update --init --force --checkout FEX
git -C FEX am --abort 2>/dev/null || true
git -c user.name=patches -c user.email=patches@localhost -C FEX am --3way "$PWD"/patches/*.patch
