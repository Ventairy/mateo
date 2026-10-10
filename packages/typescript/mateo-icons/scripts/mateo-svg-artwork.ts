import type { MateoSvgIcon } from '../src/mateo-svg-icon.ts';

/** Converts canonical SVG paint while preserving the authored coordinate frame. */
export function getMateoSvgArtwork(
  artwork: string,
): MateoSvgIcon & { readonly svg: string } {
  const paint = [...artwork.matchAll(/\b(?:fill|stroke)="([^"]+)"/g)].map(
    (match) => match[1],
  );
  const monochrome = paint.every(
    (value) =>
      value !== undefined &&
      /^(?:none|black|white|currentColor|#060605|#0D0C0C|#080706|url\(#[^)]+\))$/.test(
        value,
      ),
  );
  const svg = monochrome
    ? artwork.replace(
        /\b(fill|stroke)="(?:black|#060605|#0D0C0C|#080706)"/g,
        '$1="currentColor"',
      )
    : artwork;
  const match =
    /^\s*<svg\b[^>]*\bviewBox="([^"]+)"[^>]*>([\s\S]*)<\/svg>\s*$/.exec(svg);
  if (!match || match[1] === undefined || match[2] === undefined)
    throw new Error('Mateo artwork requires an SVG coordinate frame.');
  return { viewBox: match[1], markup: match[2].trim(), svg };
}
