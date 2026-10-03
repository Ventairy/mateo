/** A Mateo outline treatment shared by components that support shapes. */
export type MateoShape =
  | 'none'
  | 'capsule'
  | Readonly<{ type: 'rounded'; radius: number }>;

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
