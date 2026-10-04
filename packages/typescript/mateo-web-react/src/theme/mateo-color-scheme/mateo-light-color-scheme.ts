import type { MateoPalette } from '../mateo-palette/mateo-palette.js';
import { MateoButtonColorScheme } from './mateo-button-color-scheme.js';
import { MateoButtonsColorScheme } from './mateo-buttons-color-scheme.js';
import type { MateoColorScheme } from './mateo-color-scheme.js';
import { MateoPrimaryButtonColorScheme } from './mateo-primary-button-color-scheme.js';
import { MateoSecondaryButtonColorScheme } from './mateo-secondary-button-color-scheme.js';
import { MateoTextColorScheme } from './mateo-text-color-scheme.js';

/** The single source of semantic color assignments for the light appearance. */
export function createMateoLightColorSchemeRoles(
  palette: MateoPalette,
  onAccent: string,
): Pick<
  MateoColorScheme,
  'background' | 'accent' | 'onAccent' | 'buttons' | 'text'
> {
  return {
    background: palette.white,
    accent: palette.accent[9],
    onAccent,
    text: new MateoTextColorScheme({
      primary: palette.neutral[12],
      secondary: palette.neutral[10],
      tertiary: palette.neutral[8],
      profit: palette.green[9],
    }),
    buttons: new MateoButtonsColorScheme({
      primary: new MateoPrimaryButtonColorScheme({
        accent: new MateoButtonColorScheme({
          background: palette.accent[9],
          foreground: onAccent,
          backgroundDisabled: palette.neutral[4],
          foregroundDisabled: palette.neutral[9],
        }),
        success: new MateoButtonColorScheme({
          background: palette.green[9],
          foreground: palette.white,
          backgroundDisabled: palette.neutral[4],
          foregroundDisabled: palette.neutral[9],
        }),
        warning: new MateoButtonColorScheme({
          background: palette.amber[9],
          foreground: palette.white,
          backgroundDisabled: palette.neutral[4],
          foregroundDisabled: palette.neutral[9],
        }),
        neutral: new MateoButtonColorScheme({
          background: palette.neutral[12],
          foreground: palette.neutral[1],
          backgroundDisabled: palette.neutral[5],
          foregroundDisabled: palette.neutral[9],
        }),
        base: new MateoButtonColorScheme({
          background: palette.white,
          foreground: palette.black,
          backgroundDisabled: palette.neutral[4],
          foregroundDisabled: palette.neutral[9],
        }),
      }),
      secondary: new MateoSecondaryButtonColorScheme({
        accent: new MateoButtonColorScheme({
          background: palette.accent[2],
          foreground: palette.accent[9],
          backgroundDisabled: palette.neutral[4],
          foregroundDisabled: palette.neutral[9],
        }),
        neutral: new MateoButtonColorScheme({
          background: palette.neutral[2],
          foreground: palette.neutral[12],
          backgroundDisabled: palette.neutral[5],
          foregroundDisabled: palette.neutral[9],
        }),
      }),
      tertiary: new MateoButtonColorScheme({
        background: 'transparent',
        foreground: palette.neutral[12],
        backgroundDisabled: 'transparent',
        foregroundDisabled: palette.neutral[9],
      }),
    }),
  };
}
