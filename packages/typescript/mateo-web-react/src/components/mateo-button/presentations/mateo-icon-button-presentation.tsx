'use client';

import type { ReactNode } from 'react';
import { MateoIconProvider } from '../../mateo-icon/mateo-icon-provider.js';
import { MateoSurface } from '../../mateo-surface/mateo-surface.js';
import type {
  MateoButtonSize,
  MateoButtonVariant,
} from '../mateo-button-options.js';

/** A circular action. Label names the action to assistive technology. */
export interface MateoIconButtonPresentation {
  readonly kind: 'icon';
  readonly icon: ReactNode;
  readonly label: string;
  readonly variant?: MateoButtonVariant;
  readonly size?: MateoButtonSize;
}
const mateoIconButtonDimensions = {
  mini: { iconPx: 16 },
  small: { iconPx: 20 },
  standard: { iconPx: 24 },
} as const;

/** Internal renderer for the icon presentation; MateoButton owns the action. */
export function MateoIconButtonContent({
  presentation,
  foreground,
}: {
  readonly presentation: MateoIconButtonPresentation;
  readonly foreground: string;
}) {
  if (presentation.icon == null || typeof presentation.icon === 'boolean') {
    throw new TypeError(
      'MateoButton icon presentation requires visible icon content.',
    );
  }
  return (
    <MateoSurface
      as="span"
      shape="capsule"
      width="var(--mateo-button-height)"
      height="var(--mateo-button-height)"
      color="var(--mateo-button-background)"
    >
      <span className="mateo:flex mateo:size-(--mateo-button-height) mateo:items-center mateo:justify-center mateo:text-(--mateo-button-foreground)">
        <MateoIconProvider
          size={
            mateoIconButtonDimensions[presentation.size ?? 'standard'].iconPx
          }
          color={foreground}
        >
          <span
            aria-hidden="true"
            className="mateo:inline-flex mateo:shrink-0 mateo:items-center"
          >
            {presentation.icon}
          </span>
        </MateoIconProvider>
      </span>
    </MateoSurface>
  );
}
