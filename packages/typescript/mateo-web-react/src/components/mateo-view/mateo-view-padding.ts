/** Pixel spacing follows the inherited writing direction. */
export type MateoViewPadding =
  | number
  | Readonly<{
      blockStart?: number;
      blockEnd?: number;
      inlineStart?: number;
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
