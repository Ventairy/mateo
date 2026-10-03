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

const mateoPackageRoot = fileURLToPath(new URL('../', import.meta.url));
const mateoManifest = JSON.parse(
  readFileSync(join(mateoPackageRoot, 'package.json'), 'utf8'),
);
const mateoConsumerDirectory = mkdtempSync(join(tmpdir(), 'mateo-consumer-'));
const runMateoConsumerCommand = (args, cwd = mateoConsumerDirectory) =>
  execFileSync('pnpm', args, { cwd, stdio: 'inherit' });

try {
  // Packing runs the package's prepare build before creating the artifact.
  runMateoConsumerCommand(
    ['pack', '--pack-destination', mateoConsumerDirectory],
    mateoPackageRoot,
  );
  cpSync(join(mateoPackageRoot, 'test/consumer'), mateoConsumerDirectory, {
    recursive: true,
  });
  const dependencies = Object.fromEntries(
    [
      'react',
      'react-dom',
      '@types/react',
      '@types/react-dom',
      'typescript',
      'vitest',
    ].map((name) => [name, mateoManifest.devDependencies[name]]),
  );
  writeFileSync(
    join(mateoConsumerDirectory, 'package.json'),
    JSON.stringify({
      name: 'mateo-external-consumer',
      private: true,
      type: 'module',
      packageManager: mateoManifest.packageManager,
      dependencies: {
        ...dependencies,
        [mateoManifest.name]: `file:./${mateoManifest.name}-${mateoManifest.version}.tgz`,
      },
    }),
  );
  runMateoConsumerCommand(['install', '--offline', '--ignore-scripts']);
  runMateoConsumerCommand(['exec', 'vitest', 'run']);
} finally {
  rmSync(mateoConsumerDirectory, { recursive: true, force: true });
}
