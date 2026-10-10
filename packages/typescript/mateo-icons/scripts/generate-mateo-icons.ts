import {
  mkdirSync,
  readdirSync,
  readFileSync,
  rmSync,
  writeFileSync,
} from 'node:fs';
import { join } from 'node:path';
import { fileURLToPath } from 'node:url';
import { getMateoSvgArtwork } from './mateo-svg-artwork.ts';

const mateoPackageRoot = fileURLToPath(new URL('..', import.meta.url));
const mateoSourceRoot = fileURLToPath(
  new URL(
    '../../../../design-system/foundation/assets/icons/svg/',
    import.meta.url,
  ),
);
const mateoCatalog: unknown = JSON.parse(
  readFileSync(join(mateoPackageRoot, 'mateo-icon-catalog.json'), 'utf8'),
);
if (
  typeof mateoCatalog !== 'object' ||
  mateoCatalog === null ||
  Array.isArray(mateoCatalog)
) {
  throw new TypeError(
    'The Mateo icon catalog must contain named SVG filenames.',
  );
}
const mateoOutput = new Map<string, string>();
const mateoIndex: string[] = [
  "export type { MateoSvgIcon } from './mateo-svg-icon.js';",
];
const mateoDeclaration = readFileSync(
  join(mateoPackageRoot, 'src/mateo-svg-icon.ts'),
  'utf8',
);
mateoOutput.set('mateo-svg-icon.d.ts', mateoDeclaration);
mateoOutput.set('mateo-svg-icon.js', 'export {};\n');
const mateoSources = new Set<string>();
for (const [name, source] of Object.entries(mateoCatalog)) {
  if (
    !/^[a-z][a-zA-Z0-9]*$/.test(name) ||
    typeof source !== 'string' ||
    !/^[a-z0-9-]+\.svg$/.test(source) ||
    mateoSources.has(source)
  ) {
    throw new TypeError(`Invalid Mateo icon catalog entry: ${name}.`);
  }
  mateoSources.add(source);
  const artwork = readFileSync(join(mateoSourceRoot, source), 'utf8');
  const { svg, viewBox, markup } = getMateoSvgArtwork(artwork);
  const symbol = `Mateo${name.slice(0, 1).toUpperCase()}${name.slice(1)}IconData`;
  const filename = source.replace('.svg', '');
  const comment = `/** Static ${name} artwork. Inherits currentColor for monochrome paint; isolate SVG IDs when repeating it. */\n`;
  const header =
    '// Generated from Mateo foundation SVGs by scripts/generate-mateo-icons.ts.\n';
  mateoOutput.set(
    `${filename}.js`,
    `${header}${comment}export const ${symbol} = Object.freeze(${JSON.stringify({ viewBox, markup })});\n`,
  );
  mateoOutput.set(
    `${filename}.d.ts`,
    `${header}import type { MateoSvgIcon } from './mateo-svg-icon.js';\n${comment}export declare const ${symbol}: MateoSvgIcon;\n`,
  );
  mateoOutput.set(`svg/${source}`, svg);
  mateoIndex.push(`export { ${symbol} } from './${filename}.js';`);
}
const mateoSourceFiles = readdirSync(mateoSourceRoot).filter((file) =>
  file.endsWith('.svg'),
);
if (
  mateoSources.size === 0 ||
  mateoSourceFiles.some((file) => !mateoSources.has(file))
) {
  throw new Error(
    'The Mateo catalog must include every canonical SVG exactly once.',
  );
}
mateoOutput.set('index.d.ts', `${mateoIndex.join('\n')}\n`);
mateoOutput.set('index.js', `${mateoIndex.slice(1).join('\n')}\n`);
const mateoDistRoot = join(mateoPackageRoot, 'dist');
if (process.argv.includes('--check')) {
  const files = readdirSync(mateoDistRoot, {
    recursive: true,
    encoding: 'utf8',
  }).filter((file) => /\.(?:js|ts|svg)$/.test(file));
  if (files.length !== mateoOutput.size)
    throw new Error('Generated Mateo icon files are out of date.');
  for (const [file, contents] of mateoOutput) {
    if (readFileSync(join(mateoDistRoot, file), 'utf8') !== contents)
      throw new Error(`Generated icon is out of date: ${file}.`);
  }
} else {
  rmSync(mateoDistRoot, { recursive: true, force: true });
  mkdirSync(join(mateoDistRoot, 'svg'), { recursive: true });
  for (const [file, contents] of mateoOutput)
    writeFileSync(join(mateoDistRoot, file), contents);
}
