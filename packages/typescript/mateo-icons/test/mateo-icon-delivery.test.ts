import assert from 'node:assert/strict';
import { execFileSync } from 'node:child_process';
import { cp, mkdir, mkdtemp, rm, writeFile } from 'node:fs/promises';
import { createRequire } from 'node:module';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { test } from 'node:test';
import { fileURLToPath, pathToFileURL } from 'node:url';
import { MateoPlaneUpRightIconData } from '@mateo/icons/plane-up-right';
import { MateoShoppingBagIconData } from '@mateo/icons/shopping-bag';
import { MateoWhatsappIconData } from '@mateo/icons/whatsapp';
import { build } from 'vite';

test('should deliver typed individual artwork without unrelated icons when installed independently', async () => {
  const consumer = await mkdtemp(join(tmpdir(), 'mateo-icons-consumer-'));
  const packageRoot = fileURLToPath(new URL('..', import.meta.url));
  try {
    const installed = join(consumer, 'node_modules/@mateo/icons');
    await mkdir(installed, { recursive: true });
    for (const file of [
      'dist',
      'package.json',
      'LICENSE',
      'mateo-icon-catalog.json',
    ]) {
      await cp(join(packageRoot, file), join(installed, file), {
        recursive: true,
      });
    }
    await writeFile(join(consumer, 'package.json'), '{"type":"module"}');
    const entry = join(consumer, 'consumer.ts');
    await writeFile(
      entry,
      `
      import { MateoShoppingBagIconData } from '@mateo/icons/shopping-bag';
      import type { MateoSvgIcon } from '@mateo/icons';
      const icon: MateoSvgIcon = MateoShoppingBagIconData;
      // @ts-expect-error Artwork is readonly.
      icon.markup = '';
      // @ts-expect-error Icons require a coordinate frame.
      const incomplete: MateoSvgIcon = { markup: '' };
      console.log(icon, incomplete);
    `,
    );
    const require = createRequire(import.meta.url);
    execFileSync(
      process.execPath,
      [
        require.resolve('typescript/bin/tsc'),
        '--noEmit',
        '--strict',
        '--module',
        'NodeNext',
        '--moduleResolution',
        'NodeNext',
        '--target',
        'ES2022',
        entry,
      ],
      { cwd: consumer, stdio: 'pipe' },
    );
    for (const specifier of ['@mateo/icons/shopping-bag', '@mateo/icons']) {
      await writeFile(
        entry,
        `import { MateoShoppingBagIconData } from '${specifier}'; export default MateoShoppingBagIconData;`,
      );
      const result = await build({
        configFile: false,
        root: consumer,
        logLevel: 'silent',
        build: { write: false, minify: true, lib: { entry, formats: ['es'] } },
      });
      const outputs = Array.isArray(result) ? result : [result];
      const bundle = outputs
        .flatMap((output) => {
          if (!('output' in output))
            throw new Error('The icon check requires a completed build.');
          return output.output;
        })
        .map((output) => (output.type === 'chunk' ? output.code : ''))
        .join('');
      const unrelatedPath = /\bd="([^"]+)"/.exec(
        MateoPlaneUpRightIconData.markup,
      )?.[1];
      assert.ok(unrelatedPath);
      assert.ok(bundle.includes('currentColor'));
      assert.ok(!bundle.includes(unrelatedPath));
      assert.ok(
        bundle.length < 10_000,
        'A single raw icon should not include the catalog or framework runtime.',
      );
    }
    const runtime = join(consumer, 'runtime.mjs');
    await writeFile(
      runtime,
      "export { MateoShoppingBagIconData as default } from '@mateo/icons/shopping-bag';",
    );
    const imported: unknown = await import(pathToFileURL(runtime).href);
    assert.ok(
      typeof imported === 'object' &&
        imported !== null &&
        'default' in imported,
    );
    assert.deepEqual(imported.default, MateoShoppingBagIconData);
  } finally {
    await rm(consumer, { recursive: true, force: true });
  }
});

test('should preserve authored clip paint and optical spacing when providing raw SVG artwork', () => {
  assert.equal(MateoShoppingBagIconData.viewBox, '0 0 20 20');
  assert.ok(Object.isFrozen(MateoShoppingBagIconData));
  assert.match(
    MateoShoppingBagIconData.markup,
    /id="mateo-optical-size" transform="matrix\(/,
  );
  assert.match(MateoWhatsappIconData.markup, /fill="white"/);
});
