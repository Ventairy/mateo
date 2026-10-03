import type { CSSProperties } from 'react';
import {
  createMateoPalette,
  createMateoTheme,
  getMateoThemeStyle,
  type MateoColorStep,
} from '../src';

// This function is checked by tsc, never executed.
export function checkPublicTypes(step: MateoColorStep) {
  const palette = createMateoPalette();
  const color: string = palette.accent[step];
  // @ts-expect-error Scale indices are one-based.
  palette.accent[0];
  // @ts-expect-error Only twelve steps exist.
  palette.accent[13];
  // @ts-expect-error Shades are readonly.
  palette.accent[1] = color;
  // @ts-expect-error The theme requires an explicit foreground.
  createMateoTheme({ accentColor: '#4A5CFF' });
  const theme = createMateoTheme({
    accentColor: '#4A5CFF',
    onAccent: '#FFFFFF',
  });
  // @ts-expect-error The first appearance is light only.
  const dark: typeof theme.appearance = 'dark';
  // @ts-expect-error Semantic roles are immutable.
  theme.colorScheme.background = color;
  const style: CSSProperties = getMateoThemeStyle(theme);
  return { style, dark };
}
