# Typography — Mateo Design System

> Mateo uses [Inter](https://github.com/rsms/inter) with `-0.2` letter spacing.
> Font files are available in [assets/fonts/](assets/fonts/).

---

This foundation defines only the shared typeface and letter spacing. Mateo does
not define a global type scale.

| Property       | Foundation value |
| -------------- | ---------------- |
| Font family    | Inter            |
| Letter spacing | `-0.2`           |

Each component defines its own font size, weight, line height, and other text
properties according to its purpose and platform. Keep those decisions with the
component instead of introducing global heading, body, label, or display styles.

Use the platform-equivalent fixed spacing value. (e.g. `-0.2px` on the web and
`-0.02` for percentage values)

## Font assets

The shared assets include variable normal and italic Inter fonts, with weights
from 100 to 900:

| Format | Normal | Italic |
| ------ | ------ | ------ |
| Original TTF | [inter-variable.ttf](assets/fonts/inter-variable.ttf) | [inter-italic.ttf](assets/fonts/inter-italic.ttf) |
| Full-coverage WOFF2 | [inter-variable.woff2](assets/fonts/inter-variable.woff2) | [inter-italic.woff2](assets/fonts/inter-italic.woff2) |
| Latin WOFF2 | [inter-latin.woff2](assets/fonts/inter-latin.woff2) | [inter-italic-latin.woff2](assets/fonts/inter-italic-latin.woff2) |

Use WOFF2 for web delivery. The Latin files include Portuguese accents and common
punctuation; pair them with the full-coverage files for other characters supported
by Inter. The optimized files preserve the original glyph shapes and metrics.
The [font license](assets/fonts/OFL.txt) accompanies these assets.
