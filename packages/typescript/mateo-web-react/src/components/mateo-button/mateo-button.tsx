'use client';

import type { AriaAttributes, CSSProperties, MouseEvent, Ref } from 'react';
import type { MateoButtonsColorScheme } from '../../theme/mateo-color-scheme/mateo-buttons-color-scheme.js';
import { useMateoTheme } from '../../theme/mateo-theme-context.js';
import { MateoPress } from '../mateo-press/mateo-press.js';
import { mateoButtonHeights } from './mateo-button-options.js';
import type {
  MateoButtonPresentation,
  MateoButtonVariant,
} from './mateo-button-presentation.js';
import { MateoIconButtonContent } from './presentations/mateo-icon-button-presentation.js';
import {
  getMateoLabelButtonClassName,
  MateoLabelButtonContent,
} from './presentations/mateo-label-button-presentation.js';

/** One native action with separately reusable content and appearance. */
export interface MateoButtonProps extends AriaAttributes {
  readonly presentation: MateoButtonPresentation;
  /** Omit to disable. Pending promises and errors remain caller-owned. */
  readonly onPressed?: (
    event: MouseEvent<HTMLButtonElement>,
  ) => void | Promise<void>;
  readonly ref?: Ref<HTMLButtonElement>;
  readonly id?: string;
  readonly [attribute: `data-${string}`]: string | number | boolean | undefined;
}

function getMateoButtonColors(
  colors: MateoButtonsColorScheme,
  variant: MateoButtonVariant,
) {
  const treatments = {
    primary: colors.primary.accent,
    'primary-success': colors.primary.success,
    'primary-warning': colors.primary.warning,
    'primary-neutral': colors.primary.neutral,
    'primary-base': colors.primary.base,
    secondary: colors.secondary.accent,
    'secondary-neutral': colors.secondary.neutral,
    tertiary: colors.tertiary,
  } as const;
  if (!Object.hasOwn(treatments, variant))
    throw new TypeError('Unsupported MateoButton variant.');
  return treatments[variant];
}

/** Composes press interaction with the surface rendered by its presentation. */
export function MateoButton({
  presentation,
  onPressed,
  ref,
  id,
  ...attributes
}: MateoButtonProps) {
  const theme = useMateoTheme();
  const enabled = onPressed !== undefined;
  if (
    (presentation?.kind !== 'label' && presentation?.kind !== 'icon') ||
    typeof presentation.label !== 'string' ||
    !presentation.label.trim()
  ) {
    throw new TypeError(
      'MateoButton requires a supported presentation with a nonempty label.',
    );
  }
  const { label, variant = 'primary', size = 'standard' } = presentation;
  if (!Object.hasOwn(mateoButtonHeights, size))
    throw new TypeError('Unsupported MateoButton size.');
  const className =
    presentation.kind === 'label'
      ? getMateoLabelButtonClassName(presentation)
      : 'mateo:w-fit';
  const colors = getMateoButtonColors(theme.colorScheme.buttons, variant);
  const foreground = enabled ? colors.foreground : colors.foregroundDisabled;
  const style: CSSProperties & Record<`--mateo-${string}`, string> = {
    '--mateo-button-height': `${mateoButtonHeights[size]}px`,
    '--mateo-button-background': enabled
      ? colors.background
      : colors.backgroundDisabled,
    '--mateo-button-foreground': foreground,
    '--mateo-press-focus': theme.colorScheme.accent,
  };
  const accessibleAttributes = Object.fromEntries(
    Object.entries(attributes).filter(
      ([name]) => name.startsWith('aria-') || name.startsWith('data-'),
    ),
  );
  return (
    <span
      style={style}
      className={[
        'mateo:inline-grid mateo:box-border mateo:max-w-full mateo:align-middle',
        className,
      ].join(' ')}
    >
      <MateoPress
        {...accessibleAttributes}
        as="button"
        {...(onPressed === undefined ? {} : { onPressed })}
        {...(ref === undefined ? {} : { ref })}
        {...(id === undefined ? {} : { id })}
        aria-label={attributes['aria-label'] ?? label}
      >
        {presentation.kind === 'label' ? (
          <MateoLabelButtonContent
            presentation={presentation}
            foreground={foreground}
          />
        ) : (
          <MateoIconButtonContent
            presentation={presentation}
            foreground={foreground}
          />
        )}
      </MateoPress>
    </span>
  );
}
