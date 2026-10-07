import { readdirSync, readFileSync } from 'node:fs';
import { join, resolve } from 'node:path';
import { act, render, screen } from '@testing-library/react';
import { createRef } from 'react';
import { hydrateRoot } from 'react-dom/client';
import { renderToString } from 'react-dom/server';
import { describe, expect, it } from 'vitest';
import {
  MateoArrowDownIcon,
  MateoCrossIcon,
  MateoShoppingCartIcon,
} from '../../mateo-icons.js';
import { MateoIcon } from './mateo-icon.js';
import { mateoIconNames } from './mateo-icon-artwork.js';

const mateoIconSources = resolve(
  '../../../design-system/foundation/assets/icons/svg',
);
const mateoIconSourceExceptions: Readonly<Record<string, string>> = {
  arrowRotateClockwise: 'arrow-rotate-clockise',
  mapPin: 'location-pin',
  magnifierGlass: 'magnifying-glass',
  wifiExclamation: 'wifi-exclamation-mark',
};

function getMateoIconSourceName(name: string) {
  return (
    mateoIconSourceExceptions[name] ??
    name.replace(/[A-Z]/g, (letter) => `-${letter.toLowerCase()}`)
  );
}

describe('MateoIcon', () => {
  it('should include every foundation SVG when exposing the catalog', () => {
    expect(
      mateoIconNames
        .map((name) => `${getMateoIconSourceName(name)}.svg`)
        .sort(),
    ).toEqual(
      readdirSync(mateoIconSources)
        .filter((name) => name.endsWith('.svg'))
        .sort(),
    );
  });
  it.each(mateoIconNames)(
    'should render the catalog artwork when choosing %s',
    (icon) => {
      render(<MateoIcon icon={icon} aria-label={icon} />);
      const image = screen.getByRole('img', { name: icon });
      expect(image).toHaveAttribute('viewBox', '0 0 20 20');
      expect(image.querySelector('path, rect, circle')).not.toBeNull();
      expect(image.querySelector('[transform]')).not.toBeNull();
      const source = new DOMParser().parseFromString(
        readFileSync(
          join(mateoIconSources, `${getMateoIconSourceName(icon)}.svg`),
          'utf8',
        ),
        'image/svg+xml',
      );
      expect(source.documentElement.getAttribute('viewBox')).toBe('0 0 20 20');
      for (const attribute of ['d', 'transform']) {
        const authored = [...source.querySelectorAll(`[${attribute}]`)].map(
          (element) => element.getAttribute(attribute),
        );
        const rendered = [...image.querySelectorAll(`[${attribute}]`)].map(
          (element) => element.getAttribute(attribute),
        );
        expect(rendered).toEqual(authored);
      }
    },
  );

  it('should render at 20 pixels without a theme when size is omitted', () => {
    render(<MateoIcon icon="cross" aria-label="Close" />);
    const image = screen.getByRole('img', { name: 'Close' });
    expect(image).toHaveAttribute('width', '20');
    expect(image).toHaveAttribute('height', '20');
    expect(image.style.getPropertyValue('--mateo-icon-size')).toBe('20px');
    expect(image).toHaveAttribute('focusable', 'false');
  });

  it('should size the complete square when a custom size is supplied', () => {
    render(<MateoIcon icon="circleCheck" size={32} aria-label="Completed" />);
    const image = screen.getByRole('img', { name: 'Completed' });
    expect(image).toHaveAttribute('width', '32');
    expect(image).toHaveAttribute('height', '32');
    expect(image.style.getPropertyValue('--mateo-icon-size')).toBe('32px');
  });

  it('should render empty when size is zero even with a background', () => {
    render(
      <MateoIcon
        icon="cross"
        size={0}
        backgroundColor="black"
        aria-label="Close"
      />,
    );
    const image = screen.getByRole('img', { name: 'Close' });
    expect(image).toHaveAttribute('width', '0');
    expect(image).toHaveAttribute('height', '0');
    expect(image).toBeEmptyDOMElement();
  });

  it.each([
    { name: 'negative', value: -1 },
    { name: 'NaN', value: Number.NaN },
    { name: 'positive infinity', value: Number.POSITIVE_INFINITY },
    { name: 'negative infinity', value: Number.NEGATIVE_INFINITY },
  ])('should reject size when it is $name', ({ value }) => {
    expect(() =>
      renderToString(<MateoIcon icon="cross" size={value} />),
    ).toThrow('MateoIcon size must be finite and nonnegative.');
  });

  it('should reject a nonnumeric size when a JavaScript consumer supplies it', () => {
    expect(() =>
      renderToString(
        // @ts-expect-error JavaScript consumers can bypass the numeric contract.
        <MateoIcon icon="cross" size="24" />,
      ),
    ).toThrow('MateoIcon size must be finite and nonnegative.');
  });

  it.each(['unknown', 'toString', '__proto__'])(
    'should reject the icon when a JavaScript consumer supplies %s',
    (icon) => {
      expect(() =>
        renderToString(
          // @ts-expect-error JavaScript consumers can bypass catalog names.
          <MateoIcon icon={icon} />,
        ),
      ).toThrow(`Unknown Mateo icon: ${icon}.`);
    },
  );

  it('should inherit foreground without recoloring clipping geometry when color is omitted', () => {
    render(
      <span style={{ color: 'rebeccapurple' }}>
        <MateoIcon icon="shoppingCart" aria-label="Cart" />
      </span>,
    );
    const image = screen.getByRole('img', { name: 'Cart' });
    expect(image.style.getPropertyValue('--mateo-icon-color')).toBe('');
    for (const path of image.querySelectorAll('path')) {
      expect(path).toHaveAttribute('fill', 'currentColor');
    }
    expect(image.querySelector('clipPath rect')).toHaveAttribute(
      'fill',
      'white',
    );
  });

  it('should update explicit foreground independently when the background changes', () => {
    const { rerender } = render(
      <MateoIcon
        icon="cross"
        color="white"
        backgroundColor="black"
        aria-label="Close"
      />,
    );
    rerender(
      <MateoIcon
        icon="cross"
        color="white"
        backgroundColor="rebeccapurple"
        aria-label="Close"
      />,
    );
    const image = screen.getByRole('img', { name: 'Close' });
    expect(image.style.getPropertyValue('--mateo-icon-color')).toBe('white');
    expect(image.style.getPropertyValue('--mateo-icon-background')).toBe(
      'rebeccapurple',
    );
    expect(image.querySelector(':scope > circle')).toHaveAttribute('r', '10');
    expect(image.querySelector(':scope > g')).toHaveAttribute(
      'transform',
      'translate(3.5 3.5) scale(0.65)',
    );
  });

  it('should remain decorative when no nonempty image label is supplied', () => {
    const { container } = render(
      <>
        <MateoIcon icon="cross" />
        <MateoIcon icon="cross" aria-label="  " />
        <MateoArrowDownIcon aria-label="  " />
      </>,
    );
    expect(screen.queryByRole('img')).not.toBeInTheDocument();
    for (const image of container.querySelectorAll('svg')) {
      expect(image).toHaveAttribute('aria-hidden', 'true');
      expect(image).not.toHaveAttribute('aria-label');
    }
  });

  it('should preserve the parent action name when used inside a button', () => {
    render(
      <button type="button" aria-label="Close dialog">
        <MateoIcon icon="cross" />
      </button>,
    );
    expect(screen.getByRole('button')).toHaveAccessibleName('Close dialog');
    expect(screen.queryByRole('img')).not.toBeInTheDocument();
  });

  it('should expose the native SVG when a ref is supplied', () => {
    const ref = createRef<SVGSVGElement>();
    render(<MateoCrossIcon aria-label="Close" ref={ref} />);
    expect(ref.current).toBe(screen.getByRole('img', { name: 'Close' }));
  });

  it('should preserve artwork direction when the surrounding content is RTL', () => {
    render(
      <div dir="rtl">
        <MateoIcon icon="arrowLeft" aria-label="Left" />
        <MateoIcon icon="whatsapp" aria-label="WhatsApp" />
      </div>,
    );
    for (const image of screen.getAllByRole('img')) {
      expect(image.querySelector(':scope > g')).not.toHaveAttribute(
        'transform',
      );
    }
  });

  it('should keep clipping references local when repeated icons hydrate', async () => {
    const mateoImages = (
      <>
        <MateoIcon icon="shoppingCart" aria-label="First cart" />
        <MateoShoppingCartIcon aria-label="Second cart" />
        <MateoIcon icon="clock" aria-label="Clock" />
      </>
    );
    const container = document.createElement('div');
    container.innerHTML = renderToString(mateoImages);
    document.body.append(container);
    const before = container.innerHTML;
    const errors: unknown[] = [];
    const root = hydrateRoot(container, mateoImages, {
      onRecoverableError: (error) => errors.push(error),
    });
    await act(async () => {});
    expect(errors).toEqual([]);
    expect(container.innerHTML).toBe(before);
    const ids = [...container.querySelectorAll('[id]')].map(
      (element) => element.id,
    );
    expect(new Set(ids).size).toBe(ids.length);
    for (const image of container.querySelectorAll('svg')) {
      const localIds = new Set(
        [...image.querySelectorAll('[id]')].map((element) => element.id),
      );
      for (const clipped of image.querySelectorAll('[clip-path]')) {
        const reference = clipped.getAttribute('clip-path')?.slice(5, -1);
        expect(localIds.has(reference ?? '')).toBe(true);
      }
    }
    await act(async () => root.unmount());
    container.remove();
  });
});
