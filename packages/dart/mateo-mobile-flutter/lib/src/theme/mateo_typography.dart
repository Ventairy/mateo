/// The shared typeface and letter spacing for Mateo text.
///
/// Components own their sizes, weights, and line heights. These primitives
/// follow the [typography foundation](https://github.com/Ventairy/mateo/blob/main/design-system/foundation/typography.md).
abstract final class MateoTypography {
  /// The bundled Inter family, qualified for use by consuming packages.
  static const String fontFamily = 'packages/mateo_mobile/Inter';

  /// The shared letter spacing in logical pixels.
  static const double letterSpacing = -0.2;
}
