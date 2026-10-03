import {
  clampChroma,
  converter,
  formatHex,
  modeHsl,
  modeOklab,
  modeOklch,
  modeRgb,
  parse,
  useMode as registerColorSpace,
} from 'culori/fn';

// Register only the spaces needed by the public input contract and OKLCH math.
registerColorSpace(modeRgb);
registerColorSpace(modeHsl);
registerColorSpace(modeOklab);
registerColorSpace(modeOklch);
const toRgb = converter('rgb');
const toOklch = converter('oklch');

/** @internal Parse concrete colors without consulting browser state. */
export function parseMateoColor(value: string, name: string) {
  const fail = () => {
    throw new TypeError(
      `${name} must be a finite hex, RGB, HSL, or OKLCH color.`,
    );
  };
  if (typeof value !== 'string') return fail();
  const input = value.trim();
  if (!/^(#|rgba?\(|hsla?\(|oklch\()/i.test(input)) return fail();
  // Missing/relative channels cannot serve as a deterministic palette seed.
  if (/\b(none|from|var|calc)\b/i.test(input)) return fail();
  const parsed = parse(input.toLowerCase());
  if (!parsed) return fail();
  const rgb = toRgb(parsed);
  if (!rgb || ![rgb.r, rgb.g, rgb.b, rgb.alpha ?? 1].every(Number.isFinite))
    return fail();
  return { input, rgb };
}

/** @internal Resolve an opaque sRGB seed and its perceptual coordinates. */
export function parseAccent(value: string) {
  const { input, rgb } = parseMateoColor(value, 'accentColor');
  if ((rgb.alpha ?? 1) !== 1) {
    throw new TypeError('accentColor must be fully opaque.');
  }
  // Allow conversion round-off at gamut boundaries, not wide-gamut seeds.
  if ([rgb.r, rgb.g, rgb.b].some((v) => v < -1e-7 || v > 1 + 1e-7)) {
    throw new TypeError('accentColor must be within the sRGB gamut.');
  }
  return { input, oklch: toOklch(rgb) };
}

/** @internal Reduce chroma before serializing; never simply clip a shade. */
export function shadeToHex(l: number, c: number, h: number): string {
  return formatHex(
    clampChroma({ mode: 'oklch', l, c, h }, 'oklch', 'rgb'),
  ).toUpperCase();
}
