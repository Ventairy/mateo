import { act, fireEvent, render, screen } from '@testing-library/react';
import { useState } from 'react';
import { hydrateRoot } from 'react-dom/client';
import { renderToString } from 'react-dom/server';
import { expect, it } from 'vitest';
import { createMateoTheme, getMateoThemeStyle } from './mateo-theme.js';
import { MateoTheme, useMateoTheme } from './mateo-theme-context.js';

const outerMateoTheme = createMateoTheme({
  accentColor: '#4A5CFF',
  onAccent: '#FFFFFF',
});
const innerMateoTheme = createMateoTheme({
  accentColor: '#00A86B',
  onAccent: '#000000',
});

function ReadMateoTheme({ label }: { label: string }) {
  const theme = useMateoTheme();
  return <span data-testid={label}>{theme.colorScheme.accent}</span>;
}

function MateoNestedThemeExample() {
  return (
    <MateoTheme data={outerMateoTheme}>
      <main style={getMateoThemeStyle(outerMateoTheme)}>
        <ReadMateoTheme label="outer" />
        <MateoTheme data={innerMateoTheme}>
          <section style={getMateoThemeStyle(innerMateoTheme)}>
            <ReadMateoTheme label="inner" />
          </section>
        </MateoTheme>
        <ReadMateoTheme label="sibling" />
      </main>
    </MateoTheme>
  );
}

it('uses the nearest theme without adding HTML or leaking to siblings', () => {
  const { container } = render(<MateoNestedThemeExample />);
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
  function MateoSurfaceExample() {
    const [theme, setTheme] = useState(outerMateoTheme);
    return (
      <MateoTheme data={theme}>
        <main style={getMateoThemeStyle(theme)}>
          <ReadMateoTheme label="active" />
          <button type="button" onClick={() => setTheme(innerMateoTheme)}>
            Change theme
          </button>
        </main>
      </MateoTheme>
    );
  }
  const { container } = render(<MateoSurfaceExample />);
  fireEvent.click(screen.getByRole('button', { name: 'Change theme' }));
  expect(screen.getByTestId('active')).toHaveTextContent('#00A86B');
  expect(
    container
      .querySelector('main')
      ?.style.getPropertyValue('--mateo-color-accent'),
  ).toBe('#00A86B');
});

it('reports a missing provider', () => {
  expect(() => render(<ReadMateoTheme label="missing" />)).toThrow(
    'useMateoTheme() requires a MateoTheme ancestor',
  );
});

it('server-renders and hydrates nested variable boundaries without mismatch', async () => {
  const container = document.createElement('div');
  container.innerHTML = renderToString(<MateoNestedThemeExample />);
  document.body.append(container);
  const original = container.innerHTML;
  const errors: unknown[] = [];
  let root: ReturnType<typeof hydrateRoot> | undefined;
  try {
    await act(async () => {
      root = hydrateRoot(container, <MateoNestedThemeExample />, {
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
