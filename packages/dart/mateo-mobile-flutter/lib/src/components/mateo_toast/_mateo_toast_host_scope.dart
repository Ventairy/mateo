part of 'mateo_toast.dart';

class _MateoToastHostScope extends InheritedWidget {
  const _MateoToastHostScope({required this.dismissOnPress, required super.child});

  final bool dismissOnPress;

  static bool maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_MateoToastHostScope>()?.dismissOnPress ?? false;

  @override
  bool updateShouldNotify(_MateoToastHostScope oldWidget) => dismissOnPress != oldWidget.dismissOnPress;
}
