import { act, render, screen } from '@testing-library/react';
import { createRef, StrictMode } from 'react';
import { hydrateRoot } from 'react-dom/client';
import { renderToString } from 'react-dom/server';
import { describe, expect, it, vi } from 'vitest';
import {
  createMateoTheme,
  type MateoThemeData,
} from '../../theme/mateo-theme.js';
import { MateoTheme } from '../../theme/mateo-theme-context.js';
import { MateoSurface, type MateoSurfaceProps } from './mateo-surface.js';

const mateoTestTheme = createMateoTheme({
  accentColor: '#4A5CFF',
  onAccent: '#FFF',
});
const otherMateoTheme: MateoThemeData = {
  ...mateoTestTheme,
  colorScheme: { ...mateoTestTheme.colorScheme, background: '#F5F5F5' },
};

function MateoSurfaceExample(props: Omit<MateoSurfaceProps, 'children'>) {
  return (
    <MateoTheme data={mateoTestTheme}>
      <MateoSurface data-testid="surface" {...props}>
        <span>Content</span>
      </MateoSurface>
    </MateoTheme>
  );
}

it('renders one noninteractive content-sized surface with the theme background', () => {
  const { container } = render(<MateoSurfaceExample />);
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
    <MateoSurfaceExample
      width="fill"
      height={240}
      color="rgba(0, 0, 0, 0.2)"
    />,
  );
  const surface = screen.getByTestId('surface');
  expect(surface).toHaveStyle({ width: '100%', height: '240px' });
  expect(surface.style.backgroundColor).toBe('rgba(0, 0, 0, 0.2)');
  expect(surface.style.color).toBe('');
  rerender(
    <MateoSurfaceExample width="20rem" height="50%" color="var(--brand)" />,
  );
  expect(surface.style.width).toBe('20rem');
  expect(surface.style.height).toBe('50%');
  expect(surface.style.backgroundColor).toBe('var(--brand)');
});

it('applies axis padding over uniform padding and removes old overrides', () => {
  const { rerender } = render(
    <MateoSurfaceExample
      padding={8}
      paddingBlock={16}
      paddingInline="1.5rem"
    />,
  );
  const surface = screen.getByTestId('surface');
  expect(surface).toHaveStyle({
    padding: '8px',
    paddingBlock: '16px',
    paddingInline: '1.5rem',
  });
  rerender(
    <MateoSurfaceExample
      padding={12}
      paddingBlock={16}
      paddingInline="1.5rem"
    />,
  );
  expect(surface.style.paddingBlock).toBe('16px');
  expect(surface.style.paddingInline).toBe('1.5rem');
  rerender(<MateoSurfaceExample padding={0} />);
  expect(surface.style.paddingBlock).toBe('');
  expect(surface.style.paddingInline).toBe('');
  expect(surface.style.padding).toBe('0px');
});

it('forwards identification, language, accessibility, data attributes and ref', () => {
  const ref = createRef<HTMLDivElement>();
  render(
    <MateoSurfaceExample
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
  render(<MateoSurfaceExample {...unsupported} />);
  const surface = screen.getByTestId('surface');
  expect(surface.tagName).toBe('DIV');
  expect(surface).not.toHaveClass('custom');
  expect(surface).not.toHaveAttribute('tabindex');
  expect(surface.style.borderRadius).toBe('');
});

it('uses the nearest theme and replaces its background immediately', () => {
  const { rerender } = render(
    <MateoTheme data={mateoTestTheme}>
      <MateoSurface data-testid="outer">
        <MateoTheme data={otherMateoTheme}>
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
    <MateoTheme data={otherMateoTheme}>
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
    expect(() =>
      render(<MateoSurfaceExample {...{ [prop]: value }} />),
    ).toThrow(`${prop} must be finite and nonnegative`);
  });
  it('accepts zero', () => {
    expect(() =>
      render(<MateoSurfaceExample {...{ [prop]: 0 }} />),
    ).not.toThrow();
  });
});

it('server-renders and hydrates the same surface', async () => {
  const container = document.createElement('div');
  const example = <MateoSurfaceExample width={160} paddingInline={20} />;
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

describe('surface shapes', () => {
  function observeMateoSurfaceSizes() {
    let notify = () => {};
    const disconnect = vi.fn();
    const observe = vi.fn();
    vi.stubGlobal(
      'ResizeObserver',
      class {
        constructor(callback: () => void) {
          notify = callback;
        }
        observe = observe;
        disconnect = disconnect;
      },
    );
    return { resize: () => act(() => notify()), disconnect, observe };
  }

  it('should update the clipped outline without remounting content when dimensions or shape change', () => {
    const observer = observeMateoSurfaceSizes();
    try {
      const ref = createRef<HTMLDivElement>();
      const { rerender, unmount } = render(
        <MateoSurfaceExample
          ref={ref}
          width={200}
          height={52}
          shape="capsule"
        />,
      );
      const surface = screen.getByTestId('surface');
      const content = screen.getByText('Content');
      const path = surface.querySelector('path');
      const capsule = path?.getAttribute('d');
      expect(capsule).toContain('A 26 26');
      expect(ref.current).toBe(surface);
      expect(surface.querySelector('svg')).toHaveAttribute(
        'aria-hidden',
        'true',
      );
      expect(surface).toHaveClass('mateo:[clip-path:var(--mateo-clip)]');
      rerender(
        <MateoSurfaceExample
          ref={ref}
          width={140}
          height={76}
          shape="capsule"
        />,
      );
      observer.resize();
      expect(path?.getAttribute('d')).toContain('A 38 38');
      rerender(
        <MateoSurfaceExample
          ref={ref}
          width={140}
          height={76}
          shape={{ type: 'rounded', radius: 24 }}
        />,
      );
      expect(path?.getAttribute('d')).toContain('A 24 24');
      expect(screen.getByText('Content')).toBe(content);
      rerender(<MateoSurfaceExample ref={ref} shape="none" />);
      expect(surface.querySelector('svg')).toBeNull();
      expect(surface.style.getPropertyValue('--mateo-clip')).toBe('');
      expect(screen.getByText('Content')).toBe(content);
      expect(observer.disconnect).toHaveBeenCalled();
      unmount();
      expect(ref.current).toBeNull();
    } finally {
      vi.unstubAllGlobals();
    }
  });

  it('should produce an outline when an initially empty surface becomes visible', () => {
    const observer = observeMateoSurfaceSizes();
    try {
      const { rerender } = render(
        <MateoSurfaceExample width={0} height={0} shape="capsule" />,
      );
      const path = screen.getByTestId('surface').querySelector('path');
      expect(path).toHaveAttribute('d', '');
      rerender(<MateoSurfaceExample width={50} height={50} shape="capsule" />);
      observer.resize();
      expect(path?.getAttribute('d')).toContain('A 25 25');
      expect(path?.getAttribute('d')).not.toContain('C');
    } finally {
      vi.unstubAllGlobals();
    }
  });

  it('should keep clipping independent when multiple rounded surfaces are mounted', () => {
    observeMateoSurfaceSizes();
    try {
      const { container } = render(
        <MateoTheme data={mateoTestTheme}>
          <MateoSurface width={100} height={50} shape="capsule">
            First
          </MateoSurface>
          <MateoSurface
            width={100}
            height={50}
            shape={{ type: 'rounded', radius: 12 }}
          >
            Second
          </MateoSurface>
        </MateoTheme>,
      );
      const clips = [...container.querySelectorAll('clipPath')];
      expect(clips).toHaveLength(2);
      expect(clips[0]?.id).not.toBe(clips[1]?.id);
      for (const clip of clips)
        expect(
          clip.closest('div')?.style.getPropertyValue('--mateo-clip'),
        ).toBe(`url(#${clip.id})`);
    } finally {
      vi.unstubAllGlobals();
    }
  });

  it('should release observers and callback refs when a shaped surface unmounts under Strict Mode', () => {
    const observer = observeMateoSurfaceSizes();
    const cleanup = vi.fn();
    const ref = vi.fn(() => cleanup);
    try {
      const { unmount } = render(
        <StrictMode>
          <MateoSurfaceExample
            ref={ref}
            width={120}
            height={48}
            shape="capsule"
          />
        </StrictMode>,
      );
      expect(
        screen.getByTestId('surface').querySelector('path')?.getAttribute('d'),
      ).toContain('A 24 24');
      unmount();
      expect(observer.disconnect.mock.calls.length).toBe(
        observer.observe.mock.calls.length,
      );
      expect(cleanup.mock.calls.length).toBe(ref.mock.calls.length);
    } finally {
      vi.unstubAllGlobals();
    }
  });

  it.each([-1, NaN, Infinity])(
    'should reject radius %s when a rounded surface renders',
    (radius) => {
      expect(() =>
        render(<MateoSurfaceExample shape={{ type: 'rounded', radius }} />),
      ).toThrow('finite, nonnegative radius');
    },
  );
});
