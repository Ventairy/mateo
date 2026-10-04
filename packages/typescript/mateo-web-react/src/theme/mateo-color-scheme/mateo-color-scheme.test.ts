// @vitest-environment node
import { describe, expect, it } from 'vitest';
import {
  createMateoPalette,
  createMateoTheme,
  MateoButtonColorScheme,
  MateoButtonsColorScheme,
  MateoColorScheme,
  MateoPrimaryButtonColorScheme,
  MateoSecondaryButtonColorScheme,
} from '../../mateo.js';

const mateoSchemePalette = createMateoPalette({ accentColor: '#00A86B' });

describe('MateoColorScheme.light', () => {
  it('should create immutable typed groups when deriving the light appearance', () => {
    const scheme = MateoColorScheme.light({
      palette: mateoSchemePalette,
      onAccent: 'rgba(255, 255, 255, 0.8)',
    });
    expect(scheme).toBeInstanceOf(MateoColorScheme);
    expect(scheme.buttons).toBeInstanceOf(MateoButtonsColorScheme);
    expect(scheme.buttons.primary).toBeInstanceOf(
      MateoPrimaryButtonColorScheme,
    );
    expect(scheme.buttons.secondary).toBeInstanceOf(
      MateoSecondaryButtonColorScheme,
    );
    expect(scheme.buttons.primary.accent).toBeInstanceOf(
      MateoButtonColorScheme,
    );
    expect(scheme.buttons.primary.accent.foreground).toBe(scheme.onAccent);
    expect(scheme.onAccent).toBe('rgba(255, 255, 255, 0.8)');
    expect(scheme.buttons.primary.accent.background).toBe(
      mateoSchemePalette.accent[9],
    );
    for (const group of [
      scheme,
      scheme.buttons,
      scheme.buttons.primary,
      scheme.buttons.secondary,
      scheme.buttons.primary.accent,
    ]) {
      expect(Object.isFrozen(group)).toBe(true);
    }
  });

  it('should expose a color scheme instance when creating a theme', () => {
    const theme = createMateoTheme({
      accentColor: '#00A86B',
      onAccent: '#FFF',
    });
    expect(theme.colorScheme).toBeInstanceOf(MateoColorScheme);
    expect(theme.colorScheme).toEqual(
      MateoColorScheme.light({ palette: theme.palette, onAccent: '#FFF' }),
    );
  });

  it('should reject unresolved foreground colors when creating light roles directly', () => {
    expect(() =>
      MateoColorScheme.light({
        palette: mateoSchemePalette,
        onAccent: 'var(--foreground)',
      }),
    ).toThrow(TypeError);
  });
});
