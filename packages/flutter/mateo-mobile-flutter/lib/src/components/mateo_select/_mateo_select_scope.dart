part of 'mateo_select.dart';

class _MateoSelectScope extends InheritedWidget {
  const _MateoSelectScope({
    required this.owner,
    required this.revision,
    required super.child,
  });

  final _MateoSelectOwner owner;
  final int revision;

  static _MateoSelectOwner ownerOf(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_MateoSelectScope>();
    if (scope == null) throw FlutterError('Mateo select presentations must be mounted by MateoSelect.');
    return scope.owner;
  }

  @override
  bool updateShouldNotify(_MateoSelectScope oldWidget) =>
      !identical(owner, oldWidget.owner) || revision != oldWidget.revision;
}
