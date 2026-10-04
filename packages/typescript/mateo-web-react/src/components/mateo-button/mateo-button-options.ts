/**
 * Semantic color treatment for a Mateo button.
 *
 * @remarks
 * `primary` uses the product accent; the success, warning, neutral, and base
 * primary options use their corresponding filled roles. `secondary` uses a soft
 * accent background, `secondary-neutral` uses a soft neutral background, and
 * `tertiary` uses a transparent neutral treatment.
 */
export type MateoButtonVariant =
  | 'primary'
  | 'primary-success'
  | 'primary-warning'
  | 'primary-neutral'
  | 'primary-base'
  | 'secondary'
  | 'secondary-neutral'
  | 'tertiary';
/**
 * Visible button size: `mini` is 32px, `small` is 40px, and `standard` is 48px high.
 *
 * @remarks
 * Label and icon proportions follow the chosen size. Label buttons use these
 * heights as a minimum; icon buttons use them as their square dimensions.
 */
export type MateoButtonSize = 'mini' | 'small' | 'standard';
/**
 * Label-button width: `fit` follows content; `fill` uses the available parent width.
 */
export type MateoButtonWidth = 'fit' | 'fill';
/**
 * Alignment of label-button content within its available width.
 *
 * @remarks
 * `start` and `end` follow the inherited writing direction; `center` centers the
 * label and its decorative icons as a group.
 */
export type MateoButtonAlignment = 'start' | 'center' | 'end';

/** Shared visible heights; each presentation owns its content proportions. */
export const mateoButtonHeights = {
  mini: 32,
  small: 40,
  standard: 48,
} as const;
