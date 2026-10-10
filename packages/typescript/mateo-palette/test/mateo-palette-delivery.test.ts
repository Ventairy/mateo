import assert from 'node:assert/strict';
import { execFileSync } from 'node:child_process';
import { mkdtemp, readFile, rm, writeFile } from 'node:fs/promises';
import { createRequire } from 'node:module';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { test } from 'node:test';
import { fileURLToPath } from 'node:url';

test('should deliver immutable typed palettes when installed as a packed external dependency', async () => {
  const consumer = await mkdtemp(join(tmpdir(), 'mateo-palette-consumer-'));
  const packageRoot = fileURLToPath(new URL('..', import.meta.url));
  try {
    execFileSync('pnpm', ['pack', '--out', join(consumer, 'palette.tgz')], {
      cwd: packageRoot,
      stdio: 'pipe',
    });
    await writeFile(
      join(consumer, 'package.json'),
      '{"type":"module","private":true}',
    );
    execFileSync(
      'npm',
      [
        'install',
        '--ignore-scripts',
        '--no-audit',
        '--no-fund',
        '--package-lock=false',
        './palette.tgz',
      ],
      { cwd: consumer, stdio: 'pipe' },
    );
    const entry = join(consumer, 'consumer.ts');
    await writeFile(
      entry,
      `
      import { MateoDefaultPalette, type MateoColorStep, type MateoColorScale } from '@mateo/palette';
      const step: MateoColorStep = 11;
      const scale: MateoColorScale = MateoDefaultPalette.green;
      const color: string = scale[step];
      // @ts-expect-error Scales have no step zero.
      MateoDefaultPalette.green[0];
      // @ts-expect-error Scales end at step twelve.
      MateoDefaultPalette.green[13];
      // @ts-expect-error Unsupported scale names are rejected.
      MateoDefaultPalette.greenn;
      // @ts-expect-error Scale shades are readonly.
      scale[1] = color;
      // @ts-expect-error Primitives are readonly.
      MateoDefaultPalette.white = color;
      // @ts-expect-error Only supported one-based steps are accepted.
      const invalid: MateoColorStep = 13;
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
        'ES2023',
        entry,
      ],
      { cwd: consumer, stdio: 'pipe' },
    );
    await writeFile(
      join(consumer, 'runtime.mjs'),
      `
      import assert from 'node:assert/strict';
      import { MateoDefaultPalette, createMateoPalette } from '@mateo/palette';
      assert.equal(MateoDefaultPalette.green[11], '#006F29');
      assert.equal(createMateoPalette(), MateoDefaultPalette);
      assert.equal(createMateoPalette({ accentColor: '#00A86B' }).accent[9], '#00A86B');
      assert.ok(Object.isFrozen(MateoDefaultPalette));
      assert.ok(Object.isFrozen(MateoDefaultPalette.green));
      assert.throws(() => { MateoDefaultPalette.green[11] = '#000000'; }, TypeError);
    `,
    );
    execFileSync(process.execPath, ['runtime.mjs'], {
      cwd: consumer,
      stdio: 'pipe',
    });
    const manifest: unknown = JSON.parse(
      await readFile(
        join(consumer, 'node_modules/@mateo/palette/package.json'),
        'utf8',
      ),
    );
    assert.ok(typeof manifest === 'object' && manifest !== null);
    assert.deepEqual(Reflect.get(manifest, 'dependencies'), {
      culori: '4.0.2',
    });
    assert.equal(Reflect.get(manifest, 'peerDependencies'), undefined);
  } finally {
    await rm(consumer, { recursive: true, force: true });
  }
});
