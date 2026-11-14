import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'mateo_surface_caret_client.dart';

@internal
class MateoSurfaceCaretScope extends InheritedWidget {
  const new({
    required this.onChanged,
    required this.onRemoved,
    required this.visibleRectIn,
    required this.geometryChanges,
    required super.child,
    super.key,
  });

  final ValueChanged<MateoSurfaceCaretClient> onChanged;
  final ValueChanged<MateoSurfaceCaretClient> onRemoved;
  final Rect? Function(RenderBox viewport, {bool settledPresentation}) visibleRectIn;
  final Listenable geometryChanges;

  static MateoSurfaceCaretScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<MateoSurfaceCaretScope>();

  @override
  bool updateShouldNotify(MateoSurfaceCaretScope oldWidget) =>
      onChanged != oldWidget.onChanged || onRemoved != oldWidget.onRemoved || visibleRectIn != oldWidget.visibleRectIn;
}
