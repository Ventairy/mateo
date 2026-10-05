import { createContext, type ReactNode, use } from 'react';
import type { resolveMateoViewPadding } from './mateo-view-padding.js';

export interface MateoViewContextData {
  readonly padding: ReturnType<typeof resolveMateoViewPadding>;
  readonly header: ReactNode;
  readonly maxWidth: number | undefined;
}

export const MateoViewContext = createContext<MateoViewContextData | null>(
  null,
);

export function useMateoViewContext() {
  const view = use(MateoViewContext);
  if (!view)
    throw new Error(
      'MateoViewHeader and MateoViewSurface require a MateoView ancestor.',
    );
  return view;
}
