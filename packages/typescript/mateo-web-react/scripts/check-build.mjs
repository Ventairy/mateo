import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const client = readFileSync(
  new URL('../dist/react.js', import.meta.url),
  'utf8',
);
const core = readFileSync(new URL('../dist/index.js', import.meta.url), 'utf8');
assert.match(
  client,
  /^['"]use client['"];\s/,
  'React entry must preserve its client boundary',
);
assert.doesNotMatch(
  core,
  /^['"]use client['"];\s/,
  'Core entry must remain server-safe',
);
assert.doesNotMatch(
  core,
  /(?:from\s*|import\s*)['"]react(?:\/|['"])/,
  'Core must not load React',
);
