# Mateo SVG icons

This directory contains Mateo's source SVG icon catalog. Follow the
[icon foundation](../../../icons.md) for the design language, naming, and use
of these icons. Keep drawings simple, recognizable, and consistent with the
rest of the catalog.

## Required optical size adjustment

Whenever an SVG icon is added or modified, you must run the
[optical icon sizing tools](../../../../../tools/icon-optical-adjustment/README.md)
before considering the change complete. This applies even to small edits.

1. Follow the tool README to set up its pinned dependencies and verified model
   weights. It includes commands for Linux, macOS, and Windows.
2. After the final artwork edit, run `adjust_icon_sizes.py` to apply optical
   sizing, then run it with `--check`. The check must report no out-of-date icons.
   From the repository root, using the setup variables from the tool README:

   ```sh
   "$ICON_PY" "$ICON_TOOLS/adjust_icon_sizes.py"
   "$ICON_PY" "$ICON_TOOLS/adjust_icon_sizes.py" --check
   ```

3. Run the validation and visual review commands in the tool README. Inspect
   the changed icons at their intended display sizes alongside related icons.
4. Keep the adjusted SVGs as the final assets. If you edit the artwork again,
   repeat the adjustment and checks.

Let the tool manage the generated `mateo-optical-size` transform. Do not
hand-tune it or change the model to compensate for an individual icon. If
setup or validation fails, resolve the failure or report it as unfinished work;
do not silently skip optical sizing.
