part of 'mateo_text.dart';

@internal
class MateoTextScope extends StatelessWidget {
  const MateoTextScope({
    required this.child,
    super.key,
    this.inherit = true,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.height,
    this.textAlign,
    this.textHeightBehavior,
  });

  final bool inherit;

  final Widget child;

  final double? fontSize;

  final FontWeight? fontWeight;

  final Color? color;

  final double? height;

  final TextAlign? textAlign;

  final TextHeightBehavior? textHeightBehavior;

  static ({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    TextAlign? textAlign,
    TextHeightBehavior? textHeightBehavior,
  })
  of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_ResolvedMateoTextScope>();
    return (
      fontSize: scope?.fontSize,
      fontWeight: scope?.fontWeight,
      color: scope?.color,
      height: scope?.height,
      textAlign: scope?.textAlign,
      textHeightBehavior: scope?.textHeightBehavior,
    );
  }

  @override
  Widget build(BuildContext context) {
    final parent = inherit ? of(context) : null;
    return _ResolvedMateoTextScope(
      fontSize: fontSize ?? parent?.fontSize,
      fontWeight: fontWeight ?? parent?.fontWeight,
      color: color ?? parent?.color,
      height: height ?? parent?.height,
      textAlign: textAlign ?? parent?.textAlign,
      textHeightBehavior: textHeightBehavior ?? parent?.textHeightBehavior,
      child: child,
    );
  }
}
