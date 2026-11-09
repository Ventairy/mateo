import {
  copyFileSync,
  globSync,
  mkdirSync,
  readFileSync,
  writeFileSync,
} from 'node:fs';
import { createRequire } from 'node:module';
import { dirname, join, relative, sep } from 'node:path';
import { fileURLToPath } from 'node:url';

const mateoDist = fileURLToPath(new URL('../dist/', import.meta.url));
const mateoPaletteEntry = fileURLToPath(import.meta.resolve('@mateo/palette'));
const mateoPaletteDist = dirname(mateoPaletteEntry);
const mateoBundledPalette = join(mateoDist, 'internal', 'palette');

// Vite includes the runtime palette. Point TypeScript's emitted re-exports
// at the declarations shipped alongside it so consumers resolve the same API.
const mateoDeclarations = globSync('**/*.d.ts', { cwd: mateoDist });
mkdirSync(mateoBundledPalette, { recursive: true });
for (const file of globSync('*.d.ts', { cwd: mateoPaletteDist })) {
  copyFileSync(join(mateoPaletteDist, file), join(mateoBundledPalette, file));
}

for (const file of mateoDeclarations) {
  const declaration = join(mateoDist, file);
  const source = readFileSync(declaration, 'utf8');
  const path = relative(
    dirname(declaration),
    join(mateoBundledPalette, 'mateo-palette.js'),
  )
    .split(sep)
    .join('/');
  const specifier = path.startsWith('../') ? path : `./${path}`;
  const bundled = source.replaceAll(
    /(['"])@mateo\/palette\1/g,
    `$1${specifier}$1`,
  );
  if (bundled !== source) writeFileSync(declaration, bundled);
}

// Keep the notice for the color conversion library included in the bundle.
const mateoPaletteRequire = createRequire(mateoPaletteEntry);
const culoriRoot = dirname(mateoPaletteRequire.resolve('culori/package.json'));
copyFileSync(
  join(culoriRoot, 'LICENSE'),
  join(mateoBundledPalette, 'culori-LICENSE'),
);
