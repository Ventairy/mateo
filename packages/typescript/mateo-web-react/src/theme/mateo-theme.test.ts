// @vitest-environment node

import { describe, expect, it } from 'vitest';
import type { MateoColorStep } from './mateo-palette/mateo-palette.js';
import * as mateoPaletteValues from './mateo-palette/mateo-palette-values.js';
import { createMateoTheme, getMateoThemeStyle } from './mateo-theme.js';

describe('light theme', () => {
  it('derives exactly three roles and preserves transparent foregrounds', () => {
    const theme = createMateoTheme({
      accentColor: '#00A86B',
      onAccent: 'rgba(255, 255, 255, 0.8)',
    });
    expect(theme.appearance).toBe('light');
    expect(theme.colorScheme).toEqual({
      background: theme.palette.white,
      accent: theme.palette.accent[9],
      onAccent: 'rgba(255, 255, 255, 0.8)',
    });
    expect(Object.isFrozen(theme)).toBe(true);
    expect(Object.isFrozen(theme.colorScheme)).toBe(true);
  });

  it('requires both concrete colors even from untyped callers', () => {
    expect(() => Reflect.apply(createMateoTheme, null, [{}])).toThrow(
      TypeError,
    );
    expect(() =>
      Reflect.apply(createMateoTheme, null, [{ accentColor: '#4A5CFF' }]),
    ).toThrow(TypeError);
    expect(() =>
      createMateoTheme({ accentColor: '#4A5CFF', onAccent: 'var(--text)' }),
    ).toThrow(TypeError);
  });

  it('exposes all palette primitives and semantic roles as CSS variables', () => {
    const theme = createMateoTheme({
      accentColor: '#00A86B',
      onAccent: '#000',
    });
    const style = getMateoThemeStyle(theme);
    expect(Object.keys(style)).toHaveLength(149);
    expect(Object.isFrozen(style)).toBe(true);
    for (const name of mateoPaletteValues.scaleNames) {
      for (let step = 1; step <= 12; step++) {
        expect(style[`--mateo-palette-${name}-${step}`]).toBe(
          theme.palette[name][step as MateoColorStep],
        );
      }
    }
    expect(style['--mateo-palette-white']).toBe('#FFFFFF');
    expect(style['--mateo-palette-black']).toBe('#000000');
    expect(style['--mateo-color-background']).toBe(
      theme.colorScheme.background,
    );
    expect(style['--mateo-color-accent']).toBe(theme.colorScheme.accent);
    expect(style['--mateo-color-on-accent']).toBe('#000');
  });
});
