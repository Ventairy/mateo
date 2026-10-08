'use client';

import type { CSSProperties, ReactNode } from 'react';
import { mateoTypography } from '../../../foundation/mateo-typography/mateo-typography.js';
import { MateoIconProvider } from '../../mateo-icon/mateo-icon-provider.js';
import { MateoSurface } from '../../mateo-surface/mateo-surface.js';
import type {
  MateoButtonAlignment,
  MateoButtonColorSchemeOverride,
  MateoButtonSize,
  MateoButtonVariant,
  MateoButtonWidth,
} from '../mateo-button-options.js';

/**
 * Text-led button presentation with optional decorative icons.
 *
 * @remarks
 * The visible label and default accessible name are the same. Limited width
 * truncates the label visually. Icons are hidden from assistive technology and
 * must not contain separate actions.
 */
export interface MateoLabelButtonPresentation {
  /**
   * Selects the text-led presentation.
   */
  readonly kind: 'label';
  /**
   * Localized action text. Must contain non-whitespace content.
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
   * Size controlling label, icon, padding, and minimum height.
   *
   * @defaultValue `"standard"`
   */
  readonly size?: MateoButtonSize;
  /**
   * Whether the button follows its content or fills its parent.
   *
   * @defaultValue `"fit"`
   */
  readonly width?: MateoButtonWidth;
  /**
   * Alignment of the content group within the button.
   *
   * @defaultValue `"center"`
   */
  readonly alignment?: MateoButtonAlignment;
  /** Decorative, noninteractive content. Mateo icons receive scoped defaults. */
  readonly leadingIcon?: ReactNode;
  /**
   * Decorative content after the label in reading order. Mateo icons inherit
   * size and foreground from the presentation.
   */
  readonly trailingIcon?: ReactNode;
}

export const mateoLabelButtonDimensions = {
  mini: {
    fontPx: 14,
    linePx: 20,
    iconPx: 16,
    inlinePaddingPx: 16,
    blockPaddingPx: 6,
  },
  small: {
    fontPx: 15,
    linePx: 20,
    iconPx: 20,
    inlinePaddingPx: 20,
    blockPaddingPx: 10,
  },
  standard: {
    fontPx: 16,
    linePx: 24,
    iconPx: 24,
    inlinePaddingPx: 24,
    blockPaddingPx: 12,
  },
} as const;

/** Presentation width, independent of press interaction. */
export function getMateoLabelButtonClassName(
  presentation: MateoLabelButtonPresentation,
) {
  const width = presentation.width ?? 'fit';
  if (width !== 'fit' && width !== 'fill')
    throw new TypeError('Unsupported MateoButton width.');
  return width === 'fill' ? 'mateo:w-full' : 'mateo:w-fit';
}

/** Internal renderer for the label presentation; MateoButton owns the action. */
export function MateoLabelButtonContent({
  presentation,
  foreground,
}: {
  readonly presentation: MateoLabelButtonPresentation;
  readonly foreground: string;
}) {
  const {
    label,
    size = 'standard',
    alignment = 'center',
    leadingIcon,
    trailingIcon,
  } = presentation;
  if (alignment !== 'start' && alignment !== 'center' && alignment !== 'end')
    throw new TypeError('Unsupported MateoButton alignment.');
  const dimensions = mateoLabelButtonDimensions[size];
  const style: CSSProperties & Record<`--mateo-${string}`, string> = {
    '--mateo-button-font': `${dimensions.fontPx}px`,
    '--mateo-button-line': `${dimensions.linePx}px`,
    '--mateo-button-padding-inline': `${dimensions.inlinePaddingPx}px`,
    '--mateo-button-padding-block': `${dimensions.blockPaddingPx}px`,
    '--mateo-font-family': mateoTypography.fontFamily,
    '--mateo-letter-spacing': mateoTypography.letterSpacing,
  };
  return (
    <MateoSurface
      as="span"
      shape="capsule"
      width="fill"
      color="var(--mateo-button-background)"
    >
      <span
        style={style}
        className={[
          'mateo:box-border mateo:text-(--mateo-button-foreground) mateo:flex mateo:w-full mateo:min-w-[48px] mateo:min-h-(--mateo-button-height) mateo:items-center mateo:gap-[4px]',
          'mateo:px-(--mateo-button-padding-inline) mateo:py-(--mateo-button-padding-block)',
          'mateo:[font-family:var(--mateo-font-family)] mateo:text-(length:--mateo-button-font) mateo:leading-(--mateo-button-line) mateo:font-[500] mateo:[letter-spacing:var(--mateo-letter-spacing)]',
          alignment === 'start'
            ? 'mateo:justify-start'
            : alignment === 'end'
              ? 'mateo:justify-end'
              : 'mateo:justify-center',
        ].join(' ')}
      >
        <MateoIconProvider size={dimensions.iconPx} color={foreground}>
          {leadingIcon != null && (
            <span
              aria-hidden="true"
              className="mateo:inline-flex mateo:shrink-0 mateo:items-center"
            >
              {leadingIcon}
            </span>
          )}
          <span className="mateo:min-w-[0px] mateo:truncate">{label}</span>
          {trailingIcon != null && (
            <span
              aria-hidden="true"
              className="mateo:inline-flex mateo:shrink-0 mateo:items-center"
            >
              {trailingIcon}
            </span>
          )}
        </MateoIconProvider>
      </span>
    </MateoSurface>
  );
}
