# Color Palette — Mateo Design System

> The raw primitive color scales for Mateo, a warm and simple design system. These are **pure colors**, not semantic assignments. Each platform's color scheme defines its semantic roles.
>
> The palette contains: **2 foundation colors** (pure white, pure black) + **13 color scales** (primary, neutral, green, amber, red, blue, cyan, violet, teal, orange, pink, yellow, whatsapp), each with 12 steps.
>
> **Mateo's default `primary` seed is `#4A5CFF`.** The `primary` scale is a brand slot, not a universal product color. Every consuming brand must replace the seed and regenerate both `primary` and `neutral` using the contract below.

---

The palette defines values and generation rules only.

---

## Color space

All scales are authored in **OKLCH**, a perceptual color space in which lightness, chroma, and hue can be adjusted independently.

Each scale is defined by:

- **Hue** — the color family (0–360 degrees)
- **Lightness** — perceived brightness (0–100%)
- **Chroma** — saturation intensity (0–0.37 max for sRGB)

The hex values are the sRGB output.

---

## 0. Foundation — Pure white & Pure black

Pure white and pure black are absolute, untinted reference values outside the
numbered scales.

| Name      | Hex       | OKLCH             |
| --------- | --------- | ----------------- |
| **White** | `#FFFFFF` | `oklch(100% 0 0)` |
| **Black** | `#000000` | `oklch(0% 0 0)`   |

---

## 1. Primary — Mateo violet

**Hue:** ~271 (vivid violet)
**Anchor:** Step 9 = `#4A5CFF` = `oklch(56.50% 0.239 271.36)`

This is Mateo's own brand scale. Consumers must replace the step-9 seed and
regenerate the entire primary and neutral scales together.

| Step | Hex           | OKLCH                      |
| ---- | ------------- | -------------------------- |
| 1    | `#F9FBFE`     | `oklch(98.7% 0.005 271.4)` |
| 2    | `#F2F4FB`     | `oklch(96.7% 0.010 271.4)` |
| 3    | `#E5EAFA`     | `oklch(93.9% 0.022 271.4)` |
| 4    | `#DAE1F7`     | `oklch(91.1% 0.031 271.4)` |
| 5    | `#CBD7FC`     | `oklch(88.3% 0.053 271.4)` |
| 6    | `#BECDFF`     | `oklch(85.4% 0.072 271.4)` |
| 7    | `#ADC0FF`     | `oklch(81.5% 0.092 271.4)` |
| 8    | `#718CFC`     | `oklch(67.2% 0.167 271.4)` |
| 9    | **`#4A5CFF`** | `oklch(56.5% 0.239 271.4)` |
| 10   | `#3F4CE7`     | `oklch(51.2% 0.230 271.4)` |
| 11   | `#273392`     | `oklch(37.7% 0.156 271.4)` |
| 12   | `#0C123E`     | `oklch(21.0% 0.084 271.4)` |

### Generate a primary scale from a brand seed

Start from the consumer's intended solid color at step 9. Convert it to OKLCH
and call its coordinates `L9`, `C9`, and `H9`. Preserve the seed exactly at step 9. For every other step, keep `H = H9` and calculate from this table:

| Step | Lightness rule              | Chroma rule |
| ---- | --------------------------- | ----------- |
| 1    | `L9 + (1 - L9) × 0.970`     | `C9 × 0.02` |
| 2    | `L9 + (1 - L9) × 0.925`     | `C9 × 0.04` |
| 3    | `L9 + (1 - L9) × 0.860`     | `C9 × 0.09` |
| 4    | `L9 + (1 - L9) × 0.795`     | `C9 × 0.13` |
| 5    | `L9 + (1 - L9) × 0.730`     | `C9 × 0.22` |
| 6    | `L9 + (1 - L9) × 0.665`     | `C9 × 0.30` |
| 7    | `L9 + (1 - L9) × 0.575`     | `C9 × 0.44` |
| 8    | `L9 + (1 - L9) × 0.245`     | `C9 × 0.70` |
| 9    | `L9`                        | `C9`        |
| 10   | `0.21 + (L9 - 0.21) × 0.85` | `C9 × 0.96` |
| 11   | `0.21 + (L9 - 0.21) × 0.47` | `C9 × 0.65` |
| 12   | `0.21`                      | `C9 × 0.35` |

If a result falls outside sRGB, reduce chroma while holding lightness and hue
constant until it is in gamut. This follows the constant-lightness,
constant-hue approach described by [CSS Color 4](https://www.w3.org/TR/css-color-4/#gamut-mapping).
Do not clip RGB channels independently: clipping can shift the perceived hue.

Mateo is tuned for active, vivid seeds like its own violet, with step-9 lightness
around 55–82%. Pale, pastel, near-white, muted, or very dark seeds are not
recommended because they can compress the scale's lightness and chroma
separation. Preserve an accepted seed at step 9, then manually review and
adjust the generated scale.

---

## 2. Neutral — Primary-tinted

**Hue:** ~271 by default; always inherited from the current primary seed
**Chroma:** 0.002–0.008 with Mateo's vivid seed

Its low chroma carries a trace of the current primary hue while remaining
visually neutral.

| Step | Hex       | OKLCH                      |
| ---- | --------- | -------------------------- |
| 1    | `#FBFCFD` | `oklch(99.0% 0.002 271.4)` |
| 2    | `#F4F5F7` | `oklch(97.0% 0.003 271.4)` |
| 3    | `#EAEBEF` | `oklch(94.0% 0.005 271.4)` |
| 4    | `#E0E1E5` | `oklch(91.0% 0.006 271.4)` |
| 5    | `#D6D7DC` | `oklch(88.0% 0.007 271.4)` |
| 6    | `#CCCDD3` | `oklch(85.0% 0.008 271.4)` |
| 7    | `#BFC1C6` | `oklch(81.0% 0.008 271.4)` |
| 8    | `#909297` | `oklch(66.0% 0.007 271.4)` |
| 9    | `#707175` | `oklch(55.0% 0.006 271.4)` |
| 10   | `#626367` | `oklch(50.0% 0.006 271.4)` |
| 11   | `#3E4043` | `oklch(37.0% 0.006 271.4)` |
| 12   | `#17181B` | `oklch(21.0% 0.006 271.4)` |

### Regenerate neutral with primary

Let `tint = min(1, C9 / 0.20)`. Set every neutral step to the primary seed hue
and multiply each maximum chroma below by `tint`. This makes lower-chroma seeds
produce quieter neutrals instead of exaggerating their color. If the primary
seed is achromatic, set neutral chroma to `0`; hue is then irrelevant.

| Step | Lightness | Maximum chroma |
| ---- | --------- | -------------- |
| 1    | `0.99`    | `0.002`        |
| 2    | `0.97`    | `0.003`        |
| 3    | `0.94`    | `0.005`        |
| 4    | `0.91`    | `0.006`        |
| 5    | `0.88`    | `0.007`        |
| 6    | `0.85`    | `0.008`        |
| 7    | `0.81`    | `0.008`        |
| 8    | `0.66`    | `0.007`        |
| 9    | `0.55`    | `0.006`        |
| 10   | `0.50`    | `0.006`        |
| 11   | `0.37`    | `0.006`        |
| 12   | `0.21`    | `0.006`        |

---

## 3. Green

**Hue:** ~148
**Anchor:** Step 9 = `#00D757` = `oklch(76.7% 0.222 147.9)`

| Step | Hex           | OKLCH                      |
| ---- | ------------- | -------------------------- |
| 1    | `#FBFEFB`     | `oklch(99.3% 0.004 147.9)` |
| 2    | `#F5FBF6`     | `oklch(98.3% 0.009 147.9)` |
| 3    | `#ECF8ED`     | `oklch(96.7% 0.020 147.9)` |
| 4    | `#E3F5E5`     | `oklch(95.2% 0.029 147.9)` |
| 5    | `#D5F4D8`     | `oklch(93.7% 0.049 147.9)` |
| 6    | `#C8F2CD`     | `oklch(92.2% 0.067 147.9)` |
| 7    | `#B2F1BA`     | `oklch(90.1% 0.098 147.9)` |
| 8    | `#78E18A`     | `oklch(82.4% 0.156 147.9)` |
| 9    | **`#00D757`** | `oklch(76.7% 0.222 147.9)` |
| 10   | `#00B849`     | `oklch(68.3% 0.198 147.9)` |
| 11   | `#006F29`     | `oklch(47.2% 0.137 147.9)` |
| 12   | `#001F06`     | `oklch(21.0% 0.061 147.9)` |

---

## 4. Amber

**Hue:** ~73
**Anchor:** Step 9 = `#FFAA00` = `oklch(80.2% 0.171 73.3)`

| Step | Hex           | OKLCH                     |
| ---- | ------------- | ------------------------- |
| 1    | `#FFFDFB`     | `oklch(99.4% 0.003 73.3)` |
| 2    | `#FDFAF5`     | `oklch(98.5% 0.007 73.3)` |
| 3    | `#FCF5EB`     | `oklch(97.3% 0.015 77.1)` |
| 4    | `#FBF0E2`     | `oklch(95.9% 0.022 73.3)` |
| 5    | `#FDEAD2`     | `oklch(94.6% 0.038 73.3)` |
| 6    | `#FEE5C4`     | `oklch(93.4% 0.051 73.3)` |
| 7    | `#FFDDB2`     | `oklch(91.6% 0.067 73.3)` |
| 8    | `#FDC171`     | `oklch(85.0% 0.119 73.3)` |
| 9    | **`#FFAA00`** | `oklch(80.2% 0.171 73.3)` |
| 10   | `#DA9100`     | `oklch(71.3% 0.152 73.3)` |
| 11   | `#835500`     | `oklch(48.8% 0.104 73.3)` |
| 12   | `#241400`     | `oklch(21.0% 0.045 73.3)` |

---

## 5. Red

**Hue:** ~25
**Anchor:** Step 9 = `#FB2C36` = `oklch(63.8% 0.237 25.4)`

| Step | Hex           | OKLCH                     |
| ---- | ------------- | ------------------------- |
| 1    | `#FFFAFA`     | `oklch(98.9% 0.005 25.4)` |
| 2    | `#FCF4F3`     | `oklch(97.3% 0.009 25.4)` |
| 3    | `#FCE9E7`     | `oklch(94.9% 0.021 25.4)` |
| 4    | `#FBDFDC`     | `oklch(92.6% 0.031 25.4)` |
| 5    | `#FFD3CE`     | `oklch(90.2% 0.051 25.4)` |
| 6    | `#FFC7C2`     | `oklch(87.9% 0.064 25.4)` |
| 7    | `#FFB8B0`     | `oklch(84.6% 0.084 25.4)` |
| 8    | `#FE776F`     | `oklch(72.7% 0.166 25.4)` |
| 9    | **`#FB2C36`** | `oklch(63.8% 0.237 25.4)` |
| 10   | `#E00F26`     | `oklch(57.4% 0.228 25.4)` |
| 11   | `#8B1219`     | `oklch(41.1% 0.154 25.4)` |
| 12   | `#360103`     | `oklch(21.0% 0.083 25.4)` |

---

## 6. Blue

**Hue:** ~259
**Anchor:** Step 9 = `#2B7FFF` = `oklch(61.9% 0.207 259.2)`

| Step | Hex           | OKLCH                      |
| ---- | ------------- | -------------------------- |
| 1    | `#FAFBFE`     | `oklch(98.9% 0.004 259.2)` |
| 2    | `#F2F6FB`     | `oklch(97.1% 0.008 259.2)` |
| 3    | `#E6EEFA`     | `oklch(94.7% 0.019 259.2)` |
| 4    | `#DBE6F8`     | `oklch(92.2% 0.027 259.2)` |
| 5    | `#CBDEFC`     | `oklch(89.7% 0.045 259.2)` |
| 6    | `#BDD7FF`     | `oklch(87.2% 0.062 259.2)` |
| 7    | `#ABCCFF`     | `oklch(83.8% 0.081 259.2)` |
| 8    | `#69A2FB`     | `oklch(71.2% 0.145 259.2)` |
| 9    | **`#2B7FFF`** | `oklch(61.9% 0.207 259.2)` |
| 10   | `#1A6CE5`     | `oklch(55.7% 0.198 259.2)` |
| 11   | `#13448F`     | `oklch(40.2% 0.134 259.2)` |
| 12   | `#031639`     | `oklch(21.0% 0.072 259.2)` |

---

## 7. Cyan

**Hue:** ~218
**Anchor:** Step 9 = `#00C2E6` = `oklch(75.1% 0.135 217.5)`

| Step | Hex           | OKLCH                      |
| ---- | ------------- | -------------------------- |
| 1    | `#FBFDFE`     | `oklch(99.3% 0.003 217.5)` |
| 2    | `#F5FAFB`     | `oklch(98.1% 0.005 217.5)` |
| 3    | `#EBF6F9`     | `oklch(96.5% 0.012 217.5)` |
| 4    | `#E2F1F6`     | `oklch(94.8% 0.017 219.7)` |
| 5    | `#D4EEF6`     | `oklch(93.3% 0.030 217.5)` |
| 6    | `#C7EBF5`     | `oklch(91.7% 0.040 217.5)` |
| 7    | `#B0E6F6`     | `oklch(89.4% 0.059 217.5)` |
| 8    | `#75D1EA`     | `oklch(81.2% 0.094 217.5)` |
| 9    | **`#00C2E6`** | `oklch(75.1% 0.135 217.5)` |
| 10   | `#00A6C5`     | `oklch(67.0% 0.120 217.5)` |
| 11   | `#006478`     | `oklch(46.4% 0.083 217.5)` |
| 12   | `#001C24`     | `oklch(20.9% 0.038 219.5)` |

---

## 8. Violet

**Hue:** ~294
**Anchor:** Step 9 = `#8E51FF` = `oklch(60.1% 0.242 293.9)`

| Step | Hex           | OKLCH                      |
| ---- | ------------- | -------------------------- |
| 1    | `#FBFAFE`     | `oklch(98.8% 0.005 293.9)` |
| 2    | `#F5F4FB`     | `oklch(97.0% 0.010 293.9)` |
| 3    | `#EDEAFA`     | `oklch(94.4% 0.022 293.9)` |
| 4    | `#E5E0F8`     | `oklch(91.8% 0.032 293.9)` |
| 5    | `#DDD5FC`     | `oklch(89.2% 0.053 293.9)` |
| 6    | `#D5CAFF`     | `oklch(86.6% 0.073 293.9)` |
| 7    | `#CABCFF`     | `oklch(83.0% 0.094 293.9)` |
| 8    | `#A585FC`     | `oklch(69.8% 0.170 293.9)` |
| 9    | **`#8E51FF`** | `oklch(60.1% 0.242 293.9)` |
| 10   | `#7D40E5`     | `oklch(54.2% 0.233 293.9)` |
| 11   | `#4E2A90`     | `oklch(39.4% 0.158 293.9)` |
| 12   | `#1C0C3A`     | `oklch(21.0% 0.085 293.9)` |

---

## 9. Teal

**Hue:** ~182
**Anchor:** Step 9 = `#00C7B2` = `oklch(74.4% 0.134 181.7)`

| Step | Hex           | OKLCH                      |
| ---- | ------------- | -------------------------- |
| 1    | `#FBFDFD`     | `oklch(99.2% 0.003 181.7)` |
| 2    | `#F5FAF9`     | `oklch(98.1% 0.005 181.7)` |
| 3    | `#EBF6F4`     | `oklch(96.4% 0.012 184.1)` |
| 4    | `#E2F2EE`     | `oklch(94.8% 0.018 179.3)` |
| 5    | `#D4EFE9`     | `oklch(93.1% 0.029 181.7)` |
| 6    | `#C7ECE4`     | `oklch(91.4% 0.040 181.7)` |
| 7    | `#B1E9DE`     | `oklch(89.1% 0.059 181.7)` |
| 8    | `#75D4C4`     | `oklch(80.7% 0.093 181.7)` |
| 9    | **`#00C7B2`** | `oklch(74.4% 0.134 181.7)` |
| 10   | `#00AB99`     | `oklch(66.4% 0.119 181.7)` |
| 11   | `#00675C`     | `oklch(46.1% 0.083 181.7)` |
| 12   | `#001E19`     | `oklch(21.0% 0.038 181.7)` |

---

## 10. Orange

**Hue:** ~44
**Anchor:** Step 9 = `#FF6900` = `oklch(70.0% 0.202 44.4)`

| Step | Hex           | OKLCH                     |
| ---- | ------------- | ------------------------- |
| 1    | `#FFFBFA`     | `oklch(99.1% 0.004 44.4)` |
| 2    | `#FDF6F3`     | `oklch(97.7% 0.008 44.4)` |
| 3    | `#FCEEE7`     | `oklch(95.8% 0.018 48.5)` |
| 4    | `#FBE6DD`     | `oklch(93.8% 0.026 44.4)` |
| 5    | `#FFDCCD`     | `oklch(91.9% 0.044 44.4)` |
| 6    | `#FFD3C0`     | `oklch(89.9% 0.056 44.4)` |
| 7    | `#FFC7AE`     | `oklch(87.2% 0.073 44.4)` |
| 8    | `#FF9666`     | `oklch(77.3% 0.141 44.4)` |
| 9    | **`#FF6900`** | `oklch(70.0% 0.202 44.4)` |
| 10   | `#DC5A00`     | `oklch(62.6% 0.181 44.4)` |
| 11   | `#893500`     | `oklch(44.0% 0.127 44.4)` |
| 12   | `#2E0C00`     | `oklch(21.0% 0.061 44.4)` |

---

## 11. Pink

**Hue:** ~354
**Anchor:** Step 9 = `#F6339A` = `oklch(65.6% 0.240 354.3)`

| Step | Hex           | OKLCH                      |
| ---- | ------------- | -------------------------- |
| 1    | `#FFFAFC`     | `oklch(99.0% 0.005 354.3)` |
| 2    | `#FCF4F7`     | `oklch(97.4% 0.010 354.3)` |
| 3    | `#FCE9F0`     | `oklch(95.2% 0.022 354.3)` |
| 4    | `#FAE0E9`     | `oklch(92.9% 0.031 354.3)` |
| 5    | `#FED3E2`     | `oklch(90.7% 0.053 354.3)` |
| 6    | `#FFC7DC`     | `oklch(88.5% 0.069 354.3)` |
| 7    | `#FFB7D3`     | `oklch(85.4% 0.090 354.3)` |
| 8    | `#FA79B1`     | `oklch(74.0% 0.168 354.3)` |
| 9    | **`#F6339A`** | `oklch(65.6% 0.240 354.3)` |
| 10   | `#DA1A85`     | `oklch(58.9% 0.231 354.3)` |
| 11   | `#881552`     | `oklch(42.0% 0.156 354.3)` |
| 12   | `#32011B`     | `oklch(21.0% 0.084 354.3)` |

---

## 12. Yellow

**Hue:** ~92
**Anchor:** Step 9 = `#FFD000` = `oklch(87.3% 0.179 92.2)`

| Step | Hex           | OKLCH                     |
| ---- | ------------- | ------------------------- |
| 1    | `#FFFEFB`     | `oklch(99.6% 0.004 92.2)` |
| 2    | `#FEFCF7`     | `oklch(99.0% 0.007 92.2)` |
| 3    | `#FDF9ED`     | `oklch(98.2% 0.016 92.2)` |
| 4    | `#FCF6E5`     | `oklch(97.4% 0.023 92.2)` |
| 5    | `#FDF4D6`     | `oklch(96.6% 0.039 92.2)` |
| 6    | `#FEF1C9`     | `oklch(95.7% 0.054 92.2)` |
| 7    | `#FFEDB4`     | `oklch(94.6% 0.075 92.2)` |
| 8    | `#FDDD79`     | `oklch(90.4% 0.125 92.2)` |
| 9    | **`#FFD000`** | `oklch(87.3% 0.179 92.2)` |
| 10   | `#D9B100`     | `oklch(77.4% 0.158 92.2)` |
| 11   | `#7F6700`     | `oklch(52.2% 0.107 92.2)` |
| 12   | `#1F1700`     | `oklch(21.0% 0.043 92.2)` |

---

## 13. WhatsApp

**Hue:** ~150 (green — WhatsApp brand green, slightly more blue-green than `green`)
**Anchor:** Step 9 = `#25D366` (Mateo's fixed WhatsApp reference green)

A fixed external-brand reference. Unlike `primary`, this scale is not
regenerated from the consuming brand's seed.

| Step | Hex           | OKLCH                      |
| ---- | ------------- | -------------------------- |
| 1    | `#F9FDFA`     | `oklch(99.0% 0.005 151)`   |
| 2    | `#F4FAF5`     | `oklch(98.0% 0.009 151)`   |
| 3    | `#ECF7ED`     | `oklch(96.5% 0.017 150)`   |
| 4    | `#E2F3E5`     | `oklch(94.9% 0.026 150)`   |
| 5    | `#D6F2DA`     | `oklch(93.4% 0.044 149)`   |
| 6    | `#C9F0CE`     | `oklch(91.9% 0.062 149)`   |
| 7    | `#B5EFBE`     | `oklch(89.9% 0.088 149)`   |
| 8    | `#7FDE92`     | `oklch(82.3% 0.141 149)`   |
| 9    | **`#25D366`** | `oklch(76.0% 0.201 149.7)` |
| 10   | `#01B950`     | `oklch(68.5% 0.193 149)`   |
| 11   | `#126E2A`     | `oklch(47.2% 0.132 147)`   |
| 12   | `#002002`     | `oklch(21.0% 0.070 146)`   |

---

## How to extend this palette

To add a new color scale:

1. Choose a hue and step-9 anchor.
2. Apply the primary generation curve, preserving constant hue unless a perceptual correction is documented.
3. Gamut-map each step to sRGB by reducing chroma while preserving lightness and hue.
4. Convert the final OKLCH values to hex and record both representations.
5. Verify lightness ordering, sRGB gamut inclusion, and hex/OKLCH round-trip accuracy.
