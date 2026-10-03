import tailwindcss from '@tailwindcss/vite';
import { defineConfig } from 'vite';
import { createMateoIconSvgPlugin } from './scripts/mateo-icon-svg-plugin.js';

export default defineConfig({
  plugins: [tailwindcss(), createMateoIconSvgPlugin()],
  resolve: { dedupe: ['react', 'react-dom'] },
  build: {
    cssCodeSplit: true,
    lib: {
      entry: {
        index: 'src/mateo.ts',
        react: 'src/mateo-react.tsx',
        styles: 'src/mateo-styles.css',
      },
      formats: ['es'],
      cssFileName: 'styles',
      fileName: (_format, entryName) => `${entryName}.js`,
    },
    sourcemap: true,
    rolldownOptions: {
      external: (id) => /^(react|react-dom)(\/|$)/.test(id),
    },
  },
});
