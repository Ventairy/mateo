import assert from 'node:assert/strict';
import { execFileSync } from 'node:child_process';
import { readFileSync } from 'node:fs';
import { cp, mkdir, mkdtemp, rm, symlink, writeFile } from 'node:fs/promises';
import { createRequire } from 'node:module';
import { tmpdir } from 'node:os';
import { dirname, join } from 'node:path';
import { fileURLToPath, pathToFileURL } from 'node:url';
import { gzipSync } from 'node:zlib';
import { createElement } from 'react';
import { renderToStaticMarkup } from 'react-dom/server';
import { build } from 'vite';

const mateoPackageRoot = fileURLToPath(new URL('..', import.meta.url));
const mateoRequire = createRequire(new URL('../package.json', import.meta.url));
const mateoConsumerRoot = await mkdtemp(join(tmpdir(), 'mateo-icon-delivery-'));

try {
  await mkdir(join(mateoConsumerRoot, 'node_modules'));
  const installedPackage = join(
    mateoConsumerRoot,
    'node_modules/@mateo/web-react',
  );
  await mkdir(installedPackage, { recursive: true });
  await cp(join(mateoPackageRoot, 'dist'), join(installedPackage, 'dist'), {
    recursive: true,
  });
  await cp(
    join(mateoPackageRoot, 'package.json'),
    join(installedPackage, 'package.json'),
  );
  for (const dependency of ['react', 'react-dom']) {
    await symlink(
      dirname(mateoRequire.resolve(`${dependency}/package.json`)),
      join(mateoConsumerRoot, 'node_modules', dependency),
      'dir',
    );
  }
  await mkdir(join(mateoConsumerRoot, 'node_modules/@types'));
  for (const dependency of ['@types/react', '@types/react-dom']) {
    await symlink(
      dirname(mateoRequire.resolve(`${dependency}/package.json`)),
      join(mateoConsumerRoot, 'node_modules', dependency),
      'dir',
    );
  }
  const typeEntry = join(mateoConsumerRoot, 'consumer.tsx');
  await writeFile(
    typeEntry,
    `import { createRef } from 'react';
import { MateoAppleLogoIcon, MateoArrowDownIcon, type MateoNamedIconProps } from '@mateo/web-react/icons';
const props: MateoNamedIconProps = {
  size: 24, color: 'currentColor', backgroundColor: 'white',
  'aria-label': 'Artwork', ref: createRef<SVGSVGElement>(),
};
<MateoAppleLogoIcon {...props} />;
<MateoArrowDownIcon {...props} />;
// @ts-expect-error Artwork is chosen by the imported component.
<MateoAppleLogoIcon icon="appleLogo" />;
// @ts-expect-error Icon sizes use numeric pixels.
<MateoArrowDownIcon size="24px" />;
// @ts-expect-error The ref targets an SVG element.
<MateoArrowDownIcon ref={createRef<HTMLDivElement>()} />;
`,
  );
  execFileSync(
    process.execPath,
    [
      mateoRequire.resolve('typescript/bin/tsc'),
      '--noEmit',
      '--strict',
      '--exactOptionalPropertyTypes',
      '--skipLibCheck',
      '--target',
      'ES2022',
      '--module',
      'ESNext',
      '--moduleResolution',
      'Bundler',
      '--jsx',
      'react-jsx',
      typeEntry,
    ],
    { cwd: mateoConsumerRoot, stdio: 'pipe' },
  );
  const entry = join(mateoConsumerRoot, 'consumer.mjs');
  await writeFile(
    entry,
    `import { createElement } from 'react';
import { MateoArrowDownIcon } from '@mateo/web-react/icons';
import { MateoIconProvider } from '@mateo/web-react/react';
export function MateoConsumerIcon() {
  return createElement(MateoIconProvider, { size: 24 },
    createElement(MateoArrowDownIcon, { 'aria-label': 'Down' }));
}
`,
  );
  const result = await build({
    configFile: false,
    root: mateoConsumerRoot,
    logLevel: 'error',
    build: {
      write: false,
      minify: true,
      sourcemap: false,
      rolldownOptions: {
        input: entry,
        preserveEntrySignatures: 'strict',
        external: (id) => /^(react|react-dom)(\/|$)/.test(id),
        output: { format: 'es', entryFileNames: 'consumer.mjs' },
      },
    },
  });
  const outputs = (Array.isArray(result) ? result : [result]).flatMap(
    (bundle) => bundle.output,
  );
  const chunks = outputs.filter((output) => output.type === 'chunk');
  const consumer = chunks.find((chunk) => chunk.isEntry);
  assert.ok(consumer, 'The consumer must retain its exported icon component.');
  let bytes = 0;
  let gzipBytes = 0;
  for (const chunk of chunks) {
    bytes += Buffer.byteLength(chunk.code);
    gzipBytes += gzipSync(chunk.code).length;
    const destination = join(mateoConsumerRoot, chunk.fileName);
    await mkdir(dirname(destination), { recursive: true });
    await writeFile(destination, chunk.code);
  }
  const code = chunks.map((chunk) => chunk.code).join('\n');
  for (const filename of ['apple-logo.svg', 'shopping-cart.svg']) {
    const source = readFileSync(
      new URL(
        `../../../../design-system/foundation/assets/icons/svg/${filename}`,
        import.meta.url,
      ),
      'utf8',
    );
    const path = source.match(/<path[^>]*\sd="([^"]+)"/)?.[1];
    assert.ok(path, `${filename} must contain reference artwork.`);
    assert.ok(
      !code.includes(path),
      `The arrow-only consumer must omit ${filename} artwork.`,
    );
  }
  const { MateoConsumerIcon } = await import(
    pathToFileURL(join(mateoConsumerRoot, consumer.fileName)).href
  );
  const markup = renderToStaticMarkup(createElement(MateoConsumerIcon));
  assert.equal(
    markup.match(/<svg(?:\s|>)/g)?.length,
    1,
    'The emitted consumer must render one icon.',
  );
  assert.match(
    markup,
    /role="img"/,
    'The emitted icon must keep image semantics.',
  );
  assert.match(
    markup,
    /aria-label="Down"/,
    'The emitted icon must keep its name.',
  );
  assert.match(
    markup,
    /<path(?:\s|>)/,
    'The emitted icon must contain artwork.',
  );
  assert.ok(
    bytes <= 5_000,
    `One small named icon and its provider must stay within 5,000 JS bytes; got ${bytes}.`,
  );
  assert.ok(
    gzipBytes <= 2_000,
    `One small named icon and its provider must stay within 2,000 gzip bytes; got ${gzipBytes}.`,
  );
  console.log(
    `Mateo icon delivery: ${bytes} JS bytes, ${gzipBytes} gzip bytes.`,
  );
} finally {
  await rm(mateoConsumerRoot, { recursive: true, force: true });
}
