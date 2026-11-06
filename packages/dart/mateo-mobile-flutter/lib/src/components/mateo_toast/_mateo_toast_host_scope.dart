part of 'mateo_toast.dart';

class _MateoToastHostScope extends InheritedWidget {
  const new({required this.dismissOnPress, required super.child});

  final bool dismissOnPress;

  static bool maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_MateoToastHostScope>()?.dismissOnPress ?? false;

  @override
  bool updateShouldNotify(_MateoToastHostScope oldWidget) => dismissOnPress != oldWidget.dismissOnPress;
}
