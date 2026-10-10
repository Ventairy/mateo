import { readFileSync } from 'node:fs';
import tailwindcss from '@tailwindcss/vite';
import { defineConfig } from 'vite';
import { createMateoIconSvgPlugin } from './scripts/mateo-icon-svg-plugin.js';

export default defineConfig({
  base: './',
  plugins: [
    tailwindcss(),
    createMateoIconSvgPlugin(),
    {
      name: 'mateo-font-license',
      generateBundle() {
        this.emitFile({
          type: 'asset',
          fileName: 'fonts/OFL.txt',
          source: readFileSync(
            new URL(
              './src/foundation/mateo-typography/assets/OFL.txt',
              import.meta.url,
            ),
          ),
        });
      },
    },
  ],
  resolve: { dedupe: ['react', 'react-dom'] },
  build: {
    assetsDir: '',
    cssCodeSplit: true,
    lib: {
      entry: {
        index: 'src/mateo.ts',
        react: 'src/mateo-react.tsx',
        icons: 'src/mateo-icons.tsx',
        styles: 'src/mateo-styles.css',
      },
      formats: ['es'],
      cssFileName: 'styles',
      fileName: (_format, entryName) => `${entryName}.js`,
    },
    sourcemap: true,
    rolldownOptions: {
      external: (id) => /^(react|react-dom|@mateo\/palette)(\/|$)/.test(id),
    },
  },
});
