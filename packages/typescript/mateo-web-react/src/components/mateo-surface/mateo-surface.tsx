'use client';

import type {
  AriaAttributes,
  AriaRole,
  CSSProperties,
  ReactNode,
  Ref,
} from 'react';
import { useCallback, useId } from 'react';
import { getMateoRoundedPath } from '../../foundation/mateo-shape/mateo-rounded-path.js';
import {
  getMateoShapeRadius,
  type MateoShape,
} from '../../foundation/mateo-shape/mateo-shape.js';
import { useMateoSurfaceBounds } from '../../foundation/use-mateo-surface-bounds.js';
import { useMateoTheme } from '../../theme/mateo-theme-context.js';

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

function validateMateoSurfaceNumber(value: string | number, name: string) {
  if (typeof value === 'number' && (!Number.isFinite(value) || value < 0)) {
    throw new TypeError(`${name} must be finite and nonnegative.`);
  }
  return value;
}

function resolveMateoSurfaceDimension(value: MateoSurfaceSize, name: string) {
  if (value === 'fit') return 'fit-content';
  if (value === 'fill') return '100%';
  return validateMateoSurfaceNumber(value, name);
}

/** A noninteractive surface using the nearest Mateo theme's background. */
export function MateoSurface(props: MateoSurfaceProps) {
  const {
    children,
    width = 'fit',
    height = 'fit',
    color,
    shape = 'none',
    padding = 0,
    paddingBlock,
    paddingInline,
    as: elementKind,
    ref: _mateoSurfaceRef,
    id,
    title,
    dir,
    lang,
    role,
    ...attributes
  } = props;
  const Tag = elementKind === 'span' ? 'span' : 'div';
  const theme = useMateoTheme();
  const radius = getMateoShapeRadius(shape);
  const shaped = shape !== 'none';
  const forwardMateoSurfaceRef = useCallback(
    (node: HTMLElement | null) => {
      if (props.as === 'span') {
        if (node !== null && !(node instanceof HTMLSpanElement)) return;
        if (typeof props.ref === 'function') return props.ref(node);
        if (props.ref) props.ref.current = node;
      } else {
        if (node !== null && !(node instanceof HTMLDivElement)) return;
        if (typeof props.ref === 'function') return props.ref(node);
        if (props.ref) props.ref.current = node;
      }
    },
    [props.as, props.ref],
  );
  const bounds = useMateoSurfaceBounds<HTMLElement>(
    shaped,
    forwardMateoSurfaceRef,
  );
  const clipId = `mateo-shape-${useId()}`;
  // Only accessibility and data attributes cross the closed surface boundary.
  const accessibleAttributes = Object.fromEntries(
    Object.entries(attributes).filter(
      ([name]) => name.startsWith('aria-') || name.startsWith('data-'),
    ),
  );
  const style: CSSProperties = {
    ...(shaped ? { '--mateo-clip': `url(#${clipId})` } : {}),
    width: resolveMateoSurfaceDimension(width, 'width'),
    height: resolveMateoSurfaceDimension(height, 'height'),
    backgroundColor: color ?? theme.colorScheme.background,
    padding: validateMateoSurfaceNumber(padding, 'padding'),
    ...(paddingBlock === undefined
      ? {}
      : {
          paddingBlock: validateMateoSurfaceNumber(
            paddingBlock,
            'paddingBlock',
          ),
        }),
    ...(paddingInline === undefined
      ? {}
      : {
          paddingInline: validateMateoSurfaceNumber(
            paddingInline,
            'paddingInline',
          ),
        }),
  };
  return (
    <Tag
      {...accessibleAttributes}
      ref={bounds.ref}
      id={id}
      title={title}
      dir={dir}
      lang={lang}
      role={role}
      className={[
        'mateo:box-border mateo:block mateo:max-w-full mateo:max-h-full mateo:overflow-visible',
        shaped ? 'mateo:[clip-path:var(--mateo-clip)]' : '',
      ]
        .filter(Boolean)
        .join(' ')}
      style={style}
    >
      {children}
      {shaped && (
        <svg
          width="0"
          height="0"
          aria-hidden="true"
          focusable="false"
          className="mateo:absolute mateo:pointer-events-none"
        >
          <defs>
            <clipPath id={clipId} clipPathUnits="userSpaceOnUse">
              <path
                d={getMateoRoundedPath(bounds.width, bounds.height, radius)}
              />
            </clipPath>
          </defs>
        </svg>
      )}
    </Tag>
  );
}
