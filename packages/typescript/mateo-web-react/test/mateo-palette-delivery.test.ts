import assert from 'node:assert/strict';
import { execFileSync } from 'node:child_process';
import { mkdtemp, readFile, rm, writeFile } from 'node:fs/promises';
import { createRequire } from 'node:module';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { test } from 'node:test';
import { fileURLToPath } from 'node:url';

test('should share palette runtime and public types when installed outside the workspace', async () => {
  const consumer = await mkdtemp(
    join(tmpdir(), 'mateo-react-palette-consumer-'),
  );
  const packageRoot = fileURLToPath(new URL('..', import.meta.url));
  try {
    for (const [directory, filename] of [
      [packageRoot, 'react.tgz'],
      [join(packageRoot, '../mateo-palette'), 'palette.tgz'],
    ] as const) {
      execFileSync(
        'pnpm',
        ['pack', '--ignore-scripts', '--out', join(consumer, filename)],
        {
          cwd: directory,
          stdio: 'pipe',
        },
      );
    }
    await writeFile(
      join(consumer, 'package.json'),
      JSON.stringify({
        private: true,
        type: 'module',
        dependencies: {
          '@mateo/web-react': 'file:./react.tgz',
          react: '19.3.0',
          'react-dom': '19.3.0',
          '@types/react': '19.3.0',
          '@types/react-dom': '19.3.0',
        },
      }),
    );
    // The Git revision cannot contain unpushed changes. Supply the packed
    // palette through consumer resolution without rewriting React's manifest.
    await writeFile(
      join(consumer, 'pnpm-workspace.yaml'),
      "overrides:\n  '@mateo/palette': file:./palette.tgz\n",
    );
    execFileSync('pnpm', ['install', '--ignore-scripts'], {
      cwd: consumer,
      stdio: 'pipe',
    });
    const manifest = JSON.parse(
      await readFile(
        join(consumer, 'node_modules/@mateo/web-react/package.json'),
        'utf8',
      ),
    );
    assert.equal(
      manifest.dependencies['@mateo/palette'],
      'github:Ventairy/mateo#main&path:/packages/typescript/mateo-palette',
    );
    const entry = join(consumer, 'consumer.ts');
    await writeFile(
      entry,
      `
      import { createMateoPalette, type MateoPalette, type MateoColorScale, type MateoColorStep } from '@mateo/web-react';
      const palette: MateoPalette = createMateoPalette();
      const step: MateoColorStep = 11;
      const scale: MateoColorScale = palette.green;
      const color: string = scale[step];
      // @ts-expect-error Palette shades remain readonly across the re-export.
      scale[11] = color;
      // @ts-expect-error Only supported steps are accepted.
      palette.green[13];
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
      import { createMateoPalette } from '@mateo/web-react';
      const reactEntry = import.meta.resolve('@mateo/web-react');
      const paletteEntry = import.meta.resolve('@mateo/palette', reactEntry);
      const { createMateoPalette: sharedFactory, MateoDefaultPalette } = await import(paletteEntry);
      assert.equal(createMateoPalette, sharedFactory);
      assert.equal(createMateoPalette(), MateoDefaultPalette);
      assert.equal(createMateoPalette().green[11], '#006F29');
      assert.equal(createMateoPalette({ accentColor: '#00A86B' }).accent[9], '#00A86B');
    `,
    );
    execFileSync(
      process.execPath,
      ['--experimental-import-meta-resolve', 'runtime.mjs'],
      {
        cwd: consumer,
        stdio: 'pipe',
      },
    );
  } finally {
    await rm(consumer, { recursive: true, force: true });
  }
});
