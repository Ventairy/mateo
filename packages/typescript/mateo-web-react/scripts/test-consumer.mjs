import { execFileSync } from 'node:child_process';
import {
  cpSync,
  mkdtempSync,
  readFileSync,
  rmSync,
  writeFileSync,
} from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { fileURLToPath } from 'node:url';

const packageRoot = fileURLToPath(new URL('../', import.meta.url));
const manifest = JSON.parse(
  readFileSync(join(packageRoot, 'package.json'), 'utf8'),
);
const consumer = mkdtempSync(join(tmpdir(), 'mateo-consumer-'));
const run = (args, cwd = consumer) =>
  execFileSync('pnpm', args, { cwd, stdio: 'inherit' });

try {
  // Packing runs the package's prepare build before creating the artifact.
  run(['pack', '--pack-destination', consumer], packageRoot);
  cpSync(join(packageRoot, 'test/consumer'), consumer, { recursive: true });
  const dependencies = Object.fromEntries(
    [
      'react',
      'react-dom',
      '@types/react',
      '@types/react-dom',
      'typescript',
      'vitest',
    ].map((name) => [name, manifest.devDependencies[name]]),
  );
  writeFileSync(
    join(consumer, 'package.json'),
    JSON.stringify({
      name: 'mateo-external-consumer',
      private: true,
      type: 'module',
      packageManager: manifest.packageManager,
      dependencies: {
        ...dependencies,
        [manifest.name]: `file:./${manifest.name}-${manifest.version}.tgz`,
      },
    }),
  );
  run(['install', '--offline', '--ignore-scripts']);
  run(['exec', 'vitest', 'run']);
} finally {
  rmSync(consumer, { recursive: true, force: true });
}
