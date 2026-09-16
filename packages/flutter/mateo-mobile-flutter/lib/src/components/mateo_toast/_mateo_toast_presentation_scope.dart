part of 'mateo_toast.dart';

class _MateoToastPresentationScope extends InheritedWidget {
  const _MateoToastPresentationScope({
    required this.message,
    required super.child,
  });

  final String message;

  static String messageOf(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_MateoToastPresentationScope>();
    if (scope == null) throw FlutterError('Mateo toast presentations must be mounted by MateoToast.');
    return scope.message;
  }

  @override
  bool updateShouldNotify(_MateoToastPresentationScope oldWidget) => message != oldWidget.message;
}
