import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const mateoClientBundle = readFileSync(
  new URL('../dist/react.js', import.meta.url),
  'utf8',
);
const mateoCoreBundle = readFileSync(
  new URL('../dist/index.js', import.meta.url),
  'utf8',
);
assert.match(
  mateoClientBundle,
  /^['"]use client['"];\s/,
  'React entry must preserve its client boundary',
);
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
