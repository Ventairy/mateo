import tailwindcss from '@tailwindcss/vite';
import { defineConfig } from 'vite';

export default defineConfig({
  plugins: [tailwindcss()],
  build: {
    cssCodeSplit: true,
    lib: {
      entry: {
        index: 'src/index.ts',
        react: 'src/react.tsx',
        styles: 'src/styles.css',
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
