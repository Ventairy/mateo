part of '../../mateo_menu.dart';

class _MateoMenuOptionsRow extends MultiChildRenderObjectWidget {
  const _MateoMenuOptionsRow({
    required this.hasSupporting,
    required this.singleLineHeight,
    required super.children,
  });

  final bool hasSupporting;
  final double singleLineHeight;

  @override
  _RenderMateoMenuOptionsRow createRenderObject(BuildContext context) => _RenderMateoMenuOptionsRow(
    hasSupporting: hasSupporting,
    singleLineHeight: singleLineHeight,
    textDirection: Directionality.of(context),
  );

  @override
  void updateRenderObject(BuildContext context, _RenderMateoMenuOptionsRow renderObject) {
    renderObject
      ..hasSupporting = hasSupporting
      ..singleLineHeight = singleLineHeight
      ..textDirection = Directionality.of(context);
  }
}
