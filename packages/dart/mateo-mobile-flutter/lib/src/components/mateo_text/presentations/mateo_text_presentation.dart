part of '../mateo_text.dart';

/// The typography and layout treatment mounted by [MateoText].
@immutable
sealed class MateoTextPresentation extends StatelessWidget {
  const MateoTextPresentation._();

  /// Ordinary interface text like button labels, body text etc.
  const factory MateoTextPresentation.interface({
    double? fontSize,
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
  const factory MateoTextPresentation.decorative({
    required MateoDecorativeTextVariant variant,
    double? fontSize,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    bool? softWrap,
  }) = _MateoDecorativeTextPresentation;
}
