# Adjust icon sizes optically

The `mateo-optical-5.2` model balances outer span with enclosed, compact narrow,
and separated broad bodies. Every icon receives one uniform scale and translation
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

Sizing runs offline after installation. No neural-network runtime, model
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
source/output hashes, span and body measurements, score residuals, and frame
limits.

Generation returns status 0. Freshness checking returns 1 when outputs need
updating; invalid inputs or setup failures return 2. The complete batch is
computed before files are replaced. Destination contents are checked again
before replacement, and failed writes roll back the tool's own changes.
The tool does not stage or commit repository changes.

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
scaling strokes, local references, gradients, patterns, masks, and clip paths
are supported. Geometry values must be finite and the drawing must be visible.

Text, embedded raster images, external resources, CSS, filters, non-scaling
vector effects, and transforms, masks, or clipping on the root SVG are
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
[optical_geometry.py](optical_geometry.py) measures coverage, span, enclosure,
and spatial moments. [adjust_icon_sizes.py](adjust_icon_sizes.py) owns the
presence score and scale solver.

The reference is a synthetic 20-unit disk displayed at 15.5px. Each drawing is
first measured in a canonical 20-unit occupied span. Relative alpha coverage
is normalized by its peak, preserving global-opacity invariance. Input colors
are not part of the size score.

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
Centering uses
the painted bounds, preserving the existing placement contract.

### Research and limits

The model uses explicit design calibration, not fitted human-size judgments.
The constants are shared across drawings and do not certify perceptual equality.
The research informs the choice of multiple cues and the need for visual review:

- [Pisu et al., 2025](https://doi.org/10.1037/xhp0001322) found systematic
  shape-dependent area biases and evaluated a model across held-out shapes.
  Their filled-shape area task does not validate this icon-sizing formula.
- [Bertulis et al., 2025](https://pmc.ncbi.nlm.nih.gov/articles/PMC12497920/)
  studied differences in perceived extent and the role of contours. Coverage
  and enclosed extent are consequently treated as separate cues here.

Uniform scaling cannot independently equalize stroke weight and apparent size.
Inspect the actual drawing at its intended size. A safety cap may prevent a
shape from reaching the reference score; the report makes that limit explicit.
Do not add an icon-name exception to hide it.

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

Validation checks authored-byte preservation, idempotence, centering, and
containment, then renders 48 contexts per icon: four display sizes, three pixel
densities, and four pixel phases. Phase variation and frame limits are reported
separately. These checks establish rendering properties, not equal perception.

`test_catalog_balance.py` protects reviewed acceptance ranges for reported
regressions, including separated figures and decorated objects, compact narrow
objects, the calendar/clock pair, enclosed head, local-cavity symbols, dense tiles,
and open stroke symbols. Those ranges supplement the independent geometry tests;
filenames never enter the model itself.

The renderer accepts `--size 16`, `20`, `24`, or `28`, `--density 1`, `2`, or `3`,
and repeated `--pair FIRST,SECOND` options. Review PNGs at their intended display
size. Judge fine strokes, gaps, directional variants, dense and outlined shapes,
and adjacent text at native resolution, including reduced-contrast contexts.
