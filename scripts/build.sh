#!/usr/bin/env bash
# Apply patches and build the static-pie FEX binary into build/Bin/FEX.
# Extra arguments are passed to the cmake configure step.
set -euo pipefail
cd "$(dirname "$0")/.."

./scripts/apply-patches.sh

# -static-pie is exe-only so FEX's internal shared libs are unaffected;
# lld because GNU ld can't read ThinLTO bitcode.
# System xxhash is disabled because distros ship only the shared library.
cmake -S FEX -B build -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ \
  -DCMAKE_EXE_LINKER_FLAGS="-static-pie -fuse-ld=lld" \
  -DBUILD_FEXCONFIG=False -DENABLE_CCACHE=False \
  -DENABLE_OFFLINE_TELEMETRY=False -DENABLE_GDB_SYMBOLS=False \
  -DCMAKE_DISABLE_FIND_PACKAGE_xxhash=TRUE \
  "$@"
cmake --build build --target FEX
