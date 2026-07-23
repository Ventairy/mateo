# Contributing to Mateo

Thank you for helping Mateo become clearer, warmer, and more useful. You do not
need to know the whole system before contributing. A focused bug report,
documentation correction, test, component idea, or implementation improvement
is welcome.

By participating, you agree to follow the
[Code of Conduct](CODE_OF_CONDUCT.md).

## Before starting

- Search existing issues before opening a new one.
- Open an issue before a broad component, foundation, or public API change so
  the direction can be shaped together.
- Small fixes and documentation improvements can go directly to a pull
  request.
- Report vulnerabilities privately through [SECURITY.md](SECURITY.md), never in
  a public issue.

## Choose the source

- `design-system/` owns foundations, platform guidance, and component
  contracts.
- `packages/` owns installable implementations of those contracts.
- `.github/`, `RELEASES.md`, and root community files own repository
  collaboration and release governance.

When implementation reveals a missing design decision, update or propose the
design-system artifact first. Package code must not quietly become a competing
specification.

## Make a contribution

1. Fork the repository or create a branch from the latest `main`.
2. Keep the change focused. Avoid unrelated formatting or refactors.
3. Follow the nearest `AGENTS.md` and the conventions beside the files you
   change.
4. Run the relevant local validation.
5. Open a pull request and complete the template.
6. Respond to review and keep the branch current until all required checks
   pass.

Local commit history can be informal. Pull requests are squash-merged, so the
pull request title is the Conventional Commit that reaches `main` and drives
release notes.

Use one of these title shapes:

```text
fix(mateo-mobile-flutter): correct toast positioning
feat(mateo-mobile-flutter): add a segmented control
feat(design-system): define segmented control behavior
docs(design-system): clarify reduced-motion guidance
test(mateo-mobile-flutter): cover large text scaling
chore(repo): improve contribution checks
```

Use `!` before the colon for a breaking public change, for example
`feat(mateo-mobile-flutter)!: simplify the button API`. Release-producing
changes (`feat`, `fix`, `perf`, and `refactor`) require a scope. Titles are
validated automatically, and maintainers can help correct one before merge.

## Flutter package

The Flutter implementation lives in
`packages/flutter/mateo-mobile-flutter`. Use Flutter 3.44.0 through FVM and run:

```bash
make setup
make check
```

Bug fixes need regression coverage. New widgets need focused behavior tests and
approved CI goldens for their distinct visual states. Public APIs require
Dartdoc. Run `make generate` after changing generated inputs and inspect the
resulting diff.

`make release-check` is the clean, hosted-dependency publication gate. Normal
local development uses ignored dependency overrides, so contributors usually
run `make check`; CI runs the release gate without overrides.

## Release files

Do not bump package versions, create tags, or edit the Release Please manifest
in a normal contribution. Release Please owns version and changelog updates
after user-facing changes reach `main`. Maintainers own registry publication.

See [RELEASES.md](RELEASES.md) for the independent design-system and package
release lanes.

## Licensing

Mateo is distributed under the [MIT License](LICENSE). By submitting a
contribution, you agree that your contribution may be distributed under that
license and confirm that you have the right to submit it. Preserve third-party
copyright and license notices, and call out copied or adapted material in the
pull request.
