part of 'mateo_text.dart';

class _ResolvedMateoTextScope extends InheritedTheme {
  const _ResolvedMateoTextScope({
    required super.child,
    required this.fontSize,
    required this.fontWeight,
    required this.color,
    required this.height,
    required this.textAlign,
    required this.textHeightBehavior,
  });

  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final double? height;
  final TextAlign? textAlign;
  final TextHeightBehavior? textHeightBehavior;

  @override
  Widget wrap(BuildContext context, Widget child) => _ResolvedMateoTextScope(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
    height: height,
    textAlign: textAlign,
    textHeightBehavior: textHeightBehavior,
    child: child,
  );

  @override
  bool updateShouldNotify(_ResolvedMateoTextScope oldWidget) =>
      fontSize != oldWidget.fontSize ||
      fontWeight != oldWidget.fontWeight ||
      color != oldWidget.color ||
      height != oldWidget.height ||
      textAlign != oldWidget.textAlign ||
      textHeightBehavior != oldWidget.textHeightBehavior;
}
