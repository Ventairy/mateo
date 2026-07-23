# Contributing to Mateo

Mateo's repository-wide contribution contract, branch workflow, pull request
title format, and release policy live in the
[repository contribution guide](https://github.com/Ventairy/mateo/blob/main/CONTRIBUTING.md).
This file adds the checks and expectations specific to
`mateo-mobile-flutter`.

## Development

Set up and validate the package with:

```bash
make setup
make check
```

Use FVM and the package Makefile. Public members require Dartdoc. Every
widget change needs focused widget tests and approved CI goldens for all
distinct visual states. Bug fixes need regression tests; test descriptions use
`when ..., it should ...` and one assertion per case.

`make check` runs the complete local gate, including committed goldens. Use
`make update-goldens` only when intentionally refreshing visual baselines, then
inspect the rendered changes before opening a pull request.

Keep changes portable across Android and iOS, accessible, and performant on
low-end mobile devices. Do not add provider-specific URLs, credentials,
application state, or product-specific backend assumptions. Web and desktop
support is outside the package scope. By participating, you agree to follow
[CODE_OF_CONDUCT.md](https://github.com/Ventairy/mateo/blob/main/CODE_OF_CONDUCT.md).
