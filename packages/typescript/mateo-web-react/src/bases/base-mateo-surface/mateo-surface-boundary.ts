/** Canonical sampled curve from design-system/foundation/boundaries.md. */
const mateoBoundaryStops = Array.from({ length: 33 }, (_, index) => {
  const progress = index / 32;
  const q = progress ** 3 * (10 + progress * (-15 + 6 * progress));
  return {
    progress,
    visibility: q * (0.12 + 0.88 * q) - 0.4 * q * (1 - q) * (q - 0.5) ** 2,
  };
});

/** Header protection grows from its resting content edge while scrolling. */
const mateoBoundaryGeometry = {
  minimumDepthPx: 64,
  maximumDepthPx: 96,
  extentDivisor: 9,
  opposingExtentDivisor: 3,
  headerFraction: 0.55,
} as const;

export function getMateoBoundaryDepth(
  height: number,
  before: number,
  header: number,
  gap: number,
) {
  const depth = Math.min(
    Math.max(
      height / mateoBoundaryGeometry.extentDivisor,
      mateoBoundaryGeometry.minimumDepthPx,
    ),
    mateoBoundaryGeometry.maximumDepthPx,
    height / mateoBoundaryGeometry.opposingExtentDivisor,
  );
  const restingTop = Math.min(height, header + gap);
  const completeTop = Math.min(
    height,
    Math.max(restingTop, header / mateoBoundaryGeometry.headerFraction, depth),
  );
  const expandable = completeTop - restingTop;
  const progress = expandable === 0 ? 0 : Math.min(1, before / expandable);
  const contextualTop = restingTop + expandable * progress * (2 - progress);
  const resolveMateoDepth = (distance: number) =>
    depth === 0 ? 0 : depth * (1 - (1 - Math.min(1, distance / depth)) ** 8);
  const top = header > 0 ? contextualTop : resolveMateoDepth(before);
  return {
    top,
    clearTop: header > 0 ? completeTop : depth,
  };
}

export function getMateoBoundaryMask(height: number, top: number) {
  if (height <= 0 || top === 0) return 'none';
  const stops = [
    ...mateoBoundaryStops.map(
      ({ progress, visibility }) =>
        `rgba(0,0,0,${visibility}) ${progress * top}px`,
    ),
    `#000 ${height}px`,
  ];
  return `linear-gradient(to bottom, ${stops.join(', ')})`;
}
