# Mateo Web React Package

This directory is the package root for `mateo-web-react`, the React implementation of
Mateo for websites and web apps, primarily for desktop with responsive mobile
support.

## Design ownership

Read the applicable [Mateo foundations](../../../design-system/foundation/)
before adding UI. Those artifacts own shared design decisions. Web component
contracts must be agreed before implementation; do not copy mobile interaction
rules or silently define web guidance in package code.

Use native React composition and web semantics. All components must support
keyboard and pointer input, accessible names and focus, localization, and reduced
motion.
