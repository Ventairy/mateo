# Rounded convex interpolation archive

This branch preserves Mateo's rounded convex interpolation experiment for
possible future reuse. It is intentionally separate from the active simple
rounded-shape interpolation. The source and fixtures were copied unchanged
from the working checkout; this archive introduces no new interpolation math.

The archived source is based on `22969844` and includes work that had not yet
been committed. The unrelated draft Flutter package and design-system changes
are not committed on this branch. Consequently this is a source archive, not
a complete, independently buildable Flutter package.

## Contents

- `design-system/foundation/rounded-convex-interpolation.md` and its assets:
  complete equations, source outlines, numeric fixtures, and SVG examples.
- `tools/rounded_convex_interpolation/`: Python reference, geometry, motion,
  fixture generation, and verification.
- `packages/flutter/mateo-mobile/lib/src/foundation/mateo_rounded_convex_interpolation/`:
  Dart API, endpoint preparation, path handling, FFI bindings, and caches.
- `packages/flutter/mateo-mobile/src/rounded_convex_interpolation/` and
  `hook/build.dart`: native C++ kernel and native-asset build hook.
- Convex-specific foundation tests, widget tests, CI goldens, and the original
  surface flight delegate.
- Capsule and rounded-rectangle source, fixtures, and shared contour helpers
  used by the interpolation. These are dependencies copied for reference;
  they remain in the active checkout.
- `archive/rounded-convex-interpolation/context/`: original integration files,
  manifests, lockfile, surface transition tests, and simple-versus-convex
  comparison evidence. These are context snapshots, not replacements for the
  active package or a second implementation.

[The manifest](archive/rounded-convex-interpolation/manifest.json) lists every
copied file, its original path, role, archive path, and SHA-256 digest. `moved`
files are removed from the active checkout after the remote branch is
verified. `support` and `context` files remain there. Pending convex consumers
in the active checkout are intentionally left for the upcoming replacement.

## Reuse

Read the foundation and tool README first. Restore the `moved` files from this
branch into the destination package, then reconcile its current shape
primitives, API exports, native dependencies, and surface-flight integration
with the snapshots. Do not restore the context directory wholesale over newer
package work. The original native hook requires `code_assets`, `hooks`, and
`native_toolchain_c`; their versions and SDK constraints are retained in the
manifest snapshots.

The numerical reference can be explored directly in this checkout with Python
3.10 or later. `tools/rounded_convex_interpolation/README.md` documents the full
verification sweep; it is a long-running check. Flutter tests require the
surrounding draft Mateo package and its dependencies to be restored first.

Preserved test fixtures are historical evidence, not a claim that the
experiment meets a future application's rendering or performance requirements.
The archive operation verifies exact file preservation and focused reference
and C++ checks. It does not certify a complete Flutter build or device run.
