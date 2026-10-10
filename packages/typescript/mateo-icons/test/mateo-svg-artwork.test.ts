import assert from 'node:assert/strict';
import { test } from 'node:test';
import { getMateoSvgArtwork } from '../scripts/mateo-svg-artwork.ts';

test('should preserve every authored paint when artwork has a full-color treatment', () => {
  const svg =
    '<svg viewBox="0 0 20 20"><path fill="black"/><path fill="#FF0000"/></svg>';
  assert.equal(getMateoSvgArtwork(svg).svg, svg);
});

test('should inherit monochrome paint without changing clip paint or geometry when preparing artwork', () => {
  const artwork = getMateoSvgArtwork(
    '<svg viewBox="0 0 20 20"><g transform="matrix(1 0 0 1 2 3)"><path fill="#0D0C0C"/><rect fill="white"/></g></svg>',
  );
  assert.equal(
    artwork.markup,
    '<g transform="matrix(1 0 0 1 2 3)"><path fill="currentColor"/><rect fill="white"/></g>',
  );
});

test('should reject missing coordinate frames when preparing an SVG asset', () => {
  assert.throws(
    () => getMateoSvgArtwork('<svg><path/></svg>'),
    /coordinate frame/,
  );
});
