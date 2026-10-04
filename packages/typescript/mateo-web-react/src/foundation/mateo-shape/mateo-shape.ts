/**
 * Outline treatment shared by components that support Mateo shapes.
 *
 * @remarks
 * `none` leaves the surface rectangular. `capsule` derives full rounding from
 * the rendered bounds. `rounded` requests a radius in pixels; it must be finite
 * and nonnegative and is limited by the available bounds. The same outline
 * clips the background and content.
 *
 * @example
 * ```tsx
 * <MateoSurface shape={{ type: "rounded", radius: 24 }}>Content</MateoSurface>
 * ```
 */
export type MateoShape =
  | 'none'
  | 'capsule'
  | Readonly<{
      /** Selects Mateo's rounded outline. */
      type: 'rounded';
      /** Requested corner radius in pixels; finite and nonnegative. */
      radius: number;
    }>;

/** Resolve the requested radius; null means full rounding from the bounds. */
export function getMateoShapeRadius(shape: MateoShape): number | null {
  if (shape === 'none') return 0;
  if (shape === 'capsule') return null;
  if (
    typeof shape !== 'object' ||
    shape === null ||
    shape.type !== 'rounded' ||
    typeof shape.radius !== 'number' ||
    !Number.isFinite(shape.radius) ||
    shape.radius < 0
  ) {
    throw new TypeError(
      'shape must be none, capsule, or rounded with a finite, nonnegative radius.',
    );
  }
  return shape.radius;
}
