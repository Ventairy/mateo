part of '../mateo_text.dart';

final class _MateoDecorativeTextPresentation extends MateoTextPresentation {
  const _MateoDecorativeTextPresentation({
    required this.variant,
    this.fontSize,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
  }) : assert(maxLines == null || maxLines > 0, 'maxLines must be positive.'),
       super._();

  final MateoDecorativeTextVariant variant;
  final double? fontSize;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;

  @override
  Widget build(BuildContext context) {
    final text = _MateoTextPresentationScope.of(context);
    final defaults = MateoTextScope.of(context);
    final weight =
        defaults.fontWeight ??
        switch (variant) {
          .rounded => FontWeight.w600,
          .cursive => FontWeight.w400,
        };
    final style = TextStyle(
      inherit: false,
      fontFamily: switch (variant) {
        .rounded => MateoTypography.decorativeRoundedFontFamily,
        .cursive => MateoTypography.decorativeCursiveFontFamily,
      },
      fontWeight: weight,
      fontStyle: .normal,
      letterSpacing: 0,
      fontSize: fontSize ?? defaults.fontSize ?? 14,
      color: color ?? defaults.color,
      height: defaults.height,
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
