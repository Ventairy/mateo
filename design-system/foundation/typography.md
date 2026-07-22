# Typography — Mateo Design System

> Mateo uses [Inter](https://github.com/rsms/inter) with `-0.2` letter spacing.
> Download the font from the official Inter repository.

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
