'use client';

import { createContext, type ReactNode, use } from 'react';
import type { MateoThemeData } from './mateo-theme.js';

const MateoThemeContext = createContext<MateoThemeData | null>(null);

/** A theme boundary for React descendants; adds no HTML or layout. */
export interface MateoThemeProps {
  /**
   * Theme to make available to descendants. The nearest boundary wins.
   */
  readonly data: MateoThemeData;
  /**
   * Interface that consumes this theme.
   */
  readonly children: ReactNode;
}

/**
 * Provides a theme to React descendants without adding a DOM element.
 *
 * @remarks
 * Use `getMateoThemeStyle` from `@mateo/web-react` on your existing root to apply
 * inherited typography. The provider supplies component colors, but does not
 * apply DOM styles by itself. Nested providers replace the theme for their subtree.
 *
 * @example
 * ```tsx
 * <MateoTheme data={theme}>
 *   <main style={getMateoThemeStyle(theme)}>{content}</main>
 * </MateoTheme>
 * ```
 */
export function MateoTheme({ data, children }: MateoThemeProps) {
  return <MateoThemeContext value={data}>{children}</MateoThemeContext>;
}

/**
 * Reads the nearest theme and subscribes to changes to that boundary.
 *
 * @returns The theme supplied by the closest {@link MateoTheme}.
 * @throws Error - If called without a MateoTheme ancestor.
 */
export function useMateoTheme(): MateoThemeData {
  const theme = use(MateoThemeContext);
  if (!theme) {
    throw new Error(
      'useMateoTheme() requires a MateoTheme ancestor. Wrap this subtree in <MateoTheme data={theme}>.',
    );
  }
  return theme;
}
