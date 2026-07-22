# Pub.dev release checklist

- Run package commands through the package Makefile or from
  `packages/flutter/mateo-mobile-flutter`.
- Confirm `pubspec.yaml` uses `mateo_mobile` and every consumer example imports
  `package:mateo_mobile/mateo_mobile.dart`.
- Update README, guides, example, API docs, and `CHANGELOG.md` for user-visible
  changes.
- Confirm `version` and the leading `CHANGELOG.md` entry describe this release.
- Confirm the hosted `oh_my_flutter` constraint resolves without overrides.
- Remove `publish_to: none` only when this package is approved for publication.
- Enable the required CI `make pana` step and confirm the maximum score.
- Run generation and inspect its diff before committing.
- Run `make check`, `make publish-dry-run`, and `make pana`, then inspect the
  publish archive.
- Confirm agent files, overrides, caches, and local platform goldens are absent
  from the publish archive.
- Confirm CI goldens are intentional and pass on Linux CI.
- Tag protected `main` with `v<pubspec version>` and create the GitHub Release.
- Confirm the tag matches `pubspec.yaml`; tags are immutable.
- The first pub.dev release is manual. Never publish from an unreviewed working
  tree, and never run `pub publish` without explicit authorization.
