import { readFileSync, writeFileSync } from 'node:fs';
import { dirname, relative, sep } from 'node:path';
import { fileURLToPath } from 'node:url';

const mateoIconCatalogPath = new URL(
  './mateo-icon-catalog.json',
  import.meta.url,
);
const mateoIconOutput = new URL('../src/mateo-icons.tsx', import.meta.url);
/** @type {unknown} */
const mateoIconCatalog = JSON.parse(readFileSync(mateoIconCatalogPath, 'utf8'));
if (
  typeof mateoIconCatalog !== 'object' ||
  mateoIconCatalog === null ||
  Array.isArray(mateoIconCatalog)
) {
  throw new TypeError(
    'The Mateo icon catalog must contain named SVG filenames.',
  );
}
const mateoIconEntries = Object.entries(mateoIconCatalog).map(
  ([name, source]) => {
    if (
      !/^[a-z][a-zA-Z0-9]*$/.test(name) ||
      typeof source !== 'string' ||
      !/^[a-z0-9-]+\.svg$/.test(source)
    ) {
      throw new TypeError(`Invalid Mateo icon catalog entry: ${name}.`);
    }
    return {
      name,
      source,
      artwork: `Mateo${name[0].toUpperCase()}${name.slice(1)}Artwork`,
      component: `Mateo${name[0].toUpperCase()}${name.slice(1)}Icon`,
    };
  },
);
if (mateoIconEntries.length === 0) {
  throw new Error('The Mateo icon catalog must contain named artwork.');
}

function _getMateoNamedIconImport(source) {
  const sourceUrl = new URL(
    `../../../../design-system/foundation/assets/icons/svg/${source}?react`,
    import.meta.url,
  );
  const path = relative(
    dirname(fileURLToPath(mateoIconOutput)),
    fileURLToPath(sourceUrl),
  )
    .split(sep)
    .join('/');
  return `${path}${sourceUrl.search}`;
}

function _formatMateoNamedIcon({ name, component, artwork }) {
  const signature = `export function ${component}(props: MateoNamedIconProps): ReactElement {`;
  const element = `<BaseMateoIcon {...props} artwork={${artwork}} />`;
  const body = `  return ${element};`;
  return [
    `/** Renders the ${name} artwork with Mateo icon appearance and accessibility. */`,
    ...(signature.length <= 80
      ? [signature]
      : [
          `export function ${component}(`,
          '  props: MateoNamedIconProps,',
          '): ReactElement {',
        ]),
    ...(body.length <= 80
      ? [body]
      : [
          '  return (',
          ...(`    ${element}`.length <= 80
            ? [`    ${element}`]
            : [
                '    <BaseMateoIcon',
                '      {...props}',
                `      artwork={${artwork}}`,
                '    />',
              ]),
          '  );',
        ]),
    '}',
    '',
  ];
}

const mateoIconEntry = [
  '// Generated from scripts/mateo-icon-catalog.json.',
  '// Regenerate with node scripts/generate-mateo-icons.mjs.',
  "'use client';",
  '',
  "import type { ReactElement } from 'react';",
  ...mateoIconEntries
    .toSorted((first, second) =>
      first.source
        .replace('.svg', '')
        .localeCompare(second.source.replace('.svg', '')),
    )
    .map(
      ({ artwork, source }) =>
        `import ${artwork} from '${_getMateoNamedIconImport(source)}';`,
    ),
  "import { BaseMateoIcon } from './bases/base-mateo-icon/base-mateo-icon.js';",
  "import type { MateoNamedIconProps } from './components/mateo-icon/mateo-named-icon-props.js';",
  '',
  "export type { MateoNamedIconProps } from './components/mateo-icon/mateo-named-icon-props.js';",
  '',
  ...mateoIconEntries.flatMap(_formatMateoNamedIcon),
].join('\n');

if (process.argv.includes('--check')) {
  if (readFileSync(mateoIconOutput, 'utf8') !== mateoIconEntry) {
    throw new Error('Generated Mateo icon components are out of date.');
  }
} else {
  writeFileSync(mateoIconOutput, mateoIconEntry);
}
