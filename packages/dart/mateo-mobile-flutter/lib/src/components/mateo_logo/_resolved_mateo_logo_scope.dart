part of 'mateo_logo_scope.dart';

class _ResolvedMateoLogoScope extends InheritedWidget {
  const new({required this.size, required super.child});

  final double? size;

  @override
  bool updateShouldNotify(_ResolvedMateoLogoScope oldWidget) => size != oldWidget.size;
}
