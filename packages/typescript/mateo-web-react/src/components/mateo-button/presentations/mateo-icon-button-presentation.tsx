'use client';

import type { ReactNode } from 'react';
import { MateoIconProvider } from '../../mateo-icon/mateo-icon-provider.js';
import { MateoSurface } from '../../mateo-surface/mateo-surface.js';
import type {
  MateoButtonColorSchemeOverride,
  MateoButtonSize,
  MateoButtonVariant,
} from '../mateo-button-options.js';

/**
 * Circular icon-only button presentation with a required accessible label.
 *
 * @remarks
 * Use a recognizable icon and a localized label describing the action. The icon
 * is decorative to assistive technology; the button owns its accessible name.
 */
export interface MateoIconButtonPresentation {
  /**
   * Selects the circular icon-only presentation.
   */
  readonly kind: 'icon';
  /**
   * Visible, noninteractive artwork. Mateo icons inherit presentation size and color.
   */
  readonly icon: ReactNode;
  /**
   * Localized accessible action name; not drawn as visible text. Must be nonempty.
   */
  readonly label: string;
  /**
   * Semantic color treatment.
   *
   * @defaultValue `"primary"`
   */
  readonly variant?: MateoButtonVariant;
  /**
   * Overrides the selected variant's colors one role at a time.
   *
   * @remarks
   * Omitted or `undefined` roles retain the variant's colors. Changing an enabled
   * color does not change its disabled counterpart. Choose foreground and
   * background colors that remain readable together.
   *
   * @defaultValue The selected variant's theme colors.
   */
  readonly colorScheme?: MateoButtonColorSchemeOverride;
  /**
   * Square dimensions and icon proportions for this circular button.
   *
   * @defaultValue `"standard"`
   */
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
