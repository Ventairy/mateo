import { readdirSync, readFileSync } from 'node:fs';
import { join, resolve } from 'node:path';
import { act, render, screen } from '@testing-library/react';
import { createRef } from 'react';
import { hydrateRoot } from 'react-dom/client';
import { renderToString } from 'react-dom/server';
import { describe, expect, it } from 'vitest';
import * as MateoIcons from '../../mateo-icons.js';
import {
  MateoArrowDownIcon,
  MateoArrowLeftIcon,
  MateoCircleCheckIcon,
  MateoClockIcon,
  MateoCrossIcon,
  MateoShoppingCartIcon,
  MateoWhatsappIcon,
} from '../../mateo-icons.js';

const mateoIconCatalog = Object.entries(MateoIcons).map(([component, Icon]) => {
  const name = component.slice(5, -4);
  return { name: name.slice(0, 1).toLowerCase() + name.slice(1), Icon };
});

const mateoIconSources = resolve(
  '../../../design-system/foundation/assets/icons/svg',
);
const mateoIconSourceExceptions: Readonly<Record<string, string>> = {
  arrowRotateClockwise: 'arrow-rotate-clockise',
  mapPin: 'location-pin',
  magnifierGlass: 'magnifying-glass',
  wifiExclamation: 'wifi-exclamation-mark',
};

function _getMateoIconSourceName(name: string) {
  return (
    mateoIconSourceExceptions[name] ??
    name.replace(/[A-Z]/g, (letter) => `-${letter.toLowerCase()}`)
  );
}

describe('Mateo named icons', () => {
  it('should include every foundation SVG when exposing the catalog', () => {
    expect(
      mateoIconCatalog
        .map(({ name }) => `${_getMateoIconSourceName(name)}.svg`)
        .sort(),
    ).toEqual(
      readdirSync(mateoIconSources)
        .filter((name) => name.endsWith('.svg'))
        .sort(),
    );
  });
  it.each(mateoIconCatalog)(
    'should render the catalog artwork when using $name',
    ({ name: icon, Icon }) => {
      render(<Icon aria-label={icon} />);
      const image = screen.getByRole('img', { name: icon });
      expect(image).toHaveAttribute('viewBox', '0 0 20 20');
      expect(image.querySelector('path, rect, circle')).not.toBeNull();
      expect(image.querySelector('[transform]')).not.toBeNull();
      const source = new DOMParser().parseFromString(
        readFileSync(
          join(mateoIconSources, `${_getMateoIconSourceName(icon)}.svg`),
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
    render(<MateoCrossIcon aria-label="Close" />);
    const image = screen.getByRole('img', { name: 'Close' });
    expect(image).toHaveAttribute('width', '20');
    expect(image).toHaveAttribute('height', '20');
    expect(image.style.getPropertyValue('--mateo-icon-size')).toBe('20px');
    expect(image).toHaveAttribute('focusable', 'false');
  });

  it('should size the complete square when a custom size is supplied', () => {
    render(<MateoCircleCheckIcon size={32} aria-label="Completed" />);
    const image = screen.getByRole('img', { name: 'Completed' });
    expect(image).toHaveAttribute('width', '32');
    expect(image).toHaveAttribute('height', '32');
    expect(image.style.getPropertyValue('--mateo-icon-size')).toBe('32px');
  });

  it('should render empty when size is zero even with a background', () => {
    render(
      <MateoCrossIcon size={0} backgroundColor="black" aria-label="Close" />,
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
    expect(() => renderToString(<MateoCrossIcon size={value} />)).toThrow(
      'Mateo icon size must be finite and nonnegative.',
    );
  });

  it('should reject a nonnumeric size when a JavaScript consumer supplies it', () => {
    expect(() =>
      renderToString(
        // @ts-expect-error JavaScript consumers can bypass the numeric contract.
        <MateoCrossIcon size="24" />,
      ),
    ).toThrow('Mateo icon size must be finite and nonnegative.');
  });

  it('should inherit foreground without recoloring clipping geometry when color is omitted', () => {
    render(
      <span style={{ color: 'rebeccapurple' }}>
        <MateoShoppingCartIcon aria-label="Cart" />
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
      <MateoCrossIcon
        color="white"
        backgroundColor="black"
        aria-label="Close"
      />,
    );
    rerender(
      <MateoCrossIcon
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
        <MateoCrossIcon />
        <MateoCrossIcon aria-label="  " />
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
        <MateoCrossIcon />
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
        <MateoArrowLeftIcon aria-label="Left" />
        <MateoWhatsappIcon aria-label="WhatsApp" />
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
        <MateoShoppingCartIcon aria-label="First cart" />
        <MateoShoppingCartIcon aria-label="Second cart" />
        <MateoClockIcon aria-label="Clock" />
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
