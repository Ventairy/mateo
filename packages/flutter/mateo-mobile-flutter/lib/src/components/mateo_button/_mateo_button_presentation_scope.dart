part of 'mateo_button.dart';

final class _MateoButtonPresentationScope extends InheritedWidget {
  const _MateoButtonPresentationScope({
    required this.owner,
    required this.revision,
    required super.child,
  });

  final _MateoButtonOwner owner;
  final int revision;

  static _MateoButtonOwner ownerOf(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_MateoButtonPresentationScope>();
    if (scope == null) throw FlutterError('Mateo button presentations must be mounted by MateoButton.');
    return scope.owner;
  }

  @override
  bool updateShouldNotify(_MateoButtonPresentationScope oldWidget) =>
      !identical(owner, oldWidget.owner) || revision != oldWidget.revision;
}
