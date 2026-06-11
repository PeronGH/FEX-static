# FEX-static

Static-pie builds of [FEX](https://github.com/FEX-Emu/FEX), the x86/x86-64 emulator for ARM64 Linux. The resulting single `FEX` binary needs no FEXServer, no installed RootFS (defaults to the host `/`), and no shared libraries — drop it on any arm64 box and register it with binfmt_misc.

Upstream FEX is tracked as a pristine submodule pinned in `FEX/`; this repo only carries the patches and build glue.

## Layout

- `FEX/` — shallow submodule pointing at upstream `FEX-Emu/FEX`
- `patches/` — `git am`-able patches applied on top of the pinned commit
- `scripts/apply-patches.sh` — reset the submodule to the pin and apply all patches (idempotent)
- `scripts/build.sh` — apply patches, then configure and build `build/Bin/FEX`

## Building

Requires clang, lld, cmake, ninja, nasm, and static libc/libstdc++ archives.

```sh
git clone --recurse-submodules https://github.com/PeronGH/FEX-static.git
cd FEX-static
./scripts/build.sh
```

CI builds, smoke-tests (x86-64 busybox via binfmt_misc), and publishes the binary as a GitHub release tagged with the upstream commit hash. A daily workflow bumps the submodule to upstream main when the patches still apply, and dispatches a fresh build.

## Updating upstream

```sh
git -C FEX fetch origin
git -C FEX checkout <new-upstream-commit>
./scripts/apply-patches.sh   # fix conflicts here, regenerate patches if needed
git add FEX && git commit
```

To change a patch, edit the commits in the submodule (they are real commits after `apply-patches.sh`) and regenerate with `git -C FEX format-patch --zero-commit --no-signature -o ../patches <pin>..HEAD`.
