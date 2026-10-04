'use client';

import type {
  AriaAttributes,
  AriaRole,
  CSSProperties,
  ReactNode,
  Ref,
} from 'react';
import { BaseMateoSurface } from '../../bases/base-mateo-surface/base-mateo-surface.js';
import type { MateoShape } from '../../foundation/mateo-shape/mateo-shape.js';

type MateoCssSizeUnit =
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
  | `${number}${MateoCssSizeUnit}`
  | `var(--${string})`
  | `${'calc' | 'min' | 'max' | 'clamp' | 'env'}(${string})`;
/** Padding in pixels or a CSS length/shorthand. */
export type MateoSurfacePadding = NonNullable<CSSProperties['padding']>;

/** A background with content, size, and logical padding. */
interface MateoSurfaceContentProps extends AriaAttributes {
  readonly children: ReactNode;
  readonly width?: MateoSurfaceSize;
  readonly height?: MateoSurfaceSize;
  /** Outline shared by the background and content clip. Defaults to none. */
  readonly shape?: MateoShape;
  readonly color?: CSSProperties['backgroundColor'];
  readonly padding?: MateoSurfacePadding;
  readonly paddingBlock?: MateoSurfacePadding;
  readonly paddingInline?: MateoSurfacePadding;
  readonly id?: string;
  readonly title?: string;
  readonly dir?: 'ltr' | 'rtl' | 'auto';
  readonly lang?: string;
  readonly role?: AriaRole;
  readonly [attribute: `data-${string}`]: string | number | boolean | undefined;
}

/** Div by default; span permits phrasing content inside native controls. */
export type MateoSurfaceProps = MateoSurfaceContentProps &
  (
    | { readonly as?: 'div'; readonly ref?: Ref<HTMLDivElement> }
    | { readonly as: 'span'; readonly ref?: Ref<HTMLSpanElement> }
  );

/** A noninteractive surface using the nearest Mateo theme's background. */
export function MateoSurface(props: MateoSurfaceProps) {
  return (
    <BaseMateoSurface
      {...props}
      width={props.width ?? 'fit'}
      height={props.height ?? 'fit'}
      shape={props.shape ?? 'none'}
      padding={props.padding ?? 0}
      scroll={null}
      overlay={null}
    />
  );
}
