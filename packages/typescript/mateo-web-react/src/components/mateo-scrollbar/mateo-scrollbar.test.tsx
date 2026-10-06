import { render } from '@testing-library/react';
import { createMateoTheme } from 'mateo-web-react';
import { MateoScrollbar, MateoTheme } from 'mateo-web-react/react';
import { createRef } from 'react';
import { renderToString } from 'react-dom/server';
import { expect, it } from 'vitest';

const mateoScrollbarTestTheme = createMateoTheme({
  accentColor: '#4A5CFF',
  onAccent: '#FFF',
});

it('should require a theme when mounting a scrollbar', () => {
  expect(() =>
    render(<MateoScrollbar scrollRef={createRef<HTMLElement>()} />),
  ).toThrow('MateoTheme ancestor');
});

it('should preserve native viewport ownership when the target is absent or rendering on the server', () => {
  const target = document.createElement('div');
  const ref = { current: target };
  const markup = renderToString(
    <MateoTheme data={mateoScrollbarTestTheme}>
      <MateoScrollbar scrollRef={ref} />
    </MateoTheme>,
  );
  expect(markup).toContain('role="scrollbar"');
  expect(target.hasAttribute('data-mateo-overlay-scrollbar')).toBe(false);
  expect(target.hasAttribute('id')).toBe(false);
  expect(() =>
    render(
      <MateoTheme data={mateoScrollbarTestTheme}>
        <MateoScrollbar scrollRef={createRef<HTMLElement>()} />
      </MateoTheme>,
    ),
  ).not.toThrow();
});
