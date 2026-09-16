part of 'mateo_header.dart';

final class _MateoHeaderPresentationScope extends InheritedWidget {
  const _MateoHeaderPresentationScope({
    required this.scroll,
    required super.child,
  });

  final _MateoHeaderScrollObserver scroll;

  static _MateoHeaderScrollObserver scrollOf(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_MateoHeaderPresentationScope>();
    if (scope == null) throw FlutterError('Mateo header presentations must be mounted by MateoHeader.');
    return scope.scroll;
  }

  @override
  bool updateShouldNotify(_MateoHeaderPresentationScope oldWidget) => !identical(scroll, oldWidget.scroll);
}
