part of 'mateo_header.dart';

/// The package-internal connection supplied to a view's header subtree.
///
/// The scope provides coordination only; the containing view owns layout,
/// safe areas, and fade painting. It is not exported by the public package API.
@internal
final class MateoHeaderScope extends InheritedWidget {
  /// Creates a scope supplying [connection] and [managedScrollController] to
  /// [child].
  const MateoHeaderScope({
    required this.connection,
    required this.managedScrollController,
    required super.child,
    super.key,
  });

  /// The connection through which the header drives the view's top fade.
  final MateoHeaderConnection connection;

  /// The view-owned controller, which takes precedence over the header's own.
  final ScrollController? managedScrollController;

  /// The default fixed-header inset owned by [MateoHeaderPresentation.view].
  ///
  /// The view applies this padding; the scope itself adds no layout widgets.
  static EdgeInsetsGeometry get contentPadding => _MateoHeaderViewPresentation._contentPadding;

  /// The nearest header scope above [context], or null outside a header slot.
  static MateoHeaderScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<MateoHeaderScope>();

  /// Whether the header must reconnect to its containing view.
  @override
  bool updateShouldNotify(MateoHeaderScope oldWidget) =>
      !identical(connection, oldWidget.connection) ||
      !identical(managedScrollController, oldWidget.managedScrollController);
}
