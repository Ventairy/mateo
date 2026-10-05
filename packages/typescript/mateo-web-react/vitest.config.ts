import { resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import { playwright } from '@vitest/browser-playwright';
import { defineConfig } from 'vitest/config';
import { createMateoIconSvgPlugin } from './scripts/mateo-icon-svg-plugin.js';
import { mateoGoldenCommands } from './test/golden/mateo-browser-commands.js';

const mateoBehaviorBrowser = process.env.MATEO_BEHAVIOR_BROWSER;

const mateoBrowserPattern = 'src/**/*.browser.test.tsx';

const mateoGoldenPattern = 'src/**/*.golden.test.tsx';

export default defineConfig({
  plugins: [createMateoIconSvgPlugin()],
  resolve: { dedupe: ['react', 'react-dom'] },
  server: {
    fs: {
      allow: [
        fileURLToPath(new URL('.', import.meta.url)),
        fileURLToPath(
          new URL(
            '../../../design-system/foundation/assets/icons/svg',
            import.meta.url,
          ),
        ),
      ],
    },
  },
  test: {
    projects: [
      {
        extends: true,
        test: {
          name: 'unit',
          environment: 'jsdom',
          setupFiles: ['test/mateo-setup.ts'],
          include: ['src/**/*.test.{ts,tsx}', 'test/**/*.test.{ts,tsx}'],
          exclude: [mateoGoldenPattern, mateoBrowserPattern],
          clearMocks: true,
          restoreMocks: true,
        },
      },
      {
        extends: true,
        test: {
          name: 'browser',
          include: [mateoBrowserPattern],
          setupFiles: ['test/golden/mateo-golden-setup.ts'],
          testTimeout: 30_000,
          browser: {
            enabled: true,
            headless: true,
            provider: playwright({ contextOptions: { hasTouch: true } }),
            instances: [
              {
                browser:
                  mateoBehaviorBrowser === 'firefox' ||
                  mateoBehaviorBrowser === 'webkit'
                    ? mateoBehaviorBrowser
                    : 'chromium',
                viewport: { width: 1280, height: 900 },
              },
            ],
            commands: mateoGoldenCommands,
          },
        },
      },
      {
        extends: true,
        test: {
          name: 'golden',
          include: [mateoGoldenPattern],
          setupFiles: ['test/golden/mateo-golden-setup.ts'],
          attachmentsDir: '.vitest/golden',
          testTimeout: 30_000,
          browser: {
            enabled: true,
            headless: true,
            provider: playwright({
              // Native scrollbars must remain visible in appearance references.
              launchOptions: { ignoreDefaultArgs: ['--hide-scrollbars'] },
              contextOptions: {
                deviceScaleFactor: 1,
                locale: 'en-US',
                timezoneId: 'UTC',
                colorScheme: 'light',
                reducedMotion: 'no-preference',
              },
            }),
            instances: [
              {
                browser: 'chromium',
                viewport: { width: 1280, height: 900 },
              },
            ],
            commands: mateoGoldenCommands,
            expect: {
              toMatchScreenshot: {
                comparatorName: 'pixelmatch',
                comparatorOptions: {
                  threshold: 0,
                  includeAA: true,
                  allowedMismatchedPixelRatio: 0,
                },
                resolveScreenshotPath: ({
                  root,
                  testFileDirectory,
                  testFileName,
                  arg,
                  ext,
                }) =>
                  resolve(
                    root,
                    testFileDirectory,
                    '__screenshots__',
                    testFileName,
                    `${arg}${ext}`,
                  ),
                resolveDiffPath: ({
                  root,
                  attachmentsDir,
                  testFileName,
                  arg,
                  ext,
                }) =>
                  resolve(root, attachmentsDir, testFileName, `${arg}${ext}`),
              },
            },
          },
        },
      },
    ],
  },
});
