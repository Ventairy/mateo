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

/**
 * Configuration for one native Mateo button action.
 *
 * @remarks
 * Supports React ARIA attributes and `data-*` attributes on the button. Use
 * `presentation` for supported appearance choices and `onPressed` to enable the
 * action. An `aria-label` overrides the presentation label as the accessible name.
 */
export interface MateoButtonProps extends AriaAttributes {
  /**
   * Visible content, accessible label, size, and treatment for this action.
   */
  readonly presentation: MateoButtonPresentation;
  /**
   * Called when the enabled action is activated by pointer, keyboard, or assistive
   * technology. Omit to disable the button.
   *
   * @remarks
   * Promises do not automatically show pending state or disable repeated activation.
   * Handle pending state and errors in the calling application.
   */
  readonly onPressed?: (
    event: MouseEvent<HTMLButtonElement>,
  ) => void | Promise<void>;
  /**
   * Ref to the underlying native button, suitable for moving focus.
   */
  readonly ref?: Ref<HTMLButtonElement>;
  /**
   * DOM identifier on the native button for relationships and lookup.
   */
  readonly id?: string;
  /**
   * Consumer data attributes forwarded to the native button.
   */
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

/**
 * Renders a native action with Mateo colors, shape, and press feedback.
 *
 * @remarks
 * Requires a MateoTheme ancestor. Uses `type="button"`, so activation does not
 * submit a form. Omit `onPressed` to disable. Keyboard and pointer feedback respect
 * reduced-motion preferences. Label presentations truncate when space is limited;
 * the full label remains the default accessible name.
 *
 * @throws TypeError - If the presentation, label, icon content, or supported
 * appearance options are invalid.
 * @throws Error - If there is no MateoTheme ancestor.
 *
 * @example
 * ```tsx
 * <MateoButton
 *   presentation={{ kind: "label", label: "Save", variant: "primary" }}
 *   onPressed={() => save()}
 * />
 * ```
 */
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
