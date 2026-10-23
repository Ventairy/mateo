# Mateo font assets

This directory contains the font assets for Mateo, shared by its platform
implementations and packages. Adding a font here makes its files available;
it does not select a default typeface or integrate it into a package.

## Required formats

- Always keep both a `.ttf` and a `.woff2` version of every font face or
  variable font. TTF supports native use; WOFF2 provides compressed web assets.
- Generate WOFF2 from the matching TTF. Preserve glyph coverage, outlines,
  metrics, OpenType features, and any variable axes. Verify these after
  conversion, and update both formats whenever a font changes.
- Additional web subsets may coexist with the complete pair. Keep their
  filenames explicit about coverage, as with the existing Inter Latin subsets.
- Prefer a variable font pair when available; add static styles only for an
  established consumer requirement.

## Organization and licenses

- Keep every font family in its own lowercase, kebab-case directory, such as
  `inter/`, `fredoka/`, or `momo-signature/`. Do not place font files directly
  in this directory's root. Keep each family's font files and original license
  and copyright notices together in its folder.
- Preserve license wording and font attribution. Follow the supplied license
  requirements for conversion, modification, and redistribution.
- Add or update the family's attribution and license link in the repository's
  [third-party notices](../../../../THIRD_PARTY_NOTICES.md).
- Keep this directory focused on font assets and their accompanying notices
  and documentation. Package integration belongs in the consuming package.
