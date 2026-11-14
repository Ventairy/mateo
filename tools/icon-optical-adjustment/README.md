# Adjust icon and logo size and placement optically

The `mateo-optical-6.0` model balances rendered color contrast, outer span, and
enclosed, compact narrow, and separated broad bodies. Size is calibrated for
Mateo's light appearance; the original alpha geometry still owns placement and
containment. Every icon or logo receives one uniform scale and translation
inside its existing 20px SVG frame. The
[icon foundation](../../design-system/foundation/icons.md) owns how exported
assets are used.

Drawings are processed independently. Names, catalog statistics, neighboring
files, and previous generated transforms do not select adjustments. The tool
preserves authored geometry, so scaling also scales its strokes.

## Setup

Use CPython 3.12 or 3.13 with the pinned wheels in
[requirements.txt](requirements.txt). On Linux or macOS:

```sh
ICON_TOOLS=tools/icon-optical-adjustment
python3.12 -m venv "$ICON_TOOLS/.venv"
ICON_PY="$ICON_TOOLS/.venv/bin/python"
"$ICON_PY" -m pip install -r "$ICON_TOOLS/requirements.txt"
```

On Windows, use PowerShell without activating the virtual environment:

```powershell
$ICON_TOOLS = "tools/icon-optical-adjustment"
py -3.12 -m venv "$ICON_TOOLS/.venv"
$ICON_PY = "$ICON_TOOLS/.venv/Scripts/python.exe"
& $ICON_PY -m pip install -r "$ICON_TOOLS/requirements.txt"
```

Adjustment runs offline after installation. No neural-network runtime, model
weights, preparation download, or training is required. The exported SVGs do
not require these asset-tool dependencies in an application.

## Adjust and check

Generate a separate candidate first:

```sh
ICON_OUTPUT=$(mktemp -d)
"$ICON_PY" "$ICON_TOOLS/adjust_icon_sizes.py" \
  --output-dir "$ICON_OUTPUT/adjusted" \
  --report "$ICON_OUTPUT/measurements.json"
```

Apply the model to the source catalog, then check freshness:

```sh
"$ICON_PY" "$ICON_TOOLS/adjust_icon_sizes.py"
"$ICON_PY" "$ICON_TOOLS/adjust_icon_sizes.py" --check
```

In PowerShell, prefix Python invocations with `&`; replace the temporary-directory
assignment with:

```powershell
$ICON_OUTPUT = Join-Path ([IO.Path]::GetTempPath()) ([guid]::NewGuid().ToString("N"))
```

`--input DIRECTORY` selects another directory of supported SVGs. `--output-dir`
and `--check` are mutually exclusive. `--jobs` accepts 1–8 workers. Geometry
extraction stays fixed at 32 samples per SVG unit, with enclosure analysis at
8 samples per unit. `--report PATH.json` records calibration, package versions,
source/output hashes, span and body measurements, score residuals, desired and
applied placement offsets, and frame limits.

Generation returns status 0. Freshness checking returns 1 when outputs need
updating; invalid inputs or setup failures return 2. The complete batch is
computed before files are replaced. Destination contents are checked again
before replacement, and failed writes roll back the tool's own changes.
The tool does not stage or commit repository changes.

### Logos

The same model supports the full-color SVGs in
`design-system/foundation/assets/logos/`, including their embedded PNG artwork.
Select this catalog explicitly; the default input remains the icon catalog:

```sh
"$ICON_PY" "$ICON_TOOLS/adjust_icon_sizes.py" \
  --input design-system/foundation/assets/logos
"$ICON_PY" "$ICON_TOOLS/adjust_icon_sizes.py" \
  --input design-system/foundation/assets/logos --check
```

Use `--output-dir` and `--report` to generate a separate logo candidate, then
pass the original and candidate directories to the validation and visual review
commands below. Both catalogs use the same 20px frame, reference size, and
placement rules. The measurement and validation JSON retain their existing
`icons` result key for either catalog.

The generated group scales and positions the complete logo together. Authored
colors, gradients, masks, clipping, and embedded PNG bytes are preserved.
Rendered RGB contrast, including internal white details and raster transparency,
contributes to size; alpha coverage determines placement and containment.
Review logos and icons together at their actual display sizes on light surfaces
and in existing inverse containers. The static artwork uses one calibration,
not a different transform for every background. This workflow does not copy
logos into platform packages.

## Package integration

The adjusted files in `design-system/foundation/assets/icons/svg/` are the
canonical static artwork for every package. Keep the complete SVG, including its
generated transform, when copying or preparing it for a renderer.

Copy those SVGs byte-for-byte into
`packages/dart/mateo-mobile-flutter/assets/icons/`. Regenerate the Flutter
painters from `packages/dart/` with the workspace's existing asset command:

```sh
fvm dart run melos run gen --no-select
```

Copy canonical logos byte-for-byte into the separate Flutter `assets/logos/`
directory before running the same command. Review both the generated vector
painters and embedded-image artwork against the canonical SVGs.

From `packages/typescript/`, rebuild the framework-independent SVG delivery
before the React package that consumes it:

```sh
pnpm --filter @mateo/icons build
pnpm --filter @mateo/web-react build
```

Run the package checks and review any changed icon goldens. Component icon boxes
keep their existing sizes; the model is applied to the assets, not at runtime.

## Supported artwork

Inputs require `width="20"`, `height="20"`, and `viewBox="0 0 20 20"`;
equivalent numeric formatting is accepted. Static paths, basic shapes, groups,
scaling strokes, local references, gradients, patterns, masks, clip paths, and
embedded static PNG images are supported. Geometry values must be finite and
the drawing must be visible.

An `image` element must have exactly one `href` or `xlink:href`, containing a
`data:image/png;base64,` URI. Direct images and local pattern references are
supported. PNG data must decode successfully and contain one static frame.
Each image may be at most 4096px on either side, and the sum of decoded image
pixels across the SVG may not exceed 16 million. Source size is limited to
16MB, with at most 2MB outside the embedded PNG references. Embedded images
retain their original bytes and pixel dimensions; measurement renders their
coverage in the SVG context without re-encoding them.
The exported inline declaration `style="mask-type:luminance"` (or `alpha`,
with an optional trailing semicolon) is also supported on `mask` elements.

Text, other embedded image formats, external resources, other CSS, filters,
non-scaling vector effects, and transforms, masks, or clipping on the root SVG are
unsupported. Malformed generated wrappers and unsupported input fail explicitly.
The parser also limits source size, nesting, and element count.

The only generated artwork is a group with id `mateo-optical-size`, containing
one positive uniform scale and a translation. All authored bytes outside that
wrapper are retained. Reruns remove the wrapper before measurement, so
transforms never accumulate.

An existing valid wrapper is retained when every painted-bounds corner moves
by at most 0.0001 SVG units and the result still fits the 19.5px limit. Reports
describe the transform actually retained or written.

Measurement uses a finite padded analysis canvas. Visible overflow inside that
canvas is retained; paint touching its boundary is rejected. Disconnected paint
entirely beyond the canvas can be missed. Authored clip paths and nested
viewport clipping remain effective. Keep source geometry near its 20px frame.

## Fixed model

[optical-model.json](optical-model.json) owns all calibration constants and
package versions. [optical_model.py](optical_model.py) validates them.
[optical_appearance.py](optical_appearance.py) supplies rendered size evidence.
[optical_geometry.py](optical_geometry.py) measures its span, enclosure, and
spatial moments. [adjust_icon_sizes.py](adjust_icon_sizes.py) owns the presence
score, scale solver, and alpha-based placement.

The reference is a synthetic black 20-unit disk displayed at 15.5px. Each
drawing is first measured in a canonical 20-unit occupied alpha span. Relative
alpha is normalized by its peak, preserving authored-global-opacity invariance.
Only rendered paint enters the measurement: filenames, hidden RGB under zero
alpha, occluded paths, and unused definitions do not select a correction.

### Rendered appearance

The reference background is white. Composite the rendered straight sRGB over
white using the normalized alpha. For each encoded channel, subtract the result
from one, square the difference, and weight red, green, and blue by 0.2126,
0.7152, and 0.0722. The square root of their sum is the contrast field, C.
These coefficients are used on **encoded sRGB** here, not as a linear-light
luminance formula. This is a calibrated channel-contrast proxy, not a
perceptually uniform color distance or a human-size prediction formula.

For black paint this field equals the original normalized alpha. A white motif
inside colored paint becomes background-like size evidence, just as an
equivalent transparent cutout does on white. The same visible appearance can
therefore supply the same size evidence without special-casing a company name.

Keep absolute contrast separately. Its amplitude A is the sum of C squared
divided by the sum of C; an empty contrast field has amplitude zero. Invisible
padding contributes nothing. For uniformly colored solid interiors this
approaches their channel contrast, while tiny dark details contribute according
to their visible area rather than selecting the cue through a maximum alone.

The high-contrast shoulder rises smoothly from zero at A = 0.75 to one at
A = 0.95. Move A toward one by that shoulder fraction. This preserves the
established black-glyph calibration instead of enlarging a black shape merely
because it has more antialiased edge pixels.

For size geometry, divide C by the smaller of its peak and this effective
amplitude, limiting coverage to one. Distributed contrast supplies the
normalization: adding one tiny black accent to a blue mark cannot halve the
weight of the rest of its body by changing a single maximum pixel. Ordinary
high-contrast black glyphs keep their alpha-based size coverage; genuinely
fractional, low-contrast fields can receive different appearance coverage.

Confidence rises smoothly from zero at distributed amplitude 0.04 to one at 0.12,
using the same cubic progress curve as the body cues below. Blend from alpha
geometry to the normalized contrast geometry by that confidence. Above zero
confidence, round coverage to the nearest of 256 levels, keeping span and
connectedness analysis bounded even for raster gradients. With zero
confidence, retain alpha geometry. Very pale or white artwork remains valid
for inverse use; the tool does not try to make invisible white-on-white paint
visible through unlimited enlargement.

Raise this effective amplitude to 0.2 and limit the result to at least 1/1.2.
Raise that bounded factor to the appearance confidence, then multiply the
span/body presence by it before the existing solver. The absolute-color cue
alone can request at most 20% enlargement. Contrast geometry can independently
change the shape score, and the final alpha-bound limit always takes precedence.

Reports include contrast peak, amplitude, effective amplitude, confidence,
color presence factor, and appearance coverage area. Their physical ink area
remains alpha-based.
One static transform cannot equalize every background, semantic recoloring, or
person's perception; use mixed-catalog visual review as acceptance evidence.
Global-opacity invariance is intentional: changing an entire asset's opacity
does not change its intrinsic size, even when a different opaque gray could
produce the same colors on a particular background.
The renderer's 8-bit premultiplied-color rounding can still cause subpixel
differences when a globally translucent source is reconstructed; numerical
checks allow 0.05px for rendered colored-opacity comparisons.

### Span and body

The span score retains axis extent, diagonal reach, orientation, and a bounded
empty-space term. It preserves the presence of open, widely distributed strokes,
such as menu lines and logout contours.

The enclosed-body score adds two measurements:

1. **Enclosed area.** Blur the coverage at each of the three fixed scales,
   then fill each basin only to its lowest escape barrier. This is fractional
   grayscale reconstruction, not a binary hole count. Compare the average
   filled area with the disk's and take its square root to obtain a length ratio.
2. **Body spread.** At each scale, measure the RMS distance of the filled
   coverage from its centroid. Compare it with the disk's at the same scale.
   Combine these ratios by their geometric mean. Pixel cells contribute their
   own second moment, keeping narrow and single-pixel fields well-defined.

The body score is the disk's span score multiplied by the geometric mean of
these area and spread length ratios. The exponent assigned to the area ratio
is 0.5; the spread ratio receives the remaining 0.5.

A small cavity inside one part of a drawing must not resize the entire symbol.
At each blur scale, measure the extra filled coverage and its spatial
covariance. Compare the linear sizes of the covariance ellipses of that extra
coverage and the complete filled body: take the fourth root of their determinant
ratio and limit it to one. Multiply this distribution factor by the extra area.
The average of these weighted areas, divided by the average filled area, is the
**distributed enclosure** value, E.

Distributed enclosure supplies a body weight of **e = 1 − (1 − E)⁶**.

A narrow object can have a compact body without a large enclosed region. Measure
its **ink concentration** as peak-normalized ink area divided by the area of its
covariance-equivalent ellipse: **4π × square root of the covariance determinant**.
Filled ellipses approach concentration one; spread-out strokes have lower values.
This measurement is invariant to rotation, translation, and uniform scaling.

Concentration supplies confidence, rising smoothly from zero at 0.55 to one at
0.85. Narrowness rises smoothly from zero at aspect ratio 0.9 to one at 0.5,
where aspect ratio is the shorter occupied dimension divided by the longer one.
Both transitions use **t² × (3 − 2t)**. The compact-body weight is concentration
confidence multiplied by **1 − (1 − narrowness)⁶**. Confidence itself is not
amplified: a weakly packed slender mark must not receive full body weight.

Combine these weights as **w₀ = 1 − (1 − e) × (1 − compact-body weight)**.

A broad silhouette can also split its body across several detached pieces.
At every observed positive alpha level, measure the fraction of occupied pixels
outside the largest four-connected piece. Average these fractions over their
exact normalized alpha intervals. A faint piece or bridge then changes the
measurement gradually; no single opacity threshold decides connectedness.
Overlapping paths are measured from their combined rendered coverage.

Detached ink supplies confidence rising smoothly from zero at 0.01 to one at
0.10. Broadness is the complement of narrowness. A partly filled body receives
confidence rising from zero at ink concentration 0.50 to one at 0.70, staying
at one through 0.75, then falling to zero at 0.90. Multiply these three values
to obtain the broad-body weight. This separates detached silhouettes from
connected peripheral strokes and dense solids.

When the body score is lower than the span score, use the greater of this
weight and w₀. Limit the additional log correction to the natural logarithm of
1.2: this cue can request at most 20% additional enlargement before contrast
sampling and the existing frame limit are considered. When the body score is
at least the span score, retain w₀. This additional cue never reduces the
size of an already balanced dense tile.

The final geometric score is the span score raised to **1 − w**, multiplied by
the body score raised to **w**, using the weight after the enlargement limit.
Both scores carry the same orientation bias. Open, spread-out strokes retain
span-based sizing; enclosed, narrow, and separated bodies can receive more
body support without an icon-name exception.

### Visibility and solving

The visibility term measures retained blurred contrast at the display sizes in
the model file: 16, 20, 24, and 28px. Its exponent is 0.03. It changes smoothly
with scale; no hard pixel threshold selects a different transform.

The complete score is strictly increasing with positive scale. Thirty-six
bisection steps match the reference within the 19.5px painted-span limit.
This leaves a 0.25px geometric margin on each side of the 20px frame. The
reference disk remains 15.5px; only drawings whose solved size needs the extra
span use it. Extent-limited outputs report their remaining score difference.

### Optical placement

Placement follows sizing; it never changes the solved scale. Start with the
occupied-bounds midpoint. At each existing closure scale (0.35, 0.7, and 1.4
canonical units), find the centroid of the softly filled coverage. Average the
three centroids, then place the optical center halfway between that average and
the occupied-bounds midpoint. The shared `placement_weight` is 0.5. This keeps
the drawing's full reach involved while letting its main body influence its
position. Closed contours contribute their enclosed body; detached pieces keep
their coverage and relative position. No icon name selects a correction.

Translate that optical center toward the center of the 20px frame. Relative to
the previous bounds-centered placement, limit the requested correction to a
Euclidean distance of 1px at this frame size, preserving its direction. Finally,
limit each translation axis independently so all painted bounds remain between
0.25 and 19.75. A drawing at the maximum horizontal span can still move
vertically when room remains. Do not reduce the drawing's size to make room for
a placement correction.

Reports retain the optical center, desired correction, applied correction, and
whether containment limited placement. `placement_limited` is separate from the
size solver's `limited` flag. The generated group retains its
`mateo-optical-size` ID for compatibility; it owns both scale and placement.

### Research and limits

The model uses explicit design calibration, not fitted human judgments of size
or centering. The constants are shared across drawings and do not certify
perceptual equality or an exact perceived center.
The research informs the choice of multiple cues and the need for visual review:

- [Pisu et al., 2025](https://doi.org/10.1037/xhp0001322) found systematic
  shape-dependent area biases and evaluated a model across held-out shapes.
  Their filled-shape area task does not validate this icon-sizing formula.
- [Bertulis et al., 2025](https://pmc.ncbi.nlm.nih.gov/articles/PMC12497920/)
  studied differences in perceived extent and the role of contours. Coverage
  and enclosed extent are consequently treated as separate cues here.
- [Smart and Szafir, 2019](https://cmci.colorado.edu/visualab/papers/measuring_separability_CHI_2019.pdf)
  found that shape and shape pairs influence size judgments, including cases
  where sparse marks appear larger than denser ones. Contrast mass alone is
  consequently insufficient for the shared score.
- [Zhang et al., 2018](https://www.mdpi.com/2411-5150/2/3/28)
  found contextual effects of color and luminance differences on a size
  illusion. This supports reviewing mixed colors in context; it does not
  validate a universal conversion from contrast to displayed size.

Uniform scaling cannot independently equalize stroke weight and apparent size.
Inspect the actual drawing at its intended size. A safety cap may prevent a
shape from reaching the reference score or its preferred placement; the report
makes those limits explicit. Do not add an icon-name exception to hide them.

## Validation and visual review

```sh
"$ICON_PY" -m unittest discover -s "$ICON_TOOLS" -p 'test_*.py'
"$ICON_PY" "$ICON_TOOLS/validate_icon_sizes.py" \
  --input design-system/foundation/assets/icons/svg \
  --adjusted "$ICON_OUTPUT/adjusted" \
  --report "$ICON_OUTPUT/validation.json"
"$ICON_PY" "$ICON_TOOLS/render_icon_sizes.py" \
  --input "$ICON_OUTPUT/adjusted" --output-dir "$ICON_OUTPUT/preview"
```

Validation checks authored-byte preservation, idempotence, model placement, and
containment, then renders 48 contexts per icon: four display sizes, three pixel
densities, and four pixel phases. Phase variation and frame limits are reported
separately. These checks establish rendering properties, not equal perception.

`test_catalog_balance.py` protects reviewed acceptance ranges for reported
regressions, including separated figures and decorated objects, compact narrow
objects, the calendar/clock pair, enclosed head, local-cavity symbols, dense tiles,
and open stroke symbols. Those ranges supplement the independent geometry tests;
filenames never enter the model itself.

Mixed icon/logo acceptance ranges also protect the reviewed color calibration,
including the envelope/Telegram regression. A matching numeric frame does not
by itself imply a matching apparent size.

Review both catalogs together with their separate namespaces and authored logo
colors:

```sh
"$ICON_PY" "$ICON_TOOLS/render_mixed_sizes.py" \
  --icons "$ICON_OUTPUT/adjusted" \
  --logos "$ICON_OUTPUT/adjusted-logos" \
  --before-icons design-system/foundation/assets/icons/svg \
  --before-logos design-system/foundation/assets/logos \
  --output-dir "$ICON_OUTPUT/mixed-preview"
```

This repeats all logos beside 25 representative icons at 16, 20, 24, and 28px,
on light and inverse surfaces with bare, circular, and rounded-square contexts.
Icons use the context foreground; logos retain authored colors. The optional
paired `--before-icons` and `--before-logos` arguments add the envelope/Telegram
before/after comparison. Density defaults to 2 and also accepts 1 or 3. Keep
before catalogs until the review is complete, and inspect the final Flutter
component goldens as well. Inverse contrast can still differ because one static
asset transform cannot equalize every color against every background.

The renderer accepts `--size 16`, `20`, `24`, or `28`, `--density 1`, `2`, or `3`,
and repeated `--pair FIRST,SECOND` options. Review PNGs at their intended display
size. Judge fine strokes, gaps, directional variants, dense and outlined shapes,
and adjacent text at native resolution, including reduced-contrast contexts.

To review placement changes, keep the original catalog in a separate directory
and compare it with the candidate:

```sh
"$ICON_PY" "$ICON_TOOLS/render_icon_sizes.py" \
  --input "$ICON_OUTPUT/adjusted" \
  --before design-system/foundation/assets/icons/svg \
  --icon telegram --icon chevron-left \
  --output-dir "$ICON_OUTPUT/placement-preview" \
  --label "Optical placement"
```

This produces one `placement-NAME.png` per icon at all four display sizes, with
before/after pairs on bare, circular, and rounded-square backgrounds. Omit
`--icon` to compare the full input catalog, or repeat it to select a review set.
The default density is 2; use the existing `--density` option for 1 or 3.
`--before` and `--pair` are separate review modes. Review every changed icon in
these contexts; unequal painted margins can be intentional after optical
placement. The asset owns its intrinsic balance, while components still own
alignment with text and surrounding layout.
