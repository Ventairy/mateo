export type MateoButtonVariant =
  | 'primary'
  | 'primary-success'
  | 'primary-warning'
  | 'primary-neutral'
  | 'primary-base'
  | 'secondary'
  | 'secondary-neutral'
  | 'tertiary';
export type MateoButtonSize = 'mini' | 'small' | 'standard';
export type MateoButtonWidth = 'fit' | 'fill';
export type MateoButtonAlignment = 'start' | 'center' | 'end';

/** Shared visible heights; each presentation owns its content proportions. */
export const mateoButtonHeights = {
  mini: 32,
  small: 40,
  standard: 48,
} as const;
