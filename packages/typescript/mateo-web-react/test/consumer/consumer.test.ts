import { execFileSync } from 'node:child_process';
import { readFileSync } from 'node:fs';
import {
  createMateoPalette,
  createMateoTheme,
  getMateoThemeStyle,
} from 'mateo-web-react';
import { createElement } from 'react';
import { renderToStaticMarkup } from 'react-dom/server';
import { expect, it } from 'vitest';
import { ConsumerFixture, SurfaceFixture } from './fixture.js';

it('exposes working factories through installed public exports', () => {
  expect(createMateoPalette().accent[9]).toBe('#4A5CFF');
  const theme = createMateoTheme({
    accentColor: 'rgb(0 168 107)',
    onAccent: '#000',
  });
  expect(getMateoThemeStyle(theme)['--mateo-color-accent']).toBe(
    'rgb(0 168 107)',
  );
});

it('retains the client boundary and keeps the main entry server-safe', () => {
  const client = readFileSync(
    'node_modules/mateo-web-react/dist/react.js',
    'utf8',
  );
  const core = readFileSync(
    'node_modules/mateo-web-react/dist/index.js',
    'utf8',
  );
  expect(client).toMatch(/^['"]use client['"];\s/);
  expect(core).not.toMatch(/^['"]use client['"];\s/);
  expect(core).not.toMatch(/(?:from\s*|import\s*)['"]react(?:\/|['"])/);
});

it('supports native Node imports without browser globals', () => {
  expect(() =>
    execFileSync(
      process.execPath,
      [
        '--input-type=module',
        '-e',
        `
    import { createMateoPalette } from 'mateo-web-react';
    if (typeof document !== 'undefined') throw new Error('Unexpected browser globals');
    if (createMateoPalette().accent[9] !== '#4A5CFF') throw new Error('Invalid palette');
  `,
      ],
      { stdio: 'pipe' },
    ),
  ).not.toThrow();
});

it('typechecks a strict NodeNext consumer through public declarations', () => {
  expect(() =>
    execFileSync('pnpm', ['exec', 'tsc', '-p', 'tsconfig.json'], {
      stdio: 'pipe',
    }),
  ).not.toThrow();
});

it('server-renders nested themes and CSS variables without added wrappers', () => {
  const html = renderToStaticMarkup(createElement(ConsumerFixture));
  expect(html).toMatch(/^<main style=/);
  expect(html.match(/<main/g)).toHaveLength(1);
  expect(html.match(/<section/g)).toHaveLength(1);
  expect(html.match(/<span>/g)).toHaveLength(3);
  expect(html.match(/<span>(.*?)<\/span>/g)).toEqual([
    '<span>#4A5CFF</span>',
    '<span>#00A86B</span>',
    '<span>#4A5CFF</span>',
  ]);
  expect(html).toContain('--mateo-color-accent:#4A5CFF');
  expect(html).toContain('--mateo-color-accent:#00A86B');
});

it('renders a surface from the installed React entry', () => {
  const html = renderToStaticMarkup(createElement(SurfaceFixture));
  expect(html).toMatch(/^<div/);
  expect(html.match(/<div/g)).toHaveLength(1);
  expect(html).toContain('id="consumer-surface"');
  expect(html).toContain('width:100%');
  expect(html).toContain('height:240px');
  expect(html).toContain('padding-block:16px');
  expect(html).toContain('padding-inline:1rem');
  expect(html).toContain('background-color:#FFFFFF');
  expect(html).toContain('Content</div>');
});

it('ships compiled, prefixed CSS without requiring Tailwind in the app', () => {
  const css = readFileSync(
    new URL(import.meta.resolve('mateo-web-react/styles.css')),
    'utf8',
  );
  const html = renderToStaticMarkup(createElement(SurfaceFixture));
  const classes = html.match(/class="([^"]+)"/)?.[1]?.split(' ') ?? [];
  expect(classes.length).toBeGreaterThan(0);
  for (const className of classes) {
    expect(className).toMatch(/^mateo:/);
    expect(css).toContain(`.${className.replaceAll(':', '\\:')}{`);
  }
  expect(css).toContain('box-sizing:border-box');
  expect(css).toContain('max-width:100%');
  expect(css).toContain('max-height:100%');
  expect(css).toContain('overflow:visible');
  expect(css).not.toMatch(/@(?:import|source|theme)\b/);
  expect(css).not.toMatch(/(?:\*|html|body|:root)\s*[{,]/);
  expect(css).not.toMatch(/--(?:color|spacing|font)-/);
  const manifest = JSON.parse(
    readFileSync('node_modules/mateo-web-react/package.json', 'utf8'),
  );
  expect(manifest.sideEffects).toContain('**/*.css');
  expect(manifest.dependencies).not.toHaveProperty('tailwindcss');
});
