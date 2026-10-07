export const mateoDragResistanceMotion = {
  dampingDistancePx: 96,
  returnMs: 180,
} as const;

// Mateo Flutter's critically damped return, joined to a smooth finite landing.
export function getMateoDragResistanceReturn(progress: number) {
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
