import { getMateoShapeRadius, type MateoShape } from './mateo-shape.js';

/** A rounded shape and its local bounds at one end of a transition. */
export interface MateoRoundedShapeEndpoint {
  /** Positive, finite local width in CSS pixels. */
  readonly width: number;
  /** Positive, finite local height in CSS pixels. */
  readonly height: number;
  /** Outline whose radius is fitted to this endpoint's bounds before blending. */
  readonly shape: MateoShape;
}

/** Interpolated local bounds and their fitted Mateo outline. */
export interface MateoRoundedShapeFrame {
  /** Positive, finite local width in CSS pixels. */
  readonly width: number;
  /** Positive, finite local height in CSS pixels. */
  readonly height: number;
  /** Rounded outline with a nonnegative radius fitted to this frame's bounds. */
  readonly shape: Readonly<{
    /** Selects Mateo's rounded outline, including rectangles at radius zero. */
    type: 'rounded';
    /** Effective corner radius in CSS pixels. */
    radius: number;
  }>;
}

/** Endpoints and caller-controlled progress for rounded shape interpolation. */
export interface MateoRoundedShapeLerpOptions {
  /** Source geometry; use the visible frame when redirecting a transition. */
  readonly begin: MateoRoundedShapeEndpoint;
  /** Destination geometry. */
  readonly end: MateoRoundedShapeEndpoint;
  /** Finite progress: zero selects the source and one selects the destination. */
  readonly progress: number;
}

function _resolveMateoRoundedShapeEndpoint(
  endpoint: MateoRoundedShapeEndpoint,
): MateoRoundedShapeFrame {
  const requested = getMateoShapeRadius(endpoint.shape);
  const { width, height } = endpoint;
  if (
    !Number.isFinite(width) ||
    !Number.isFinite(height) ||
    width <= 0 ||
    height <= 0
  ) {
    throw new TypeError('Endpoint dimensions must be positive and finite.');
  }
  const limit = Math.min(width, height) / 2;
  return {
    width,
    height,
    shape: { type: 'rounded', radius: Math.min(requested ?? limit, limit) },
  };
}

/**
 * Blends two rounded shapes' local dimensions and visible corner radii.
 *
 * @remarks
 * Each endpoint's radius is fitted to its own bounds before interpolation.
 * `capsule` resolves to half its shorter dimension; `none` resolves to zero.
 * Progress outside 0–1 extrapolates directly, fitting only the resulting radius.
 * Zero and one return the exact resolved endpoints. Equal resolved endpoints
 * remain stationary. Inputs are not mutated and values retain full precision.
 *
 * Pass the returned width, height, and shape to a surface. To redirect a
 * transition continuously, use its visible frame as the new `begin`.
 * Timing, position, velocity handoff, and reduced motion belong to the caller.
 *
 * See the [interpolation foundation](https://github.com/Ventairy/mateo/blob/main/design-system/foundation/rounded-shape-interpolation.md).
 *
 * @param options - Endpoint geometry and finite animation progress.
 * @returns Local dimensions and a fitted rounded shape for this frame.
 * @throws TypeError - If progress, endpoint geometry, or the computed frame is
 * invalid or cannot be represented with positive finite dimensions.
 *
 * @example
 * ```tsx
 * const frame = lerpMateoRoundedShape({
 *   begin: { width: 200, height: 56, shape: 'capsule' },
 *   end: { width: 320, height: 180, shape: { type: 'rounded', radius: 24 } },
 *   progress,
 * });
 * <MateoSurface {...frame}>Content</MateoSurface>
 * ```
 */
export function lerpMateoRoundedShape({
  begin,
  end,
  progress,
}: MateoRoundedShapeLerpOptions): MateoRoundedShapeFrame {
  if (!Number.isFinite(progress)) {
    throw new TypeError('Progress must be finite.');
  }
  const source = _resolveMateoRoundedShapeEndpoint(begin);
  const destination = _resolveMateoRoundedShapeEndpoint(end);
  if (
    progress === 0 ||
    (source.width === destination.width &&
      source.height === destination.height &&
      source.shape.radius === destination.shape.radius)
  ) {
    return source;
  }
  if (progress === 1) return destination;

  const width = source.width + (destination.width - source.width) * progress;
  const height =
    source.height + (destination.height - source.height) * progress;
  const radius =
    source.shape.radius +
    (destination.shape.radius - source.shape.radius) * progress;
  if (
    !Number.isFinite(width) ||
    !Number.isFinite(height) ||
    width <= 0 ||
    height <= 0 ||
    !Number.isFinite(radius)
  ) {
    throw new TypeError(
      'Progress produces an invalid or unrepresentable frame.',
    );
  }
  return {
    width,
    height,
    shape: {
      type: 'rounded',
      radius: Math.min(Math.max(0, radius), Math.min(width, height) / 2),
    },
  };
}
