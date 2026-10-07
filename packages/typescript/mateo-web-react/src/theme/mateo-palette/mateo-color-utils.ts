import {
  clampChroma,
  converter,
  formatHex,
  modeHsl,
  modeOklab,
  modeOklch,
  modeRgb,
  parse,
  useMode as registerMateoColorSpace,
} from 'culori/fn';

function _createMateoColorConverters() {
  // Color conversion is needed only by theme factories. Keep registration off
  // the module path used by consumers of precomputed themes and geometry.
  registerMateoColorSpace(modeRgb);
  registerMateoColorSpace(modeHsl);
  registerMateoColorSpace(modeOklab);
  registerMateoColorSpace(modeOklch);
  return { rgb: converter('rgb'), oklch: converter('oklch') };
}

let mateoColorConverters:
  | ReturnType<typeof _createMateoColorConverters>
  | undefined;

function _getMateoColorConverters() {
  mateoColorConverters ??= _createMateoColorConverters();
  return mateoColorConverters;
}

/** @internal Parse concrete colors without consulting browser state. */
export function parseMateoColor(value: string, name: string) {
  const _rejectMateoColor = () => {
    throw new TypeError(
      `${name} must be a finite hex, RGB, HSL, or OKLCH color.`,
    );
  };
  if (typeof value !== 'string') return _rejectMateoColor();
  const input = value.trim();
  if (!/^(#|rgba?\(|hsla?\(|oklch\()/i.test(input)) return _rejectMateoColor();
  // Missing/relative channels cannot serve as a deterministic palette seed.
  if (/\b(none|from|var|calc)\b/i.test(input)) return _rejectMateoColor();
  const converters = _getMateoColorConverters();
  const parsed = parse(input.toLowerCase());
  if (!parsed) return _rejectMateoColor();
  const rgb = converters.rgb(parsed);
  if (!rgb || ![rgb.r, rgb.g, rgb.b, rgb.alpha ?? 1].every(Number.isFinite))
    return _rejectMateoColor();
  return { input, rgb };
}

/** @internal Resolve an opaque sRGB seed and its perceptual coordinates. */
export function parseMateoAccent(value: string) {
  const { input, rgb } = parseMateoColor(value, 'accentColor');
  if ((rgb.alpha ?? 1) !== 1) {
    throw new TypeError('accentColor must be fully opaque.');
  }
  // Allow conversion round-off at gamut boundaries, not wide-gamut seeds.
  if ([rgb.r, rgb.g, rgb.b].some((v) => v < -1e-7 || v > 1 + 1e-7)) {
    throw new TypeError('accentColor must be within the sRGB gamut.');
  }
  return { input, oklch: _getMateoColorConverters().oklch(rgb) };
}

/** @internal Reduce chroma before serializing; never simply clip a shade. */
export function getMateoShadeHex(l: number, c: number, h: number): string {
  _getMateoColorConverters();
  return formatHex(
    clampChroma({ mode: 'oklch', l, c, h }, 'oklch', 'rgb'),
  ).toUpperCase();
}
