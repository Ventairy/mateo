part of 'mateo_icon_scope.dart';

class _ResolvedMateoIconScope extends InheritedWidget {
  const _ResolvedMateoIconScope({
    required this.size,
    required this.sizeWithBackground,
    required this.color,
    required super.child,
  });

  final double? size;
  final double? sizeWithBackground;
  final Color? color;

  @override
  bool updateShouldNotify(_ResolvedMateoIconScope oldWidget) =>
      size != oldWidget.size || sizeWithBackground != oldWidget.sizeWithBackground || color != oldWidget.color;
}
