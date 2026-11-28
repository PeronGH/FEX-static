# Contributing

FEX-static is upstream [FEX](https://github.com/FEX-Emu/FEX) plus a small set of patches in `patches/`. A daily job bumps the upstream pin for as long as every patch still applies, so each patch carried here is a standing maintenance cost.

## Principles

1. **Behave like `qemu-user-static`.** Features that a single static binary does not need, or that cannot work without a RootFS or FEXServer, can be dropped or stubbed out.
2. **Fix bugs that are specific to this setup.** Bugs that only show up when FEX runs as a static binfmt_misc handler with no RootFS, and not in the official setup, are fixed here. If the bug also reproduces on official FEX, please report it upstream too, so the patch can be dropped once upstream fixes it.
3. **Avoid churn.** A patch should be small and unlikely to break when upstream moves. Change only the lines the fix needs, prefer code that upstream rarely touches, and do not refactor or reformat around it.

## AI-assisted contributions

AI-assisted and AI-written contributions are welcome here; only the end result matters. Upstream FEX does not accept AI-generated code, and we fully respect that decision.

## Patches

- One plain unified diff per change, named `patches/NNNN-Short-description.patch`: a one-line title, a blank line, then the diff against the pinned `FEX/` commit.
- Mark changed code with a `// FEX-static:` comment that says why it differs from upstream.

## Testing

`./scripts/build.sh` applies all patches and builds `build/Bin/FEX`. CI does not run on pull requests, so describe in the PR how you tested the change. A minimal reproduction is best: a small x86 program, run as `FEX ./program`, that fails before the patch and passes after.
