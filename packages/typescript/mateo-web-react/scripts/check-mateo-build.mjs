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

const mateoStylesheet = readFileSync(
  new URL('../dist/styles.css', import.meta.url),
  'utf8',
);
for (const fontName of ['inter-variable.ttf', 'inter-italic.ttf']) {
  assert.ok(
    mateoStylesheet.includes(`url(./${fontName})`),
    `${fontName} must resolve relative to the installed stylesheet`,
  );
  assert.ok(
    readFileSync(new URL(`../dist/${fontName}`, import.meta.url)).length > 0,
    `${fontName} must be included in the package`,
  );
}
assert.match(
  readFileSync(new URL('../dist/fonts/OFL.txt', import.meta.url), 'utf8'),
  /SIL OPEN FONT LICENSE/,
  'Bundled Inter fonts must include their license',
);
