import { execFileSync } from 'node:child_process';
import { mkdtemp, rm, writeFile } from 'node:fs/promises';
import { createRequire } from 'node:module';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { test } from 'node:test';
import { fileURLToPath } from 'node:url';

test('should provide palette runtime and public types when only web-react is installed', async () => {
  const consumer = await mkdtemp(
    join(tmpdir(), 'mateo-react-palette-consumer-'),
  );
  const packageRoot = fileURLToPath(new URL('..', import.meta.url));
  try {
    execFileSync(
      'pnpm',
      ['pack', '--ignore-scripts', '--out', join(consumer, 'react.tgz')],
      { cwd: packageRoot, stdio: 'pipe' },
    );
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
    execFileSync('pnpm', ['install', '--ignore-pnpmfile', '--ignore-scripts'], {
      cwd: consumer,
      stdio: 'pipe',
    });
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
      import { createMateoPalette, createMateoTheme } from '@mateo/web-react';
      const accentColor = '#00A86B';
      assert.deepEqual(
        createMateoTheme({ accentColor, onAccent: '#000000' }).palette,
        createMateoPalette({ accentColor }),
      );
      assert.equal(createMateoPalette().green[11], '#006F29');
      assert.equal(createMateoPalette({ accentColor }).accent[9], accentColor);
    `,
    );
    execFileSync(process.execPath, ['runtime.mjs'], {
      cwd: consumer,
      stdio: 'pipe',
    });
  } finally {
    await rm(consumer, { recursive: true, force: true });
  }
});
