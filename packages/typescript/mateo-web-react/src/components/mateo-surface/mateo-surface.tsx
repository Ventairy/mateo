'use client';

import type {
  AriaAttributes,
  AriaRole,
  CSSProperties,
  ReactNode,
  Ref,
} from 'react';
import { useMateoTheme } from '../../theme-context.js';

type CssSizeUnit =
  | '%'
  | 'px'
  | 'cm'
  | 'mm'
  | 'Q'
  | 'q'
  | 'in'
  | 'pc'
  | 'pt'
  | `${'' | 'r'}${'cap' | 'ch' | 'em' | 'ex' | 'ic' | 'lh'}`
  | `${'' | 's' | 'l' | 'd'}v${'w' | 'h' | 'i' | 'b' | 'min' | 'max'}`
  | `cq${'w' | 'h' | 'i' | 'b' | 'min' | 'max'}`;

/** Fit, fill, pixels, or a CSS length/percentage, variable, or size calculation. */
export type MateoSurfaceSize =
  | 'fit'
  | 'fill'
  | number
  | '0'
  | `${number}${CssSizeUnit}`
  | `var(--${string})`
  | `${'calc' | 'min' | 'max' | 'clamp' | 'env'}(${string})`;
/** Padding in pixels or a CSS length/shorthand. */
export type MateoSurfacePadding = NonNullable<CSSProperties['padding']>;

/** A background with content, size, and logical padding. */
export interface MateoSurfaceProps extends AriaAttributes {
  readonly children: ReactNode;
  readonly width?: MateoSurfaceSize;
  readonly height?: MateoSurfaceSize;
  readonly color?: CSSProperties['backgroundColor'];
  readonly padding?: MateoSurfacePadding;
  readonly paddingBlock?: MateoSurfacePadding;
  readonly paddingInline?: MateoSurfacePadding;
  readonly ref?: Ref<HTMLDivElement>;
  readonly id?: string;
  readonly title?: string;
  readonly dir?: 'ltr' | 'rtl' | 'auto';
  readonly lang?: string;
  readonly role?: AriaRole;
  readonly [attribute: `data-${string}`]: string | number | boolean | undefined;
}

function validateNumber(value: string | number, name: string) {
  if (typeof value === 'number' && (!Number.isFinite(value) || value < 0)) {
    throw new TypeError(`${name} must be finite and nonnegative.`);
  }
  return value;
}

function dimension(value: MateoSurfaceSize, name: string) {
  if (value === 'fit') return 'fit-content';
  if (value === 'fill') return '100%';
  return validateNumber(value, name);
}

/** A noninteractive surface using the nearest Mateo theme's background. */
export function MateoSurface({
  children,
  width = 'fit',
  height = 'fit',
  color,
  padding = 0,
  paddingBlock,
  paddingInline,
  ref,
  id,
  title,
  dir,
  lang,
  role,
  ...attributes
}: MateoSurfaceProps) {
  const theme = useMateoTheme();
  // Only accessibility and data attributes cross the closed surface boundary.
  const accessibleAttributes = Object.fromEntries(
    Object.entries(attributes).filter(
      ([name]) => name.startsWith('aria-') || name.startsWith('data-'),
    ),
  );
  const style: CSSProperties = {
    width: dimension(width, 'width'),
    height: dimension(height, 'height'),
    backgroundColor: color ?? theme.colorScheme.background,
    padding: validateNumber(padding, 'padding'),
    ...(paddingBlock === undefined
      ? {}
      : { paddingBlock: validateNumber(paddingBlock, 'paddingBlock') }),
    ...(paddingInline === undefined
      ? {}
      : { paddingInline: validateNumber(paddingInline, 'paddingInline') }),
  };
  return (
    <div
      {...accessibleAttributes}
      ref={ref}
      id={id}
      title={title}
      dir={dir}
      lang={lang}
      role={role}
      className="mateo:box-border mateo:block mateo:max-w-full mateo:max-h-full mateo:overflow-visible"
      style={style}
    >
      {children}
    </div>
  );
}
