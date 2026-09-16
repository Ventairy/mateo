part of 'mateo_button.dart';

class _MateoButtonPresentationScope extends InheritedWidget {
  const _MateoButtonPresentationScope({
    required this.enabled,
    required this.interactive,
    required this.loading,
    required this.onPressed,
    required super.child,
  });

  final bool enabled;
  final bool interactive;
  final bool loading;
  final Future<void> Function() onPressed;

  static _MateoButtonPresentationScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_MateoButtonPresentationScope>();
    if (scope == null) throw FlutterError('A MateoButtonPresentation must be mounted by MateoButton.');
    return scope;
  }

  @override
  bool updateShouldNotify(_MateoButtonPresentationScope oldWidget) =>
      enabled != oldWidget.enabled ||
      interactive != oldWidget.interactive ||
      loading != oldWidget.loading ||
      onPressed != oldWidget.onPressed;
}
