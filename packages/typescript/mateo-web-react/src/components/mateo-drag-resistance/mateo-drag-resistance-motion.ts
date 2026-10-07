import type { MateoDragResistanceReturnAnimation } from './mateo-drag-resistance.js';

export const mateoDragResistanceMotion = {
  dampingDistancePx: 96,
  returnMs: 180,
} as const;

// Mateo Flutter's critically damped return, joined to a smooth finite landing.
export function getMateoDragResistanceReturn(
  progress: number,
  curve?: MateoDragResistanceReturnAnimation['curve'],
) {
  if (progress <= 0) return 0;
  if (progress >= 1) return 1;
  if (curve) {
    const [x1, y1, x2, y2] = curve;
    let lower = 0;
    let upper = 1;
    // Invert the Bézier's time axis, including flat endpoint tangents.
    for (let step = 0; step < 32; step++) {
      const parameter = (lower + upper) / 2;
      if (_getMateoBezierCoordinate(parameter, x1, x2) < progress)
        lower = parameter;
      else upper = parameter;
    }
    return _getMateoBezierCoordinate((lower + upper) / 2, y1, y2);
  }
  if (progress <= 0.6) {
    const time = 7.906440863984298 * progress;
    return 1 - (1 + time) * Math.exp(-time);
  }
  const remaining = (1 - progress) / 0.4;
  return (
    1 -
    remaining ** 4 *
      (0.48000360240464635 +
        remaining *
          (-1.0106220969636555 +
            remaining * (0.8006346089695058 - remaining * 0.22001611441049676)))
  );
}

function _getMateoBezierCoordinate(
  parameter: number,
  first: number,
  second: number,
) {
  const remaining = 1 - parameter;
  return (
    3 * remaining ** 2 * parameter * first +
    3 * remaining * parameter ** 2 * second +
    parameter ** 3
  );
}
