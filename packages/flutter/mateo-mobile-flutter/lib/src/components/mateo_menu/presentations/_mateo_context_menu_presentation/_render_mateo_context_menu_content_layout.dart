part of '../../mateo_menu_button.dart';

class _RenderMateoContextMenuContentLayout extends RenderFlex {
  _RenderMateoContextMenuContentLayout(TextDirection textDirection)
    : super(direction: Axis.vertical, mainAxisSize: MainAxisSize.min, textDirection: textDirection);

  BoxConstraints _contentConstraints = const BoxConstraints();

  @override
  CrossAxisAlignment get crossAxisAlignment =>
      _contentConstraints.hasTightWidth ? CrossAxisAlignment.stretch : CrossAxisAlignment.center;

  @override
  void performLayout() {
    _contentConstraints = constraints;
    super.performLayout();
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) =>
      _withConstraints(constraints, () => super.computeDryLayout(constraints));

  @override
  double? computeDryBaseline(BoxConstraints constraints, TextBaseline baseline) =>
      _withConstraints(constraints, () => super.computeDryBaseline(constraints, baseline));

  T _withConstraints<T>(BoxConstraints constraints, T Function() compute) {
    final previous = _contentConstraints;
    _contentConstraints = constraints;
    try {
      return compute();
    } finally {
      _contentConstraints = previous;
    }
  }
}
