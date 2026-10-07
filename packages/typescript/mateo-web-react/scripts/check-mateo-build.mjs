import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const mateoCoreBundle = readFileSync(
  new URL('../dist/index.js', import.meta.url),
  'utf8',
);
for (const entry of ['react.js', 'icons.js']) {
  assert.match(
    readFileSync(new URL(`../dist/${entry}`, import.meta.url), 'utf8'),
    /^['"]use client['"];\s/,
    `${entry} must preserve its client boundary`,
  );
}
assert.doesNotMatch(
  mateoCoreBundle,
  /^['"]use client['"];\s/,
  'Core entry must remain server-safe',
);
assert.doesNotMatch(
  mateoCoreBundle,
  /(?:from\s*|import\s*)['"]react(?:\/|['"])/,
  'Core must not load React',
);
