'use client';

import type { CSSProperties, ReactNode } from 'react';
import { useCallback, useId } from 'react';
import type {
  MateoSurfacePadding,
  MateoSurfaceProps,
  MateoSurfaceSize,
} from '../../components/mateo-surface/mateo-surface.js';
import { getMateoRoundedPath } from '../../foundation/mateo-shape/mateo-rounded-path.js';
import {
  getMateoShapeRadius,
  type MateoShape,
} from '../../foundation/mateo-shape/mateo-shape.js';
import { useMateoSurfaceBounds } from '../../foundation/use-mateo-surface-bounds.js';
import { useMateoTheme } from '../../theme/mateo-theme-context.js';
import {
  BaseMateoSurfaceScroll,
  type BaseMateoSurfaceScrollOptions,
} from './base-mateo-surface-scroll.js';

/** Shared renderer; public components own their contracts and defaults. */
type BaseMateoSurfaceProps = MateoSurfaceProps & {
  readonly width: MateoSurfaceSize;
  readonly height: MateoSurfaceSize;
  readonly padding: MateoSurfacePadding;
  readonly shape: MateoShape;
  readonly scroll?: BaseMateoSurfaceScrollOptions | null;
  readonly overlay?: ReactNode;
};

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
export function BaseMateoSurface(props: BaseMateoSurfaceProps) {
  const {
    children,
    scroll,
    overlay,
    width,
    height,
    color,
    shape,
    padding,
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
        scroll
          ? 'mateo:relative mateo:isolate mateo:min-w-[0px] mateo:min-h-[0px]'
          : '',
      ]
        .filter(Boolean)
        .join(' ')}
      style={style}
    >
      {overlay}
      {scroll ? (
        <BaseMateoSurfaceScroll
          options={scroll}
          surfaceColor={color ?? theme.colorScheme.background}
        >
          {children}
        </BaseMateoSurfaceScroll>
      ) : (
        children
      )}
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
