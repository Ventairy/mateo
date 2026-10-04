/**
 * Logical view insets in pixels, following inherited writing direction.
 *
 * @remarks
 * A number applies to all four edges. An object replaces inherited spacing;
 * unspecified edges become zero. Values must be finite and nonnegative.
 * `blockStart` and `blockEnd` follow the block axis; `inlineStart` and `inlineEnd`
 * follow reading order, so horizontal insets adapt to RTL.
 *
 * @example
 * ```ts
 * const padding: MateoViewPadding = { inlineStart: 24, inlineEnd: 24 };
 * ```
 */
export type MateoViewPadding =
  | number
  | Readonly<{
      /**
       * Inset at the start of the block axis. Omitted object edges resolve to zero.
       */
      blockStart?: number;
      /**
       * Inset at the end of the block axis. Omitted object edges resolve to zero.
       */
      blockEnd?: number;
      /**
       * Inset before content in reading order. Omitted object edges resolve to zero.
       */
      inlineStart?: number;
      /**
       * Inset after content in reading order. Omitted object edges resolve to zero.
       */
      inlineEnd?: number;
    }>;

export const mateoViewSpacing = {
  padding: { blockStart: 12, blockEnd: 12, inlineStart: 20, inlineEnd: 20 },
  contentGapPx: 20,
  headerSlotGapPx: 16,
} as const;

export function resolveMateoViewPadding(padding: MateoViewPadding) {
  const resolved =
    typeof padding === 'number'
      ? {
          blockStart: padding,
          blockEnd: padding,
          inlineStart: padding,
          inlineEnd: padding,
        }
      : {
          blockStart: padding.blockStart ?? 0,
          blockEnd: padding.blockEnd ?? 0,
          inlineStart: padding.inlineStart ?? 0,
          inlineEnd: padding.inlineEnd ?? 0,
        };
  for (const value of Object.values(resolved)) {
    if (!Number.isFinite(value) || value < 0) {
      throw new TypeError('Mateo view padding must be finite and nonnegative.');
    }
  }
  return resolved;
}
