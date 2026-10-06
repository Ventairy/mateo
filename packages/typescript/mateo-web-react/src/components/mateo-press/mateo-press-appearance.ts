import type { CSSProperties } from 'react';

export const mateoPressDurations = {
  compressionMs: 140,
  releaseMs: 180,
} as const;

export const mateoPressDurationStyle: CSSProperties &
  Record<
    '--mateo-press-compression-duration' | '--mateo-press-release-duration',
    `${number}ms`
  > = {
  '--mateo-press-compression-duration': `${mateoPressDurations.compressionMs}ms`,
  '--mateo-press-release-duration': `${mateoPressDurations.releaseMs}ms`,
};

/**
 * MateoPress's bounded, non-oscillating spring profile, sampled every 1/64.
 * With t in [0,1], r(t) = (1 + 2πt) exp(-2πt) is critical damping.
 * Its response is already 82% complete halfway through the phase.
 * Over the second half, remove its remaining tail with the C3 smootherstep
 * S(s) = 35s⁴ - 84s⁵ + 70s⁶ - 20s⁷, s = max(0, 2t - 1).
 * Sample 1 - r(t)(1 - S(s)), rounded to seven decimal places.
 * The underlying curve lands with zero velocity, acceleration, and jerk;
 * CSS linear() closely approximates it without a per-frame JavaScript loop.
 * Scale and opacity share this profile in both directions.
 */
const mateoPressCurveClass =
  'mateo:[--mateo-press-curve:linear(0,0.004515,0.0169297,0.0357272,0.0596051,0.0874491,0.1183086,0.1513761,0.1859689,0.2215126,0.2575268,0.2936129,0.3294423,0.3647477,0.3993136,0.4329697,0.4655839,0.4970568,0.5273166,0.556315,0.5840233,0.6104292,0.635534,0.6593501,0.6818991,0.7032097,0.7233162,0.7422576,0.7600759,0.7768156,0.7925225,0.8072435,0.8210256,0.8339207,0.8460304,0.8575097,0.8685175,0.8791842,0.8895965,0.8997942,0.9097735,0.9194959,0.9288979,0.9379021,0.9464262,0.954392,0.9617318,0.9683932,0.974342,0.9795635,0.9840624,0.9878618,0.9910004,0.9935305,0.9955142,0.9970207,0.9981222,0.9988916,0.9993991,0.9997096,0.9998811,0.9999625,0.9999926,0.9999995,1)]';

export const mateoPressFeedbackClassName = [
  'mateo:min-w-[0px] mateo:[transition-duration:var(--mateo-press-release-duration)]',
  mateoPressCurveClass,
  'mateo:[transition-timing-function:var(--mateo-press-curve)]',
  'mateo:group-data-mateo-hovered/mateo-press:opacity-[0.80]',
  'mateo:motion-reduce:transition-none',
].join(' ');

export const mateoPressNoAnimationClassName =
  'mateo:[transition-property:opacity]';

export const mateoPressScaleClassName = [
  'mateo:origin-center mateo:[transition-property:transform,opacity]',
  'mateo:group-data-mateo-compressed/mateo-press:[transition-duration:var(--mateo-press-compression-duration)]',
  'mateo:group-data-mateo-compressed/mateo-press:opacity-[0.80]',
  'mateo:motion-safe:group-data-mateo-compressed/mateo-press:[transform:scale(0.977)]',
  'mateo:motion-reduce:transform-none mateo:motion-reduce:transition-none',
].join(' ');

/** Shared target styling, with native reset and focus treatment kept explicit. */
export const mateoPressTargetClassNames = {
  shared: [
    'mateo:group/mateo-press mateo:inline-grid mateo:box-border mateo:max-w-full',
    'mateo:[&:focus:not(:focus-visible)]:[outline:none]',
    'mateo:[&[data-mateo-pointer-focus]:focus]:[outline:none]',
  ].join(' '),
  link: 'mateo:[color:inherit] mateo:no-underline',
  native: [
    'mateo:[grid-template-columns:minmax(0,1fr)] mateo:align-middle mateo:appearance-none mateo:[border:0] mateo:p-[0px] mateo:bg-transparent mateo:[font:inherit] mateo:[text-align:inherit]',
    'mateo:focus-visible:outline-[2px] mateo:focus-visible:outline-offset-[2px] mateo:focus-visible:outline-solid mateo:focus-visible:outline-(--mateo-press-focus,Highlight)',
    'mateo:forced-colors:outline mateo:forced-colors:outline-[1px] mateo:forced-colors:outline-[ButtonText]',
  ].join(' '),
} as const;
