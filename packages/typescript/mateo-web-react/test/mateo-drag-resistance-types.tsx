import {
  MateoDragResistance,
  type MateoDragResistanceReturnAnimation,
} from '@mateo/web-react/react';

export function checkMateoDragResistanceReturnTypes() {
  const animation: MateoDragResistanceReturnAnimation = {
    durationMs: 260,
    curve: [0.22, 1, 0.36, 1],
  };
  const configured = (
    <MateoDragResistance returnAnimation={animation}>
      <g />
    </MateoDragResistance>
  );
  const durationOnly = (
    <MateoDragResistance returnAnimation={{ durationMs: 0 }}>
      <div />
    </MateoDragResistance>
  );
  const curveOnly = (
    <MateoDragResistance returnAnimation={{ curve: [0, 0, 1, 1] }}>
      <div />
    </MateoDragResistance>
  );
  const defaults = (
    <MateoDragResistance returnAnimation={{}}>
      <div />
    </MateoDragResistance>
  );
  const stringDuration: MateoDragResistanceReturnAnimation = {
    // @ts-expect-error Duration uses milliseconds as a number.
    durationMs: '260ms',
  };
  // @ts-expect-error Curves require exactly four coordinates.
  const shortCurve: MateoDragResistanceReturnAnimation = { curve: [0, 0, 1] };
  // @ts-expect-error Named curves are not supported.
  const namedCurve: MateoDragResistanceReturnAnimation = { curve: 'easeOut' };
  const functionCurve: MateoDragResistanceReturnAnimation = {
    // @ts-expect-error Function curves are not supported.
    curve: (progress: number) => progress,
  };
  // @ts-expect-error Timing settings are readonly.
  animation.durationMs = 300;
  // @ts-expect-error Curve coordinates are readonly.
  if (animation.curve) animation.curve[0] = 0;
  return {
    configured,
    durationOnly,
    curveOnly,
    defaults,
    stringDuration,
    shortCurve,
    namedCurve,
    functionCurve,
  };
}
