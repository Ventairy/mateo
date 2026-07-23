# Mateo releases

Mateo uses one repository for the design system and its public implementations,
but it does not use one version number for everything.

The root release tooling answers a narrow question: what changed, what should
get release notes, and what GitHub tag should mark that release. Building,
testing, packaging, and publishing remain owned by the package or ecosystem
that ships the implementation.

## Release lanes

### Mateo Design System

The design-system release lane covers authored Mateo contracts under
`design-system/`: foundations, platform guidance, component specifications,
semantic roles, interaction behavior, accessibility expectations, and migration
guidance.

- Version source: `design-system/version.txt`
- Changelog: `design-system/CHANGELOG.md`
- Release Please component: `mateo-design-system`
- Tag format: `mateo-design-system-v<version>`

Design-system releases describe what Mateo now promises. A design release may
ship before every platform package implements the new contract, as long as the
implementation status is clear in the release notes or compatibility guidance.

### Public packages

Each package under `packages/` releases independently. A package version
describes the installable artifact, not the whole design system.

For the current Flutter package:

- Version source: `packages/flutter/mateo-mobile-flutter/pubspec.yaml`
- Changelog: `packages/flutter/mateo-mobile-flutter/CHANGELOG.md`
- Release Please component: `mateo-mobile-flutter`
- Tag format: `mateo-mobile-flutter-v<version>`
- Dart package name: `mateo_mobile`
- Publication: pub.dev, only after the package checklist passes and publishing
  is explicitly approved.

Future packages should follow the same shape: the version lives in the
ecosystem's manifest when one exists, the changelog lives beside the package,
and validation commands are documented beside the package.

## Versioning rules

### Design-system versions

- Major: removes or renames a public design contract, changes token meaning, or
  changes component behavior in a way implementations and product teams must
  migrate.
- Minor: adds a component, platform guidance, semantic token, pattern, or public
  design capability.
- Patch: clarifies wording, repairs links, fixes examples, or corrects a spec
  mistake without changing the intended behavior.

### Package versions

Packages follow semantic versioning for their ecosystem. A package bug fix can
ship without a design-system version bump. A design-system release can ship
without a package release when the public design contract changes before an
implementation is ready.

For pre-`1.0.0` packages, treat version changes intentionally:

- Minor versions may contain breaking API changes.
- Patch versions are for compatible fixes and small compatible additions.
- Build metadata is for package metadata only.

## Change messages

Release Please reads Conventional Commit messages and assigns them to the lane
whose files changed. Use the package or design lane as the scope so history is
easy to read:

- `fix(mateo-mobile-flutter): ...` prepares a patch release.
- `feat(mateo-mobile-flutter): ...` prepares a minor release.
- `feat(mateo-mobile-flutter)!: ...` marks a breaking pre-1.0 change and
  prepares a minor release under Mateo's pre-1.0 policy.
- `fix(design-system): ...` and `feat(design-system): ...` affect only the
  design-system lane when only design-system files changed.
- `docs`, `test`, `build`, `ci`, and `chore` do not create a release by
  themselves.

A change that affects both design guidance and an implementation can release
both lanes. Keep the commits separate when their release impact differs.

## Tooling policy

Release Please runs in manifest mode from the repository root. It owns release
pull requests, changelog updates, version updates, tags, and GitHub Releases for
configured release lanes.

It does not publish packages. Publishing remains explicit and ecosystem-owned:

- Flutter/Dart uses the package Makefile and pub.dev release checklist.
- JavaScript package tooling belongs under the future JavaScript package lane.
- Swift package tooling belongs under the future Swift package lane.

Each publishing workflow is triggered only by its own package tag. Registry
credentials, approvals, build tools, and publication commands stay out of the
root release job.

## Repository setup

Release Please uses the `RELEASE_PLEASE_TOKEN` repository secret. Use a
fine-grained token or GitHub App token with access to this repository and the
contents and pull-request permissions needed to create release pull requests,
tags, and GitHub Releases. A dedicated token is required so release pull
requests run normal CI and release tags can trigger package publication
workflows.

After the initial baseline tags and GitHub Releases exist and
`RELEASE_PLEASE_TOKEN` is configured, Release Please is ready to run on every
push to `main`.

Protect `main` and require the path-specific checks that apply to each changed
artifact. Protect package tag patterns where repository policy supports it.
Registry publication should use short-lived identity such as OIDC and a GitHub
environment with required reviewers instead of a stored registry token.

The `bootstrap-sha` in `release-please-config.json` marks the last commit before
this release model was introduced. Keep it through the first managed release;
after every configured lane has a Release Please-created release, it can be
removed.

The initial `0.1.0` entries in `.release-please-manifest.json` are bootstrap
reservations. Create those initial releases manually before enabling Release
Please. After bootstrap, every manifest value must correspond to a real,
immutable release tag.

Merge the release-governance bootstrap itself with a non-releasing message such
as `chore(release): prepare polyglot release flow`. A `feat` or `fix` message on
that bootstrap commit would incorrectly prepare another package release after
automation is enabled.

## Adding a package

Every releasable package must provide the same contract, regardless of
language:

1. Put it under `packages/<ecosystem>/<package>/` with its ecosystem manifest,
   changelog, license, README, security contact, validation commands, and an
   authoritative `RELEASE_CHECKLIST.md`.
2. Give it one stable release component and tag prefix. Tag names must include
   the component, for example `mateo-web-v1.2.0`, so package releases never
   collide.
3. Add the package path to `release-please-config.json` with the closest
   supported release type. Add its last publicly released version to
   `.release-please-manifest.json`. A manual first-release reservation is
   allowed only while root release automation is disabled.
4. Add path-filtered pull-request CI that builds and tests the package as a
   standalone external consumer would.
5. Add a tag-filtered publishing workflow owned by that ecosystem. It must
   compare the tag to the package manifest, rerun the release gate, use the
   registry's short-lived authentication when available, and require an
   approval environment for real publication.
6. Document any one-time first-publication step. Turn on automated publication
   only after the registry package and its trusted identity configuration
   exist.

Release Please supports ecosystem-aware release types such as `dart` and
`node`. Use `simple` when a package has no supported manifest updater, and list
its concrete version files with `extra-files` instead of relying on a version
that exists only in release notes.

## Pull request expectations

- A design-system-only change updates design documentation and release notes
  when it changes the public design contract.
- A package-only change updates the package changelog and release notes when it
  changes the installable artifact.
- A change touching both must keep the design-system artifact as the source of
  truth and the package implementation as the realization of that artifact.
- Publication claims belong only in the package release notes after the package
  is actually published.
