<p align="center">
  <img src="./banner.png" alt="Mateo" width="960">
</p>

<h1 align="center">Mateo</h1>

<p align="center">
  <strong>A design system for simple, expressive, warm software.</strong><br>
  Clear foundations, tactile mobile guidance, and reusable components that
  make complex workflows feel obvious and human.
</p>

<p align="center">
  <a href="#what-ships-today">What ships</a> ·
  <a href="#start-here">Start here</a> ·
  <a href="#mateo-mobile-for-flutter">Flutter</a>
</p>

---

Mateo keeps authored design decisions and their public implementations in one
source of truth. Shared foundations define the visual language, platform
guidance defines how it behaves on a device, and packages turn those decisions
into reusable APIs.

Mateo currently focuses on Android and iOS phone applications. Its first
implementation is `mateo_mobile`, a Flutter package built around semantic
theming, deeply rounded geometry, tactile gestures, purposeful motion, and
accessible mobile behavior.

> [!IMPORTANT]
> Mateo is pre-release. The design documentation is available now, while
> `mateo_mobile` `0.1.0` remains unpublished and is installed from a reviewed
> Git commit. Public APIs may change before the first pub.dev release.

## What ships today

| Layer           | Available now                                                                              | Start with                                                          |
| --------------- | ------------------------------------------------------------------------------------------ | ------------------------------------------------------------------- |
| Foundations     | Color primitives and generation, typography, deeply rounded geometry, and Mateo icons      | [Foundation documentation](./design-system/foundation/)             |
| Mateo Mobile    | Semantic color, mobile boundary rules, drag resistance, and the Bottom Sheet specification | [Mobile documentation](./design-system/mobile/)                     |
| Flutter package | The Android and iOS implementation of Mateo Mobile                                         | [`mateo_mobile`](./packages/flutter/mateo-mobile-flutter/README.md) |

The design documentation describes observable results precisely enough to
implement Mateo consistently in another technology. The Flutter package is the
first real implementation of those contracts, not a separate design source.

## Start here

| I want to…                                       | Go to…                                                                                         |
| ------------------------------------------------ | ---------------------------------------------------------------------------------------------- |
| Build an Android or iOS application with Flutter | [Installation and quick start](./packages/flutter/mateo-mobile-flutter/README.md#installation) |
| Run a minimal Flutter application                | [Flutter example](./packages/flutter/mateo-mobile-flutter/example/lib/main.dart)               |
| Understand Mateo's primitive colors              | [Color palette](./design-system/foundation/color-palette.md)                                   |
| Use Mateo's typography foundation                | [Typography](./design-system/foundation/typography.md)                                         |
| Reproduce Mateo's rounded geometry               | [Border radius](./design-system/foundation/border-radius.md)                                   |
| Use the Mateo icon language                      | [Icons](./design-system/foundation/icons/icons.md)                                             |
| Implement Mateo's mobile semantic colors         | [Mobile color scheme](./design-system/mobile/color-scheme.md)                                  |
| Implement Mateo's tactile boundary response      | [Drag resistance](./design-system/mobile/drag-resistance.md)                                   |

## How Mateo is organized

Mateo's sources flow in one direction:

```text
design-system/foundation/    Shared visual foundations
            ↓
design-system/mobile/        Android and iOS phone guidance
            ↓
packages/flutter/            Public Flutter implementation
```

- **Foundations** own reusable primitives and visual rules.
- **Platform guidance** owns semantic behavior and component specifications for
  its device class.
- **Packages** implement those specifications as public libraries without
  redefining them.

## Mateo's point of view

- **Simple is a hard gate.** Common controls should explain themselves at the
  point of use.
- **Warmth is functional.** Space, color, shape, feedback, and tone should help
  people feel oriented and capable.
- **Motion carries meaning.** Movement communicates continuity, state,
  confirmation, or a physical boundary.
- **Accessibility starts with the design.** Meaning must survive text scaling,
  reduced motion, assistive technology, and the absence of color.
- **Platforms keep their character.** Shared foundations must not erase native
  navigation, input, accessibility, or system behavior.
