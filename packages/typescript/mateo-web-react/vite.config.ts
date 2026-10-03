import { defineConfig } from 'vite';

export default defineConfig({
  build: {
    lib: {
      entry: { index: 'src/index.ts', react: 'src/react.tsx' },
      formats: ['es'],
      fileName: (_format, entryName) => `${entryName}.js`,
    },
    sourcemap: true,
    rolldownOptions: {
      external: (id) => /^(react|react-dom)(\/|$)/.test(id),
    },
  },
});
