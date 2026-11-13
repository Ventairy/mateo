part of '../mateo_text.dart';

/// The typography and layout treatment mounted by [MateoText].
@immutable
sealed class MateoTextPresentation extends StatelessWidget {
  const new _();

  /// Ordinary interface text like button labels, body text etc.
  const factory interface({
    MateoTextInterfaceFontSize? fontSize,
    FontWeight? fontWeight,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    bool? softWrap,
    double? height,
    TextLeadingDistribution? leadingDistribution,
  }) = _MateoInterfaceTextPresentation;

  /// A decorative typeface with contextual typography defaults.
  ///
  /// Use for short expressive phrases.
  const factory decorative({
    required MateoDecorativeTextVariant variant,
    double? fontSize,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    bool? softWrap,
  }) = _MateoDecorativeTextPresentation;
}
