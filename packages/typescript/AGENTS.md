# Mateo TypeScript Implementations

This folder contains implementations of the Mateo Design System for frameworks
and platforms built on TypeScript. Its purpose is to turn Mateo's design
foundations into reusable packages that teams can use in their websites,
applications, and other TypeScript projects.

Each package owns the implementation for its framework and platform, including
its public APIs, components, and supporting code.

Packages share Mateo's design language while respecting the conventions and
capabilities of their target environment. Shared workspace tooling belongs at
this level; framework-specific behavior and instructions belong in the package
that owns them.

The authored design guidance remains in [`design-system/`](../../design-system/).
This folder implements that guidance. The repository and parent
[`packages/AGENTS.md`](../AGENTS.md) instructions also apply.
