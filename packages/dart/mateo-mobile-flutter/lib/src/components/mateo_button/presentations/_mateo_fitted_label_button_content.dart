part of '../mateo_button.dart';

final class _MateoFittedLabelButtonContent extends MultiChildRenderObjectWidget {
  _MateoFittedLabelButtonContent({
    required this.progress,
    required this.alignment,
    required Widget content,
    required Widget loadingIndicator,
  }) : super(children: [content, loadingIndicator]);

  final Animation<double> progress;
  final Alignment alignment;

  @override
  _RenderMateoFittedLabelButtonContent createRenderObject(BuildContext context) =>
      _RenderMateoFittedLabelButtonContent(progress: progress, alignment: alignment);

  @override
  void updateRenderObject(BuildContext context, _RenderMateoFittedLabelButtonContent renderObject) {
    renderObject
      ..progress = progress
      ..alignment = alignment;
  }
}
