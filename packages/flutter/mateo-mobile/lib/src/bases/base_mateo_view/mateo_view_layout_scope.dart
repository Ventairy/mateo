part of 'base_mateo_view.dart';

@internal
class MateoViewLayoutScope extends InheritedWidget {
  const MateoViewLayoutScope._({
    required this.padding,
    required this.fitHeight,
    required this._layout,
    required super.child,
  });

  final _MateoViewLayoutData _layout;
  final EdgeInsets padding;
  final bool fitHeight;

  ({double height, double bottomOffset, Listenable changes})? get header {
    final header = _layout.header;
    if (header == null) return null;
    return (height: header.height, bottomOffset: header.bottomOffset, changes: header.changes);
  }

  ({double height, double topOffset, Listenable changes})? get footer {
    final footer = _layout.footer;
    if (footer == null) return null;
    return (height: footer.height, topOffset: footer.topOffset, changes: footer.changes);
  }

  double get headerToContentGap => _MateoViewLayoutData._headerToContentGap;

  EdgeInsets get obstructionInsets => _layout.obstructionInsets;
  Listenable get obstructionInsetsChanges => _layout.obstructionInsetsChanges;

  static MateoViewLayoutScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<MateoViewLayoutScope>();

  // The layout owner mutates slot presence within the same data instance.
  @override
  bool updateShouldNotify(MateoViewLayoutScope oldWidget) => true;
}
