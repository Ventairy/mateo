part of '../mateo_text.dart';

final class _MateoInterfaceTextPresentation extends MateoTextPresentation {
  const _MateoInterfaceTextPresentation({
    this.fontSize,
    this.fontWeight,
    this.color,
    this.height,
    this.leadingDistribution,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
  }) : assert(maxLines == null || maxLines > 0, 'maxLines must be positive.'),
       super._();

  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;
  final double? height;
  final TextLeadingDistribution? leadingDistribution;

  @override
  Widget build(BuildContext context) {
    final text = _MateoTextPresentationScope.of(context);
    final defaults = MateoTextScope.of(context);
    final resolvedFontSize = fontSize ?? defaults.fontSize ?? 14;
    final scaler = MediaQuery.maybeTextScalerOf(context) ?? TextScaler.noScaling;
    final style = TextStyle(
      inherit: false,
      fontFamily: MateoTypography.interfaceFontFamily,
      fontSize: resolvedFontSize,
      letterSpacing: scaler.scale(resolvedFontSize) * -0.02,
      fontWeight: fontWeight ?? defaults.fontWeight,
      color: color ?? defaults.color,
      height: height ?? defaults.height,
      leadingDistribution: leadingDistribution,
    );

    // Isolate Flutter's renderer from native text defaults outside Mateo.
    return DefaultTextStyle(
      style: const TextStyle(),
      child: Text(
        text.data,
        style: style,
        textAlign: textAlign ?? defaults.textAlign ?? .start,
        maxLines: maxLines,
        overflow: overflow,
        softWrap: softWrap,
        semanticsLabel: text.semanticsLabel,
        textHeightBehavior: defaults.textHeightBehavior,
      ),
    );
  }
}
