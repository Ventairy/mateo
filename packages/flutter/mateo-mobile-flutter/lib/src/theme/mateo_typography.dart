/// Typography primitives shared by Mateo Mobile components.
///
/// Mateo does not define a global type scale. Each component owns its font
/// size, weight, and line height. Components combine those local decisions with
/// [fontFamily] and [letterSpacing].
abstract final class MateoTypography {
  /// The bundled Inter family used by Mateo Mobile.
  static const String fontFamily = 'packages/mateo_mobile/Inter';

  /// Fixed logical-pixel letter spacing applied to Mateo Mobile text.
  static const double letterSpacing = -0.2;
}
