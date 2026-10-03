part of 'mateo_menu.dart';

class _MateoMenuPresentationScope extends InheritedWidget {
  const _MateoMenuPresentationScope({required super.child, this.onItemPressed});

  final FutureOr<void> Function(MateoMenuOptionsPresentationItem item)? onItemPressed;

  static _MateoMenuPresentationScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_MateoMenuPresentationScope>();

    if (scope == null) throw FlutterError('MateoMenuPresentation must be mounted by MateoMenu.');
    return scope;
  }

  @override
  bool updateShouldNotify(_MateoMenuPresentationScope oldWidget) => onItemPressed != oldWidget.onItemPressed;
}
