import { readFileSync, writeFileSync } from 'node:fs';
import { dirname, relative, sep } from 'node:path';
import { fileURLToPath } from 'node:url';
import ts from 'typescript';

const mateoIconCatalogPath = new URL(
  '../src/components/mateo-icon/mateo-icon-artwork.tsx',
  import.meta.url,
);
const mateoIconOutput = new URL('../src/mateo-icons.tsx', import.meta.url);
const mateoIconCatalog = ts.createSourceFile(
  fileURLToPath(mateoIconCatalogPath),
  readFileSync(mateoIconCatalogPath, 'utf8'),
  ts.ScriptTarget.Latest,
  true,
  ts.ScriptKind.TSX,
);
const mateoIconImports = new Map();
let mateoIconDefinitions;

for (const statement of mateoIconCatalog.statements) {
  if (
    ts.isImportDeclaration(statement) &&
    ts.isStringLiteral(statement.moduleSpecifier) &&
    statement.moduleSpecifier.text.endsWith('.svg?react') &&
    statement.importClause?.name
  ) {
    mateoIconImports.set(
      statement.importClause.name.text,
      statement.moduleSpecifier.text,
    );
  }
  if (ts.isVariableStatement(statement)) {
    for (const declaration of statement.declarationList.declarations) {
      if (
        ts.isIdentifier(declaration.name) &&
        declaration.name.text === 'mateoIconArtwork' &&
        declaration.initializer &&
        ts.isCallExpression(declaration.initializer) &&
        declaration.initializer.arguments[0] &&
        ts.isObjectLiteralExpression(declaration.initializer.arguments[0])
      ) {
        mateoIconDefinitions = declaration.initializer.arguments[0].properties;
      }
    }
  }
}

if (!mateoIconDefinitions?.length) {
  throw new Error('The Mateo icon catalog must contain named artwork.');
}

const mateoIconEntries = mateoIconDefinitions.map((definition) => {
  if (
    !ts.isPropertyAssignment(definition) ||
    !ts.isIdentifier(definition.name) ||
    !ts.isIdentifier(definition.initializer)
  ) {
    throw new Error('Mateo icon artwork must use named SVG imports.');
  }
  const source = mateoIconImports.get(definition.initializer.text);
  if (!source) {
    throw new Error(`Missing SVG artwork for ${definition.name.text}.`);
  }
  const name = definition.name.text;
  return {
    name,
    artwork: definition.initializer.text,
    component: `Mateo${name[0].toUpperCase()}${name.slice(1)}Icon`,
  };
});

function _getMateoNamedIconImport(source) {
  const sourceUrl = new URL(source, mateoIconCatalogPath);
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
  '// Generated from the authored mateo-icon-artwork.tsx catalog.',
  '// Regenerate with node scripts/generate-mateo-icons.mjs.',
  "'use client';",
  '',
  "import type { ReactElement } from 'react';",
  ...Array.from(
    mateoIconImports,
    ([artwork, source]) =>
      `import ${artwork} from '${_getMateoNamedIconImport(source)}';`,
  ),
  "import { BaseMateoIcon } from './bases/base-mateo-icon/base-mateo-icon.js';",
  "import type { MateoIconProps } from './components/mateo-icon/mateo-icon.js';",
  '',
  '/**',
  ' * Appearance and accessible name for an individually imported Mateo icon.',
  ' *',
  ' * @remarks',
  ' * Named icon components preserve MateoIcon size, color, provider, background,',
  ' * ref, and accessible-name behavior. Import only the icons your interface uses',
  ' * from `mateo-web-react/icons` so a production bundler can omit other artwork.',
  ' * The existing MateoIcon string-name API remains available for dynamic catalogs.',
  ' *',
  ' * @example',
  ' * ```tsx',
  " * import { MateoArrowDownIcon } from 'mateo-web-react/icons';",
  ' * <MateoArrowDownIcon size={24} aria-label="Down" />',
  ' * ```',
  ' */',
  "export type MateoNamedIconProps = Omit<MateoIconProps, 'icon'>;",
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
