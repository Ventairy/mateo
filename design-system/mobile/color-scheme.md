# Mateo mobile color scheme

> The semantic color scheme for the Mateo mobile design system. This is the **semantic layer** that sits on top of `../foundation/color-palette.md` (the primitive layer). It does not redefine primitives — it assigns meaning to them.
>
> This scheme is **mobile-specific and implementation-framework-agnostic**. Framework mappings, such as Flutter and native iOS or Android APIs, belong in the corresponding public package under `../../packages/`.
>
> **Brand slot:** The `primary` scale defaults to Mateo violet (`#4A5CFF`) and
> is overridable by consuming brands. Component tokens reference its primitives
> directly. Consumers regenerate `primary` and `neutral` together according to
> `../foundation/color-palette.md`.
>
> **External brand colors:** Component tokens for external platforms reference
> their fixed palette scales directly. WhatsApp component tokens use the
> `whatsapp` scale, not the overridable `primary` slot.
>
> **Appearance support:** This version defines a light appearance only. Dark
> mode is not supported.

---

## Naming Convention

Token names are scoped by their section and do not repeat the section name.
Within Text, names are unprefixed. Cross-section references qualify the name,
such as `Text.primary`, when the unqualified name would be ambiguous.
Names use camelCase and avoid abbreviations: `background`, not `bg`.

---

## Token Architecture

Two layers, bottom-up:

### Layer 1: Base Semantic Tokens

Shared roles that are useful across components, such as Text `primary`,
`background`, `scrim`, and control colors.

### Layer 2: Component Pattern Tokens

Each component owns a self-contained set that references palette primitives or
shared roles directly: background (rest/pressed/disabled), foreground
(rest/disabled), and any component-specific boundary. Examples:
`buttonPrimaryBackground`, `buttonPrimaryForeground`, and
`toastSuccessBackground`.

### State Naming

| State            | Meaning                                                                                      |
| ---------------- | -------------------------------------------------------------------------------------------- |
| Rest (no suffix) | Idle — the default state, no interaction happening                                           |
| Pressed          | Finger is down / mouse button is held — the physical tap/click moment                        |
| Disabled         | Element is non-interactive (cannot be tapped)                                                |
| Selected         | Toggle/selection state — the element is "on" (active filter, selected list item, active tab) |

**Pressed vs. Selected:** These are different UX concepts. `Pressed` is the
interaction moment (finger down). `Selected` is a toggle state (the item stays
selected after the finger lifts). Pressed tokens intentionally use the same
color as their rest token; motion or haptics can communicate the interaction.

---

## Light Mode — Shared Token Reference

All values reference `../foundation/color-palette.md` primitives. Tokens that do not correspond to a palette primitive show their hex value inline.

### Background

| Token        | Source | Purpose                   |
| ------------ | ------ | ------------------------- |
| `background` | White  | App background (scaffold) |

### Text

| Token       | Source     | WCAG on `background` | Purpose                                                         |
| ----------- | ---------- | -------------------- | --------------------------------------------------------------- |
| `primary`   | neutral-12 | 17.24:1 ✅           | Headings, titles, primary body text                             |
| `secondary` | neutral-10 | 5.83:1 ✅            | Descriptions, supporting text, captions                         |
| `tertiary`  | neutral-9  | 4.73:1 ✅            | Metadata on neutral-1 or white only                             |
| `disabled`  | neutral-9  | 4.73:1               | Disabled state text                                             |
| `inverse`   | White      | —                    | Text on dark surfaces                                           |
| `profit`    | green-10   | 2.49:1 ❌            | Money/profit amounts, e.g. `$1,200`; not suitable for body text |

### Inverse

For tooltips, snackbars, and any UI that inverts the surrounding color scheme.

| Token          | Source     | Purpose                                         |
| -------------- | ---------- | ----------------------------------------------- |
| `background`   | neutral-12 | Dark inverted surface (tooltip bg, snackbar bg) |
| `onBackground` | White      | Text on inverse surface                         |
| `primary`      | primary-3  | Primary color on inverse surface                |

### Overlay

| Token   | Source      | Purpose                           |
| ------- | ----------- | --------------------------------- |
| `scrim` | Black @ 40% | Modal/dialog backdrop (40% black) |

### Interaction Alpha Tints

| Token                | Source          | Purpose                        |
| -------------------- | --------------- | ------------------------------ |
| `selectionHighlight` | primary-9 @ 30% | Text selection highlight color |

### Skeleton / Loading

| Token         | Source    | Purpose                          |
| ------------- | --------- | -------------------------------- |
| `skeleton`    | neutral-3 | Skeleton bone resting color      |
| `shimmer`     | neutral-1 | Skeleton shimmer sweep highlight |
| `text`        | neutral-8 | Skeleton text resting color      |
| `textShimmer` | neutral-4 | Skeleton text sweep highlight    |

### Scrollbar

| Token   | Source      | Purpose                                                 |
| ------- | ----------- | ------------------------------------------------------- |
| `thumb` | neutral-7   | Scrollbar thumb (visible but unobtrusive)               |
| `track` | transparent | Scrollbar track (transparent — thumb floats on content) |

### System UI

| Token                     | Value             | Purpose                         |
| ------------------------- | ----------------- | ------------------------------- |
| `systemBarBackground`     | transparent       | Status bar / nav bar background |
| `systemBarIconBrightness` | dark (light mode) | Status bar icon brightness      |

---

## Component Pattern Tokens (Light Mode)

Pre-composed sets for specific component types. Each component has background, foreground, and border tokens with state variants where applicable.

### Button — Primary (Primary CTA)

| Token                | Source          | Purpose                        |
| -------------------- | --------------- | ------------------------------ |
| `background`         | primary-9       | Enabled background             |
| `backgroundPressed`  | primary-9       | Pressed background             |
| `backgroundDisabled` | neutral-4       | Disabled background            |
| `foreground`         | White           | Enabled foreground (text/icon) |
| `foregroundDisabled` | `Text.disabled` | Disabled foreground            |

### Button — Secondary (Primary-Tinted)

| Token                | Source          | Purpose             |
| -------------------- | --------------- | ------------------- |
| `background`         | primary-2       | Enabled background  |
| `backgroundPressed`  | primary-2       | Pressed background  |
| `backgroundDisabled` | neutral-4       | Disabled background |
| `foreground`         | primary-9       | Enabled foreground  |
| `foregroundDisabled` | `Text.disabled` | Disabled foreground |

### Button — Tertiary (Dark Action)

| Token                | Source          | Purpose                              |
| -------------------- | --------------- | ------------------------------------ |
| `background`         | neutral-12      | Enabled background (warm near-black) |
| `backgroundPressed`  | neutral-12      | Pressed background                   |
| `backgroundDisabled` | neutral-4       | Disabled background                  |
| `foreground`         | White           | Enabled foreground                   |
| `foregroundDisabled` | `Text.disabled` | Disabled foreground                  |

### Button — Text (Minimal Action)

| Token                | Source          | Purpose             |
| -------------------- | --------------- | ------------------- |
| `foreground`         | `Text.primary`  | Enabled text color  |
| `foregroundDisabled` | `Text.disabled` | Disabled text color |
| `background`         | transparent     | Enabled background  |
| `backgroundPressed`  | transparent     | Pressed background  |

### Button — Destructive (Danger Action)

| Token                | Source          | Purpose             |
| -------------------- | --------------- | ------------------- |
| `background`         | red-10          | Enabled background  |
| `backgroundPressed`  | red-10          | Pressed background  |
| `backgroundDisabled` | neutral-4       | Disabled background |
| `foreground`         | White           | Enabled foreground  |
| `foregroundDisabled` | `Text.disabled` | Disabled foreground |

### Button — Success (Confirm Action)

| Token                | Source          | Purpose                                       |
| -------------------- | --------------- | --------------------------------------------- |
| `background`         | green-9         | Enabled background                            |
| `backgroundPressed`  | green-9         | Pressed background                            |
| `backgroundDisabled` | neutral-4       | Disabled background                           |
| `foreground`         | green-12        | Enabled foreground (dark text on light green) |
| `foregroundDisabled` | `Text.disabled` | Disabled foreground                           |

### Button — WhatsApp Primary (WhatsApp Brand CTA)

| Token                | Source          | Purpose                        |
| -------------------- | --------------- | ------------------------------ |
| `background`         | whatsapp-9      | Enabled background             |
| `backgroundPressed`  | whatsapp-9      | Pressed background             |
| `backgroundDisabled` | neutral-4       | Disabled background            |
| `foreground`         | whatsapp-12     | Enabled foreground (text/icon) |
| `foregroundDisabled` | `Text.disabled` | Disabled foreground            |
| `border`             | none            | No border (solid fill)         |

### Button — WhatsApp Secondary (WhatsApp-Tinted)

| Token                | Source          | Purpose             |
| -------------------- | --------------- | ------------------- |
| `background`         | whatsapp-3      | Enabled background  |
| `backgroundPressed`  | whatsapp-3      | Pressed background  |
| `backgroundDisabled` | neutral-4       | Disabled background |
| `foreground`         | whatsapp-11     | Enabled foreground  |
| `foregroundDisabled` | `Text.disabled` | Disabled foreground |

### Button — WhatsApp Tertiary (Dark WhatsApp Action)

| Token                | Source          | Purpose                          |
| -------------------- | --------------- | -------------------------------- |
| `background`         | whatsapp-12     | Enabled background (dark green)  |
| `backgroundPressed`  | whatsapp-12     | Pressed background               |
| `backgroundDisabled` | neutral-4       | Disabled background              |
| `foreground`         | whatsapp-9      | Enabled foreground (brand green) |
| `foregroundDisabled` | `Text.disabled` | Disabled foreground              |

### Search Bar Button

| Token               | Source         | Purpose                                   |
| ------------------- | -------------- | ----------------------------------------- |
| `background`        | White          | Enabled background                        |
| `backgroundPressed` | White          | Pressed background                        |
| `foreground`        | `Text.primary` | Search icon color                         |
| `title`             | `Text.primary` | Search title                              |
| `border`            | `background`   | Background-colored border                 |
| `shadow`            | Black @ 10%    | Drop shadow, matching the floating button |

### Floating Button (Back Button, FAB, etc.)

| Token                  | Source          | Purpose                                                                  |
| ---------------------- | --------------- | ------------------------------------------------------------------------ |
| `background`           | White           | Enabled background (pure white for max contrast on any background)       |
| `backgroundPressed`    | White           | Pressed background                                                       |
| `backgroundDisabled`   | neutral-4       | Disabled background                                                      |
| `foreground`           | `Text.primary`  | Icon/text color                                                          |
| `foregroundDisabled`   | `Text.disabled` | Disabled icon/text color                                                 |
| `border`               | `background`    | Background-colored border (creates clean halo between button and shadow) |
| `floatingButtonShadow` | Black @ 10%     | Drop shadow (baked alpha)                                                |

### Bottom Sheet

| Token        | Source       | Purpose                                        |
| ------------ | ------------ | ---------------------------------------------- |
| `background` | `background` | Bottom-sheet surface                           |
| `handle`     | neutral-6    | Subtle drag handle on the bottom-sheet surface |

### Toast — Success

| Token        | Source   | Purpose                  |
| ------------ | -------- | ------------------------ |
| `background` | green-12 | Success toast background |
| `foreground` | White    | Success toast text       |
| `icon`       | green-9  | Success toast icon       |

### Toast — Error

| Token        | Source | Purpose                |
| ------------ | ------ | ---------------------- |
| `background` | red-12 | Error toast background |
| `foreground` | White  | Error toast text       |
| `icon`       | red-9  | Error toast icon       |

### Toast — Warning

| Token        | Source   | Purpose                  |
| ------------ | -------- | ------------------------ |
| `background` | amber-12 | Warning toast background |
| `foreground` | White    | Warning toast text       |
| `icon`       | amber-9  | Warning toast icon       |

### Toast — Info

| Token        | Source  | Purpose               |
| ------------ | ------- | --------------------- |
| `background` | blue-12 | Info toast background |
| `foreground` | White   | Info toast text       |
| `icon`       | blue-9  | Info toast icon       |

### Toast — Neutral

| Token        | Source     | Purpose                  |
| ------------ | ---------- | ------------------------ |
| `background` | neutral-12 | Neutral toast background |
| `foreground` | White      | Neutral toast text       |
| `icon`       | neutral-8  | Neutral toast icon       |

### Map

Reusable basemap semantics: land, water, roads, buildings, labels, and
general landuse categories.

This follows the MapLibre/OpenMapTiles model.

| Token                     | Source          | Purpose                                                   |
| ------------------------- | --------------- | --------------------------------------------------------- |
| `mapBackground`           | neutral-2       | Base canvas behind all vector layers                      |
| `mapLandcover`            | green-5         | Natural landcover wash                                    |
| `mapLanduse`              | neutral-3       | General landuse polygons                                  |
| `mapLanduseBusiness`      | neutral-3       | Commercial/retail landuse wash                            |
| `mapLanduseRecreation`    | green-5         | Recreation landuse such as pitches, playgrounds, tracks   |
| `mapPark`                 | green-5         | Parks and green areas                                     |
| `mapWater`                | cyan-5          | Water bodies                                              |
| `mapWaterway`             | cyan-5          | Rivers, canals, streams                                   |
| `mapBuilding`             | neutral-4       | Building footprints                                       |
| `mapBuildingOutline`      | neutral-6       | Building footprint outline                                |
| `mapBoundary`             | neutral-7       | Administrative boundaries                                 |
| `mapTunnel`               | neutral-6       | Subsurface transportation lines                           |
| `mapRoad`                 | White           | Streets, roads, bridges, and major transport lines        |
| `mapLabelHalo`            | White           | Halo behind map text labels                               |
| `mapAdministrativeLabel`  | neutral-9       | State/province and broad administrative labels            |
| `mapCityLabel`            | neutral-11      | Megacity and city labels                                  |
| `mapTownLabel`            | neutral-8       | Town labels                                               |
| `mapNeighborhoodLabel`    | neutral-10      | Neighborhood, suburb, quarter, hamlet, and village labels |
| `mapRoadMajorLabel`       | neutral-9       | Major road labels                                         |
| `mapRoadLocalLabel`       | neutral-8       | Local street labels                                       |
| `mapPointOfInterestLabel` | neutral-8       | Point-of-interest labels                                  |
| `mapLocationRadius`       | teal-9 (α 0.15) | "Within this area" radius bubble fill (no stroke)         |
