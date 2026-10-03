import { fileURLToPath } from 'node:url';
import { defineConfig } from 'vitest/config';
import { createMateoIconSvgPlugin } from './scripts/mateo-icon-svg-plugin.js';

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
    environment: 'jsdom',
    setupFiles: ['test/mateo-setup.ts'],
    include: ['src/**/*.test.{ts,tsx}', 'test/**/*.test.{ts,tsx}'],
    clearMocks: true,
    restoreMocks: true,
  },
});
