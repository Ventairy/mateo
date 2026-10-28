part of 'mateo_button_appearance_scope.dart';

class _ResolvedMateoButtonAppearanceScope extends InheritedTheme {
  const _ResolvedMateoButtonAppearanceScope({
    required this.variant,
    required this.elevation,
    required this.size,
    required super.child,
  });

  final MateoButtonVariant? variant;
  final double? elevation;
  final MateoButtonSize? size;

  @override
  Widget wrap(BuildContext context, Widget child) => _ResolvedMateoButtonAppearanceScope(
    variant: variant,
    elevation: elevation,
    size: size,
    child: child,
  );

  @override
  bool updateShouldNotify(_ResolvedMateoButtonAppearanceScope oldWidget) =>
      variant != oldWidget.variant || elevation != oldWidget.elevation || size != oldWidget.size;
}
