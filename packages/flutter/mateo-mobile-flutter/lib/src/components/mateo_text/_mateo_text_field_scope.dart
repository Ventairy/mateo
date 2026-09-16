part of 'mateo_text_field.dart';

class _MateoTextFieldScope extends InheritedWidget {
  const _MateoTextFieldScope({
    required this.owner,
    required this.revision,
    required super.child,
  });

  final _MateoTextFieldOwner owner;
  final int revision;

  static _MateoTextFieldOwner ownerOf(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_MateoTextFieldScope>();
    if (scope == null) throw FlutterError('Mateo text-field presentations must be mounted by MateoTextField.');
    return scope.owner;
  }

  @override
  bool updateShouldNotify(_MateoTextFieldScope oldWidget) =>
      !identical(owner, oldWidget.owner) || revision != oldWidget.revision;
}
