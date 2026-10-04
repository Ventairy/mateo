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

/**
 * Supported surface dimension: content fit, parent fill, pixels, or CSS sizing.
 *
 * @remarks
 * `fit` uses `fit-content`; `fill` uses `100%` and needs a parent with a resolved
 * dimension. Numbers are pixels and must be finite and nonnegative. CSS lengths,
 * percentages, custom-property references, and supported calculations are resolved
 * by the browser; the type does not validate expression contents.
 */
export type MateoSurfaceSize =
  | 'fit'
  | 'fill'
  | number
  | '0'
  | `${number}${MateoCssSizeUnit}`
  | `var(--${string})`
  | `${'calc' | 'min' | 'max' | 'clamp' | 'env'}(${string})`;
/**
 * Surface inset expressed as numeric pixels or a CSS padding value.
 *
 * @remarks
 * CSS shorthand and expressions follow browser padding rules. Logical axis
 * overrides are available through `paddingBlock` and `paddingInline`.
 */
export type MateoSurfacePadding = NonNullable<CSSProperties['padding']>;

/** A background with content, size, and logical padding. */
interface MateoSurfaceContentProps extends AriaAttributes {
  /**
   * Content drawn over the background and clipped to the same outline.
   */
  readonly children: ReactNode;
  /**
   * Requested surface width.
   *
   * @defaultValue `"fit"`
   */
  readonly width?: MateoSurfaceSize;
  /**
   * Requested surface height.
   *
   * @defaultValue `"fit"`
   */
  readonly height?: MateoSurfaceSize;
  /** Outline shared by the background and content clip. Defaults to none. */
  readonly shape?: MateoShape;
  /**
   * Background color; CSS variables are supported.
   *
   * @defaultValue The nearest theme's background color.
   */
  readonly color?: CSSProperties['backgroundColor'];
  /**
   * Inset on all sides, before logical axis overrides.
   *
   * @defaultValue `0`
   */
  readonly padding?: MateoSurfacePadding;
  /**
   * Override for both block-axis insets, following writing mode.
   */
  readonly paddingBlock?: MateoSurfacePadding;
  /**
   * Override for both inline-axis insets, following writing mode.
   */
  readonly paddingInline?: MateoSurfacePadding;
  /**
   * DOM identifier on the surface element.
   */
  readonly id?: string;
  /**
   * Native advisory text. Supply essential descriptions through visible text or ARIA.
   */
  readonly title?: string;
  /**
   * Native text direction; omission inherits from the surrounding document.
   */
  readonly dir?: 'ltr' | 'rtl' | 'auto';
  /**
   * Language of the content; omission inherits from the surrounding document.
   */
  readonly lang?: string;
  /**
   * Semantic role for the content. Does not add interactive behavior.
   */
  readonly role?: AriaRole;
  /**
   * Consumer data attributes forwarded to the surface element.
   */
  readonly [attribute: `data-${string}`]: string | number | boolean | undefined;
}

/**
 * Surface content, sizing, and semantics with an element-specific ref.
 *
 * @remarks
 * Defaults to a `div`. Use `as: "span"` for phrasing content inside native controls;
 * ensure descendants are valid for the chosen element. This surface does not own
 * actions or scrolling; use MateoPress or MateoViewSurface for those behaviors.
 */
export type MateoSurfaceProps = MateoSurfaceContentProps &
  (
    | {
        /** Layout container for flow content. Defaults to div. */
        readonly as?: 'div';
        /** Ref to the rendered surface div. */
        readonly ref?: Ref<HTMLDivElement>;
      }
    | {
        /** Phrasing container for use within native controls. */
        readonly as: 'span';
        /** Ref to the rendered surface span. */
        readonly ref?: Ref<HTMLSpanElement>;
      }
  );

/**
 * Renders a noninteractive background and content within one Mateo outline.
 *
 * @remarks
 * Requires a MateoTheme ancestor, including when a custom color is supplied.
 * Defaults to content-sized dimensions, no rounding, and no padding. The surface
 * does not add scrolling or action semantics.
 *
 * @throws TypeError - If a numeric dimension or rounded radius is invalid.
 * @throws Error - If there is no MateoTheme ancestor.
 *
 * @example
 * ```tsx
 * <MateoSurface shape={{ type: "rounded", radius: 24 }} padding={20}>
 *   Content
 * </MateoSurface>
 * ```
 */
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
