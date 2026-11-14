# Mateo SVG icons

This directory contains Mateo's source SVG icon catalog. Follow the
[icon foundation](../../../icons.md) for the design language, naming, and use
of these icons. Keep drawings simple, recognizable, and consistent with the
rest of the catalog.

## Required optical size and placement adjustment

Whenever an SVG icon is added or modified, you must run the
[optical icon adjustment tools](../../../../../tools/icon-optical-adjustment/README.md)
before considering the change complete. This applies even to small edits.

1. Follow the tool README to set up its pinned numerical and rendering
   dependencies. It includes commands for Linux, macOS, and Windows.
2. After the final artwork edit, run `adjust_icon_sizes.py` to apply optical
   size and placement, then run it with `--check`. The check must report no out-of-date icons.
   From the repository root, using the setup variables from the tool README:

   ```sh
   "$ICON_PY" "$ICON_TOOLS/adjust_icon_sizes.py"
   "$ICON_PY" "$ICON_TOOLS/adjust_icon_sizes.py" --check
   ```

3. Run the validation and visual review commands in the tool README. Inspect
   the changed icons at their intended display sizes alongside related icons,
   both bare and inside circular and rounded-square containers.
4. Keep the adjusted SVGs as the final assets. If you edit the artwork again,
   repeat the adjustment and checks.
5. Follow the tool README's package integration steps. Keep the Flutter SVG
   copies byte-identical to this directory, regenerate its icon painters, and
   rebuild the static SVG and React packages from these adjusted assets.

Let the tool manage the generated `mateo-optical-size` transform. Do not
hand-tune it or change the model to compensate for an individual icon. If
setup or validation fails, resolve the failure or report it as unfinished work;
do not silently skip optical size or placement adjustment.
