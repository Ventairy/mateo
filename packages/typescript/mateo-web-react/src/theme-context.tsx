'use client';

import { createContext, type ReactNode, use } from 'react';
import type { MateoThemeData } from './theme.js';

const ThemeContext = createContext<MateoThemeData | null>(null);

/** A theme boundary for React descendants; adds no HTML or layout. */
export interface MateoThemeProps {
  readonly data: MateoThemeData;
  readonly children: ReactNode;
}

/** Provide one consistent theme. Apply its CSS variables to an app-owned element. */
export function MateoTheme({ data, children }: MateoThemeProps) {
  return <ThemeContext value={data}>{children}</ThemeContext>;
}

/** Read the nearest Mateo theme and subscribe to its updates. */
export function useMateoTheme(): MateoThemeData {
  const theme = use(ThemeContext);
  if (!theme) {
    throw new Error(
      'useMateoTheme() requires a MateoTheme ancestor. Wrap this subtree in <MateoTheme data={theme}>.',
    );
  }
  return theme;
}
