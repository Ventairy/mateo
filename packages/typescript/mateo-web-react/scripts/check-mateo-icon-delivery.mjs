import assert from 'node:assert/strict';
import { mkdir, mkdtemp, rm, symlink, writeFile } from 'node:fs/promises';
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
  await symlink(
    mateoPackageRoot,
    join(mateoConsumerRoot, 'node_modules/mateo-web-react'),
    'dir',
  );
  for (const dependency of ['react', 'react-dom']) {
    await symlink(
      dirname(mateoRequire.resolve(`${dependency}/package.json`)),
      join(mateoConsumerRoot, 'node_modules', dependency),
      'dir',
    );
  }
  const entry = join(mateoConsumerRoot, 'consumer.mjs');
  await writeFile(
    entry,
    `import { createElement } from 'react';
import { MateoArrowDownIcon } from 'mateo-web-react/icons';
import { MateoIconProvider } from 'mateo-web-react/react';
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
