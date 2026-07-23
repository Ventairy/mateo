# Pub.dev release checklist

This is the authoritative publication procedure for the `mateo_mobile` Dart
package. Run commands from `packages/flutter/mateo-mobile-flutter` through its
Makefile. Never publish from a feature branch or an unreviewed working tree.

## Every release

- Update consumer documentation, examples, migration guidance, and
  `CHANGELOG.md` for user-visible changes.
- Confirm `pubspec.yaml` uses `mateo_mobile` and consumer examples import
  `package:mateo_mobile/mateo_mobile.dart`.
- Confirm the hosted `oh_my_flutter` constraint resolves without an override.
- Run generation and inspect the generated diff.
- Run `make release-check`. It must pass formatting, analysis, all tests and CI
  goldens, Dartdoc link validation, example analysis, publish dry-run, archive
  validation, and the pre-publication pana baseline.
- Inspect the dry-run archive. Agent files, overrides, caches, development
  lockfiles, tests, and local platform goldens must be absent.
- Merge only after the `mateo-mobile-flutter / Release checks` job passes.
- Release only the reviewed commit on protected `main`.
- Confirm the immutable tag is
  `mateo-mobile-flutter-v<pubspec version>` and points to that commit.

## First release: 0.1.0

Pub.dev requires the first version of a new package to be published manually.
The repository variable `PUB_AUTOMATION_ENABLED` must remain unset or `false`
for this release.

1. Merge the release preparation through the normal protected-main pull
   request flow.
2. Check out the merged `main` commit in a clean worktree and run
   `make release-check` again without local dependency overrides.
3. Create the local immutable tag `mateo-mobile-flutter-v0.1.0` at that exact
   commit and verify that `pubspec.yaml` contains `version: 0.1.0`.
4. From the clean locally tagged worktree, run `fvm flutter pub publish`. This
   command requires explicit authorization and the uploader's authenticated
   pub.dev account.
5. Verify `mateo_mobile` `0.1.0` on pub.dev, including its README, API docs,
   license, archive contents, platforms, and pana score.
6. Push the already-published immutable tag. The publish workflow should be
   skipped while automation is disabled.
7. Create the GitHub Release from the same tag and use the package changelog as
   its release notes.
8. Run `PANA_MAX_DEFICIT=0 make pana` against the released source. Keep later
   publication blocked on pana's maximum score.

## Enable later releases

After `0.1.0` is visible on pub.dev:

1. In the package's pub.dev Admin tab, enable GitHub Actions publishing for
   repository `Ventairy/mateo` with tag pattern
   `mateo-mobile-flutter-v{{version}}`.
2. Require the GitHub Actions environment named `pub.dev`.
3. Create that environment in GitHub and add required reviewers.
4. Set the repository variable `PUB_AUTOMATION_ENABLED` to `true`.
5. Keep `RELEASE_PLEASE_TOKEN` configured for Release Please. Its token must be
   able to open release pull requests and push release tags so the tag-driven
   publication workflow runs.

For later versions, Release Please updates the package version and changelog in
its package-specific release pull request. Merging that pull request creates the
package tag and GitHub Release. The tag then runs the full release gate and,
after environment approval, publishes that exact version to pub.dev.
