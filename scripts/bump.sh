#!/usr/bin/env bash
# Move the FEX submodule to <commit> and carry the patches along.
# A patch that still applies exactly is left untouched. Otherwise it is merged
# onto the new commit and its file is rewritten; a real conflict stops the bump.
set -euo pipefail
cd "$(dirname "$0")/.."

new=$1
fex() { git -C FEX -c user.name=FEX-static -c user.email=fex-static@localhost -c commit.gpgsign=false -c advice.mergeConflict=false "$@"; }

git submodule update --init --force --checkout FEX
fex fetch -q --depth 1 origin "$new"

# Commit each patch on the current pin, where it applies exactly. These commits
# give the merges below the base versions that a shallow checkout lacks.
picks=()
for patch in patches/*.patch; do
  fex apply --index "$PWD/$patch"
  fex commit -q -m "$(head -n 1 "$patch")"
  picks+=("$(fex rev-parse HEAD)")
done

fex checkout -q --detach "$new"
i=0
for patch in patches/*.patch; do
  if fex apply --index "$PWD/$patch" 2>/dev/null; then
    fex commit -q -m "$(head -n 1 "$patch")"
  elif fex cherry-pick "${picks[i]}" >/dev/null; then
    {
      head -n 1 "$patch"
      echo
      fex diff --no-ext-diff --no-color HEAD^ HEAD
    } >"$patch.new"
    mv "$patch.new" "$patch"
    echo "Refreshed $patch"
  else
    echo "$patch does not merge onto $new:" >&2
    fex status --short >&2
    fex cherry-pick --abort || true
    exit 1
  fi
  i=$((i + 1))
done

fex checkout -q --detach "$new"
