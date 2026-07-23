# Mateo releases

Mateo uses independent release lanes. The design system and each public package
can ship on its own schedule.

## Release lanes

| Commit scope | Path | Version source | Changelog | Tag |
| ------------ | ---- | -------------- | --------- | --- |
| `design-system` | `design-system/` | `design-system/version.txt` | `design-system/CHANGELOG.md` | `mateo-design-system-v<version>` |
| `mateo-mobile-flutter` | `packages/flutter/mateo-mobile-flutter/` | `packages/flutter/mateo-mobile-flutter/pubspec.yaml` | `packages/flutter/mateo-mobile-flutter/CHANGELOG.md` | `mateo-mobile-flutter-v<version>` |

Design-system releases describe Mateo contracts: foundations, platform
guidance, component specifications, interaction behavior, accessibility
expectations, and migration guidance.

Package releases describe installable artifacts. A package bug fix can release
without a design-system version bump, and a design-system contract can release
before every implementation has shipped.

## Release triggers

Release Please reads Conventional Commits on `main` and opens release pull
requests for the lanes whose files changed.

Use lane scopes:

- `fix(mateo-mobile-flutter): ...` creates a patch package release.
- `feat(mateo-mobile-flutter): ...` creates a minor package release.
- `feat(mateo-mobile-flutter)!: ...` marks a breaking package change.
- `fix(design-system): ...` creates a patch design-system release.
- `feat(design-system): ...` creates a minor design-system release.

`docs`, `test`, `build`, `ci`, and `chore` do not create releases by default.
Use `fix` for consumer-visible documentation, packaging, or metadata
corrections that should appear on pub.dev or in package release notes.

## Release ownership

Release Please owns:

- release pull requests;
- changelog updates;
- manifest updates;
- version-file updates;
- GitHub tags;
- GitHub Releases.

Do not manually bump package versions, edit `.release-please-manifest.json`, or
create release tags during normal development.

Package publishing is separate from Release Please. Publishing workflows are
triggered by package tags and stay owned by the package ecosystem. The Flutter
package publishes to pub.dev only after its release gate passes and the
publication environment is approved.

## Human flow

1. Merge a normal feature or fix pull request to `main`.
2. Review the Release Please pull request for the affected lane.
3. Merge the Release Please pull request.
4. Let Release Please create the tag and GitHub Release.
5. Approve the package publishing workflow when a package tag should publish.

## Adding a package

Every releasable package must define:

- a stable path under `packages/<ecosystem>/<package>/`;
- an ecosystem manifest and package-local changelog;
- package-local validation and publication instructions;
- one commit scope and tag prefix;
- path-scoped CI for pull requests;
- tag-scoped publishing for its registry, when publication exists.

Add the package to `release-please-config.json` and
`.release-please-manifest.json` only after deciding its initial public version.
Use an ecosystem-aware Release Please type such as `dart` or `node` when
available. Use `simple` only when the ecosystem has no supported manifest
updater.
