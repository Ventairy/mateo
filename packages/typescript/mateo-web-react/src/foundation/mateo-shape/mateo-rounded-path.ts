// Geometry source: design-system/foundation/rounded-shape.md.
// Binary64 coefficients and SVG arcs preserve the canonical circular bends.
const mateoCornerExtent = 1.5286649465560913;
const mateoShoulderAngle = 0.4188790204786391;
type MateoRoundedPoint = readonly [number, number];

function getMateoRoundedAxis(
  resolveMateoSurfaceDimension: number,
  radius: number,
) {
  const a = Math.min(
    mateoCornerExtent,
    resolveMateoSurfaceDimension / 2 / radius,
  );
  const angle = mateoShoulderAngle * ((a - 1) / (mateoCornerExtent - 1));
  const q = Math.tan(angle / 2);
  const square = q * q;
  return {
    a,
    angle,
    b: 1 - q / 4 + (3 * q * square) / 4,
    c: 1 - q,
    sine: (2 * q) / (1 + square),
    rise: (2 * square) / (1 + square),
  };
}

/** Local SVG outline, or an empty path for empty/unrepresentable bounds. */
export function getMateoRoundedPath(
  width: number,
  height: number,
  requested: number | null,
): string {
  if (requested !== null && (!Number.isFinite(requested) || requested < 0)) {
    throw new TypeError('radius must be finite and nonnegative.');
  }
  if (
    !Number.isFinite(width) ||
    !Number.isFinite(height) ||
    width <= 0 ||
    height <= 0
  )
    return '';
  const r = Math.min(
    requested ?? Math.min(width, height) / 2,
    width / 2,
    height / 2,
  );
  if (r === 0) return `M 0 0 L ${width} 0 L ${width} ${height} L 0 ${height} Z`;
  const x = getMateoRoundedAxis(width, r);
  const y = getMateoRoundedAxis(height, r);
  const top: readonly [
    MateoRoundedPoint,
    MateoRoundedPoint,
    MateoRoundedPoint,
    MateoRoundedPoint,
  ] = [
    [width - r * x.a, 0],
    [width - r * x.b, 0],
    [width - r * x.c, 0],
    [width - r + r * x.sine, r * x.rise],
  ];
  const right: readonly [
    MateoRoundedPoint,
    MateoRoundedPoint,
    MateoRoundedPoint,
    MateoRoundedPoint,
  ] = [
    [width - r * y.rise, r - r * y.sine],
    [width, r * y.c],
    [width, r * y.b],
    [width, r * y.a],
  ];
  const commands = [`M ${width} ${height / 2}`];
  // Reflect the top-right corner; reverse controls when traversal reverses.
  for (const [flipX, flipY, reverse] of [
    [false, true, true],
    [true, true, false],
    [true, false, true],
    [false, false, false],
  ]) {
    const formatMateoRoundedPoint = ([px, py]: MateoRoundedPoint) =>
      `${flipX ? width - px : px} ${flipY ? height - py : py}`;
    const first = reverse ? right : top;
    const last = reverse ? top : right;
    commands.push(`L ${formatMateoRoundedPoint(first[reverse ? 3 : 0])}`);
    const firstAngle = reverse ? y.angle : x.angle;
    const lastAngle = reverse ? x.angle : y.angle;
    if (firstAngle > 0) {
      commands.push(
        `C ${formatMateoRoundedPoint(first[reverse ? 2 : 1])} ${formatMateoRoundedPoint(first[reverse ? 1 : 2])} ${formatMateoRoundedPoint(first[reverse ? 0 : 3])}`,
      );
    }
    commands.push(
      `A ${r} ${r} 0 0 1 ${formatMateoRoundedPoint(last[reverse ? 3 : 0])}`,
    );
    if (lastAngle > 0) {
      commands.push(
        `C ${formatMateoRoundedPoint(last[reverse ? 2 : 1])} ${formatMateoRoundedPoint(last[reverse ? 1 : 2])} ${formatMateoRoundedPoint(last[reverse ? 0 : 3])}`,
      );
    }
  }
  commands.push('Z');
  return commands.join(' ');
}
