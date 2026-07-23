# Pub.dev release checklist

This is the authoritative publication procedure for the `mateo_mobile` Dart
package. Run commands from `packages/flutter/mateo-mobile-flutter` through its
Makefile. Never publish from a feature branch or an unreviewed working tree.

## Every release

- Update consumer documentation, examples, migration guidance, and
  `CHANGELOG.md` for user-visible changes.
- Confirm `pubspec.yaml` uses `mateo_mobile` and consumer examples import
  `package:mateo_mobile/mateo_mobile.dart`.
- Run generation and inspect the generated diff.
- Run `make release-check`. It must pass formatting, analysis, all tests and CI
  goldens, Dartdoc link validation, example analysis, publish dry-run, archive
  validation, and the pre-publication pana baseline.
- Inspect the dry-run archive. Agent files, overrides, caches, local
  `pubspec.lock` files, tests, and local platform goldens must be absent.
- Merge only after the `mateo-mobile-flutter / Release checks` job passes.
- Release only the reviewed commit on protected `main`.
- Confirm the immutable tag is
  `mateo-mobile-flutter-v<pubspec version>` and points to that commit.
