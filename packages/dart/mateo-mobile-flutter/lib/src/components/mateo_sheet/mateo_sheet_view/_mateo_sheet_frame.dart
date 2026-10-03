part of '../show_mateo_sheet.dart';

class _MateoSheetFrame extends SingleChildRenderObjectWidget {
  const _MateoSheetFrame({
    required this.stackEntry,
    required this.color,
    required this.dimColor,
    required super.child,
  });

  final _MateoSheetStackEntry stackEntry;
  final Color color;
  final Color dimColor;

  @override
  _RenderMateoSheetFrame createRenderObject(BuildContext context) {
    return _RenderMateoSheetFrame(stackEntry: stackEntry, color: color, dimColor: dimColor);
  }

  @override
  void updateRenderObject(BuildContext context, _RenderMateoSheetFrame renderObject) => renderObject
    ..stackEntry = stackEntry
    ..color = color
    ..dimColor = dimColor;
}
