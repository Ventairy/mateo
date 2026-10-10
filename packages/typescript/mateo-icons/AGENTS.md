# Mateo Icons Package

`@mateo/icons` owns framework-independent static SVG delivery. The canonical
artwork remains in `design-system/foundation/assets/icons/svg/`.

- Keep runtime exports free of framework, DOM, Node, and product dependencies.
- Preserve authored geometry, optical transforms, and full-color artwork.
- `mateo-icon-catalog.json` owns package API names shared with React. Preserve
  existing aliases; canonical asset filenames own individual entry-point names.
- Never edit generated `dist/` files. Run `pnpm build` to generate individual
  artwork modules, declarations, and SVG files. `pnpm check` validates types,
  consumer contracts, and generated freshness.
- Keep accessibility, instance-specific ID isolation, layout, and category
  decisions with the consuming renderer.
