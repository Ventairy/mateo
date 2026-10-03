import { act, render, screen } from '@testing-library/react';
import { createRef } from 'react';
import { hydrateRoot } from 'react-dom/client';
import { renderToString } from 'react-dom/server';
import { describe, expect, it } from 'vitest';
import { createMateoTheme, type MateoThemeData } from '../../theme.js';
import { MateoTheme } from '../../theme-context.js';
import { MateoSurface, type MateoSurfaceProps } from './mateo-surface.js';

const theme = createMateoTheme({ accentColor: '#4A5CFF', onAccent: '#FFF' });
const other: MateoThemeData = {
  ...theme,
  colorScheme: { ...theme.colorScheme, background: '#F5F5F5' },
};

function Example(props: Omit<MateoSurfaceProps, 'children'>) {
  return (
    <MateoTheme data={theme}>
      <MateoSurface data-testid="surface" {...props}>
        <span>Content</span>
      </MateoSurface>
    </MateoTheme>
  );
}

it('renders one noninteractive content-sized surface with the theme background', () => {
  const { container } = render(<Example />);
  const surface = screen.getByTestId('surface');
  expect(container.querySelectorAll('div')).toHaveLength(1);
  expect(surface).toHaveStyle({
    width: 'fit-content',
    height: 'fit-content',
    padding: '0px',
    backgroundColor: '#FFFFFF',
  });
  expect(surface).not.toHaveAttribute('tabindex');
  expect(surface).not.toHaveAttribute('role');
  expect(surface).toHaveTextContent('Content');
});

it('supports fill, pixel and CSS dimensions without changing the foreground', () => {
  const { rerender } = render(
    <Example width="fill" height={240} color="rgba(0, 0, 0, 0.2)" />,
  );
  const surface = screen.getByTestId('surface');
  expect(surface).toHaveStyle({ width: '100%', height: '240px' });
  expect(surface.style.backgroundColor).toBe('rgba(0, 0, 0, 0.2)');
  expect(surface.style.color).toBe('');
  rerender(<Example width="20rem" height="50%" color="var(--brand)" />);
  expect(surface.style.width).toBe('20rem');
  expect(surface.style.height).toBe('50%');
  expect(surface.style.backgroundColor).toBe('var(--brand)');
});

it('applies axis padding over uniform padding and removes old overrides', () => {
  const { rerender } = render(
    <Example padding={8} paddingBlock={16} paddingInline="1.5rem" />,
  );
  const surface = screen.getByTestId('surface');
  expect(surface).toHaveStyle({
    padding: '8px',
    paddingBlock: '16px',
    paddingInline: '1.5rem',
  });
  rerender(<Example padding={12} paddingBlock={16} paddingInline="1.5rem" />);
  expect(surface.style.paddingBlock).toBe('16px');
  expect(surface.style.paddingInline).toBe('1.5rem');
  rerender(<Example padding={0} />);
  expect(surface.style.paddingBlock).toBe('');
  expect(surface.style.paddingInline).toBe('');
  expect(surface.style.padding).toBe('0px');
});

it('forwards identification, language, accessibility, data attributes and ref', () => {
  const ref = createRef<HTMLDivElement>();
  render(
    <Example
      ref={ref}
      id="group"
      title="Details"
      dir="rtl"
      lang="ar"
      role="group"
      aria-label="Details"
      data-state="ready"
    />,
  );
  const surface = screen.getByRole('group', { name: 'Details' });
  expect(ref.current).toBe(surface);
  for (const [key, value] of Object.entries({
    id: 'group',
    title: 'Details',
    dir: 'rtl',
    lang: 'ar',
    'data-state': 'ready',
  })) {
    expect(surface).toHaveAttribute(key, value);
  }
});

it('ignores unsupported styling and interaction even from untyped callers', () => {
  const unsupported = {
    className: 'custom',
    style: { borderRadius: 20 },
    onClick: () => {},
    tabIndex: 0,
    as: 'button',
  };
  render(<Example {...unsupported} />);
  const surface = screen.getByTestId('surface');
  expect(surface.tagName).toBe('DIV');
  expect(surface).not.toHaveClass('custom');
  expect(surface).not.toHaveAttribute('tabindex');
  expect(surface.style.borderRadius).toBe('');
});

it('uses the nearest theme and replaces its background immediately', () => {
  const { rerender } = render(
    <MateoTheme data={theme}>
      <MateoSurface data-testid="outer">
        <MateoTheme data={other}>
          <MateoSurface data-testid="inner">Nested</MateoSurface>
        </MateoTheme>
      </MateoSurface>
    </MateoTheme>,
  );
  expect(screen.getByTestId('outer')).toHaveStyle({ backgroundColor: '#FFF' });
  expect(screen.getByTestId('inner')).toHaveStyle({
    backgroundColor: '#F5F5F5',
  });
  rerender(
    <MateoTheme data={other}>
      <MateoSurface data-testid="outer">Changed</MateoSurface>
    </MateoTheme>,
  );
  expect(screen.getByTestId('outer')).toHaveStyle({
    backgroundColor: '#F5F5F5',
  });
});

it('requires a theme even with an explicit background', () => {
  expect(() =>
    render(<MateoSurface color="#FFF">Content</MateoSurface>),
  ).toThrow('useMateoTheme() requires a MateoTheme ancestor');
});

describe.each([
  'width',
  'height',
  'padding',
  'paddingBlock',
  'paddingInline',
] as const)('%s numeric validation', (prop) => {
  it.each([-1, NaN, Infinity, -Infinity])('rejects %s', (value) => {
    expect(() => render(<Example {...{ [prop]: value }} />)).toThrow(
      `${prop} must be finite and nonnegative`,
    );
  });
  it('accepts zero', () => {
    expect(() => render(<Example {...{ [prop]: 0 }} />)).not.toThrow();
  });
});

it('server-renders and hydrates the same surface', async () => {
  const container = document.createElement('div');
  const example = <Example width={160} paddingInline={20} />;
  container.innerHTML = renderToString(example);
  document.body.append(container);
  const original = container.innerHTML;
  const errors: unknown[] = [];
  let root: ReturnType<typeof hydrateRoot> | undefined;
  try {
    await act(async () => {
      root = hydrateRoot(container, example, {
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
