import { act, fireEvent, render, screen } from '@testing-library/react';
import { useState } from 'react';
import { hydrateRoot } from 'react-dom/client';
import { renderToString } from 'react-dom/server';
import { expect, it } from 'vitest';
import { MateoTheme, useMateoTheme } from './react.js';
import { createMateoTheme, getMateoThemeStyle } from './theme.js';

const outer = createMateoTheme({ accentColor: '#4A5CFF', onAccent: '#FFFFFF' });
const inner = createMateoTheme({ accentColor: '#00A86B', onAccent: '#000000' });

function ReadTheme({ label }: { label: string }) {
  const theme = useMateoTheme();
  return <span data-testid={label}>{theme.colorScheme.accent}</span>;
}

function NestedExample() {
  return (
    <MateoTheme data={outer}>
      <main style={getMateoThemeStyle(outer)}>
        <ReadTheme label="outer" />
        <MateoTheme data={inner}>
          <section style={getMateoThemeStyle(inner)}>
            <ReadTheme label="inner" />
          </section>
        </MateoTheme>
        <ReadTheme label="sibling" />
      </main>
    </MateoTheme>
  );
}

it('uses the nearest theme without adding HTML or leaking to siblings', () => {
  const { container } = render(<NestedExample />);
  expect(screen.getByTestId('outer')).toHaveTextContent('#4A5CFF');
  expect(screen.getByTestId('inner')).toHaveTextContent('#00A86B');
  expect(screen.getByTestId('sibling')).toHaveTextContent('#4A5CFF');
  expect(container.querySelectorAll('*')).toHaveLength(5);
  expect(container.firstElementChild?.tagName).toBe('MAIN');
  expect(
    container
      .querySelector('main')
      ?.style.getPropertyValue('--mateo-color-accent'),
  ).toBe('#4A5CFF');
  expect(
    container
      .querySelector('section')
      ?.style.getPropertyValue('--mateo-color-accent'),
  ).toBe('#00A86B');
});

it('updates context and CSS variables together', () => {
  function Example() {
    const [theme, setTheme] = useState(outer);
    return (
      <MateoTheme data={theme}>
        <main style={getMateoThemeStyle(theme)}>
          <ReadTheme label="active" />
          <button type="button" onClick={() => setTheme(inner)}>
            Change theme
          </button>
        </main>
      </MateoTheme>
    );
  }
  const { container } = render(<Example />);
  fireEvent.click(screen.getByRole('button', { name: 'Change theme' }));
  expect(screen.getByTestId('active')).toHaveTextContent('#00A86B');
  expect(
    container
      .querySelector('main')
      ?.style.getPropertyValue('--mateo-color-accent'),
  ).toBe('#00A86B');
});

it('reports a missing provider', () => {
  expect(() => render(<ReadTheme label="missing" />)).toThrow(
    'useMateoTheme() requires a MateoTheme ancestor',
  );
});

it('server-renders and hydrates nested variable boundaries without mismatch', async () => {
  const container = document.createElement('div');
  container.innerHTML = renderToString(<NestedExample />);
  document.body.append(container);
  const original = container.innerHTML;
  const errors: unknown[] = [];
  let root: ReturnType<typeof hydrateRoot> | undefined;
  try {
    await act(async () => {
      root = hydrateRoot(container, <NestedExample />, {
        onRecoverableError: (error) => errors.push(error),
      });
    });
    expect(errors).toEqual([]);
    expect(container.innerHTML).toBe(original);
  } finally {
    await act(async () => root?.unmount());
    container.remove();
  }
});
