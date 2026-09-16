# Adjust icon sizes optically

The `mateo-optical-4.2` model gives every icon a uniform scale and a
translation inside its existing SVG frame. It balances a shared size
score against a reference disk and limits painted span. The
[icon foundation](../../design-system/foundation/icons.md) owns how exported assets are used.

The model processes each drawing independently. Catalog names, neighboring
files, and previously generated transforms do not select adjustments. Scaling
also changes stroke thickness; this tool preserves artwork rather than
redrawing it to impose one stroke width.

## Setup

Use CPython 3.12 on Linux with glibc 2.28+ (including Ubuntu 22.04/24.04),
Windows x64, or macOS 14+ on ARM64. These targets have the required pinned
wheels.

From the repository root, on Linux or macOS:

```sh
ICON_TOOLS=tools/icon-optical-adjustment
python3.12 -m venv "$ICON_TOOLS/.venv"
ICON_PY="$ICON_TOOLS/.venv/bin/python"
if [ "$(uname -s)" = Linux ]; then
  "$ICON_PY" -m pip install torch==2.14.0 torchvision==0.29.0 --index-url https://download.pytorch.org/whl/cpu
fi
"$ICON_PY" -m pip install -r "$ICON_TOOLS/requirements.txt"
"$ICON_PY" "$ICON_TOOLS/prepare_optical_model.py"
```

On Windows, use PowerShell without activating the virtual environment:

```powershell
$ICON_TOOLS = "tools/icon-optical-adjustment"
py -3.12 -m venv "$ICON_TOOLS/.venv"
$ICON_PY = "$ICON_TOOLS/.venv/Scripts/python.exe"
& $ICON_PY -m pip install torch==2.14.0 torchvision==0.29.0 --index-url https://download.pytorch.org/whl/cpu
& $ICON_PY -m pip install -r "$ICON_TOOLS/requirements.txt"
& $ICON_PY "$ICON_TOOLS/prepare_optical_model.py"
```

Install official CPU wheels first on Linux and Windows; macOS uses the plain
[requirements.txt](requirements.txt). These pinned dependencies are asset tools;
the exported SVGs do not require them in an application.

Setup downloads the fixed backbone and copies LPIPS calibration weights into
`~/.cache/mateo-icons`, verifying sizes and SHA-256 hashes before replacement.
Valid cached weights are reused. Pass `--backbone-source PATH` to prepare an
existing backbone without downloading. Optical sizing runs offline after setup
and fails explicitly when required packages or verified weights are unavailable.

## Adjust icon sizes and check

On Linux or macOS, reuse the setup variables to generate a separate candidate:

```sh
ICON_OUTPUT=$(mktemp -d)
"$ICON_PY" "$ICON_TOOLS/adjust_icon_sizes.py" \
  --output-dir "$ICON_OUTPUT/adjusted" \
  --report "$ICON_OUTPUT/measurements.json"
```

Adjust the source catalog’s icon sizes in place, or check freshness without writing SVGs:

```sh
"$ICON_PY" "$ICON_TOOLS/adjust_icon_sizes.py"
"$ICON_PY" "$ICON_TOOLS/adjust_icon_sizes.py" --check
```

The equivalent candidate, freshness check, and application in PowerShell are:

```powershell
$ICON_OUTPUT = Join-Path ([IO.Path]::GetTempPath()) ([guid]::NewGuid().ToString("N"))
& $ICON_PY "$ICON_TOOLS/adjust_icon_sizes.py" --output-dir "$ICON_OUTPUT/adjusted" --report "$ICON_OUTPUT/measurements.json"
& $ICON_PY "$ICON_TOOLS/adjust_icon_sizes.py" --check
& $ICON_PY "$ICON_TOOLS/adjust_icon_sizes.py"
```

`--input DIRECTORY` selects another directory of supported SVGs. `--output-dir`
and `--check` are mutually exclusive. `--jobs` accepts 1–8 workers. Geometry
extraction stays fixed at 32 samples per SVG unit. `--report PATH.json` records
the model, dependencies, source/output hashes, features, score residuals, and
any output limited by the frame.

A successful generation returns status 0. A freshness check returns 1 when
outputs need updating; invalid inputs or setup failures return 2. The tool
computes the complete batch before replacing SVGs, checks destination contents
before replacement, and rolls back its own writes if replacement fails. It
does not stage or commit repository changes.

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
wrapper are retained. A rerun removes that wrapper before measurement, so
transforms never accumulate.
After solving, the tool retains an existing valid wrapper when every painted
bounds corner moves by at most 0.0001 SVG units and the saved result still fits
the 18px limit. This shared numerical tolerance prevents backend rounding noise
from rewriting approved assets; it also intentionally ignores model changes
below that precision. Reports describe the transform actually kept or written.

Measurement uses a finite padded analysis canvas. It retains visible overflow
inside that canvas and rejects paint touching its boundary; disconnected paint
entirely beyond the canvas can be missed. Authored clip paths and nested
viewport clipping remain effective. Keep source geometry near its 20px frame.

## Fixed model

[optical-model.json](optical-model.json) owns the learned parameters, input
units, reference, rendering context, package versions, and weight hashes.
[adjust_icon_sizes.py](adjust_icon_sizes.py) owns the geometric score and solver;
[optical_geometry.py](optical_geometry.py) owns support and enclosure measures;
[learned_presence.py](learned_presence.py) owns the fixed visual representation.

The base score P₀(s) combines span, diagonal reach, enclosure, orientation,
and retained coverage at scale s. The learned observation uses all five frozen
AlexNet LPIPS layers, averaged over eight square orientations and sixteen
translations. The same reference disk is measured on each runtime and checked
against the recorded reference before its layer ratios are used. These five
cues join three geometric cues in a complete cubic expansion with 164 terms and
one shared coefficient vector.

Let H be that standardized weighted sum, B be log(1.2), and G be the smaller
of one and ink area divided by softly filled area. The learned correction is
**C = B × G × tanh(H)**.

A negative C would enlarge the icon. To avoid over-enlarging dense silhouettes,
that correction fades to zero as ink coverage rises from 60% of the canonical
square to the reference disk's coverage, about 78.6%. The transition uses
**1 − 3t² + 2t³**, where t progresses from zero to one across that interval.
Below it, the correction stays unchanged; above it, learned enlargement is
removed. Positive corrections, which reduce size, stay unchanged. Coverage uses
actual ink, so empty space inside an outlined shape does not make it dense.

The final score is **P(s) = P₀(s) × exp(C)**, using the adjusted C.

The correction is fixed while scale is solved. Thirty-six bisection steps
match the reference score within the 18px painted-span limit; capped outputs
report their remaining score difference. The synthetic disk has zero learned
correction. Parameters do not change when the catalog changes.

The model's coverage contexts and visual descriptor are fixed calibration
inputs, not current component size tokens. Relative alpha coverage describes
shape; it does not measure arbitrary foreground/background color contrast.
The calibrated score is an engineering aid, not proof of perceptual equality.

## Validation and visual review

Run the focused tests and validate the candidate. In PowerShell, prefix each
invocation with `&` and join the lines continued with `\` below.

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
containment, then renders 36 contexts per icon: 16/20/24px at three pixel
densities and four pixel phases. It returns 1 on contract failures and reports
frame limits and phase variation separately. Renderer checks establish these
tested properties, not equal perceived weight or a passing application suite.

The renderer accepts `--size 16`, `20`, or `24`, `--density 1`, `2`, or `3`, and
repeated `--pair FIRST,SECOND` options. Preview labels use Pillow’s bundled font,
without system fonts. Image density is explicit; review PNGs at their intended
display size. Judge fine strokes, gaps, directional variants,
and filled shapes inside the actual product, including small sizes and reduced
contrast.
