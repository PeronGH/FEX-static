#!/usr/bin/env bash
# Apply patches and build the static-pie FEX binary into build/Bin/FEX.
# Extra arguments are passed to the cmake configure step.
set -euo pipefail
cd "$(dirname "$0")/.."

./scripts/apply-patches.sh

cmake -S FEX -B build -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ \
  -DBUILD_FEXCONFIG=False \
  "$@"
cmake --build build --target FEX
