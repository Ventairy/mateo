part of '../../mateo_menu_button.dart';

final class _RenderMateoContextMenuLayout extends RenderShiftedBox {
  _RenderMateoContextMenuLayout(this.triggerBounds, this.mediaQuery, this.textDirection) : super(null);

  Rect triggerBounds;
  MediaQueryData mediaQuery;
  TextDirection textDirection;
  BoxConstraints? _measurementConstraints;
  Size _naturalSize = Size.zero;
  bool _needsMeasurement = true;

  @override
  void markNeedsLayout() {
    _needsMeasurement = true;
    super.markNeedsLayout();
  }

  void update({
    required Rect triggerBounds,
    required MediaQueryData mediaQuery,
    required TextDirection textDirection,
  }) {
    if (this.triggerBounds == triggerBounds && this.mediaQuery == mediaQuery && this.textDirection == textDirection) {
      return;
    }
    final contentChanged = this.textDirection != textDirection;
    this.triggerBounds = triggerBounds;
    this.mediaQuery = mediaQuery;
    this.textDirection = textDirection;
    if (contentChanged) {
      markNeedsLayout();
    } else {
      super.markNeedsLayout();
    }
  }

  @override
  void performLayout() {
    size = constraints.biggest;
    final left = (mediaQuery.padding.left + mediaQuery.viewInsets.left).clamp(0.0, size.width);
    final right = (size.width - mediaQuery.padding.right - mediaQuery.viewInsets.right).clamp(left, size.width);
    final top = (mediaQuery.padding.top + mediaQuery.viewInsets.top).clamp(0.0, size.height);
    final bottom = (size.height - mediaQuery.padding.bottom - mediaQuery.viewInsets.bottom).clamp(top, size.height);
    final gutter = math.min(_MateoContextMenuPresentation._viewportGutter, (right - left) / 2);
    final safeLeft = left + gutter;
    final safeRight = right - gutter;
    final safe = Rect.fromLTRB(safeLeft, top, safeRight, bottom);
    final measurementConstraints = BoxConstraints(maxWidth: safe.width);
    if (_needsMeasurement || _measurementConstraints != measurementConstraints) {
      child!.layout(measurementConstraints, parentUsesSize: true);
      _naturalSize = child!.size;
      _measurementConstraints = measurementConstraints;
      _needsMeasurement = false;
    }
    final menu = _naturalSize;
    final boundedSize = Size(menu.width, math.min(menu.height, safe.height));
    final centeredX = _clamp(triggerBounds.center.dx - menu.width / 2, safe.left, safe.right - menu.width);
    final centeredY = _clamp(triggerBounds.center.dy - menu.height / 2, safe.top, safe.bottom - menu.height);
    Rect bounds;
    Alignment pivot;
    final projectedX = menu.width == 0
        ? 0.0
        : ((triggerBounds.center.dx - centeredX) / menu.width * 2 - 1).clamp(-1.0, 1.0);
    final projectedY = menu.height == 0
        ? 0.0
        : ((triggerBounds.center.dy - centeredY) / menu.height * 2 - 1).clamp(-1.0, 1.0);
    if (menu.height <= safe.height &&
        triggerBounds.left - _MateoContextMenuPresentation._triggerGap - menu.width >= safe.left) {
      final x = triggerBounds.left - _MateoContextMenuPresentation._triggerGap - menu.width;
      bounds = Offset(x, centeredY) & boundedSize;
      pivot = Alignment(1, projectedY);
    } else if (menu.height <= safe.height &&
        triggerBounds.right + _MateoContextMenuPresentation._triggerGap + menu.width <= safe.right) {
      final x = triggerBounds.right + _MateoContextMenuPresentation._triggerGap;
      bounds = Offset(x, centeredY) & boundedSize;
      pivot = Alignment(-1, projectedY);
    } else if (menu.width <= safe.width &&
        triggerBounds.bottom + _MateoContextMenuPresentation._triggerGap + menu.height <= safe.bottom) {
      bounds = Offset(centeredX, triggerBounds.bottom + _MateoContextMenuPresentation._triggerGap) & boundedSize;
      pivot = Alignment(projectedX, -1);
    } else if (menu.width <= safe.width &&
        triggerBounds.top - _MateoContextMenuPresentation._triggerGap - menu.height >= safe.top) {
      bounds =
          Offset(centeredX, triggerBounds.top - _MateoContextMenuPresentation._triggerGap - menu.height) & boundedSize;
      pivot = Alignment(projectedX, 1);
    } else {
      bounds = Offset(centeredX, centeredY) & boundedSize;
      pivot = Alignment(projectedX, projectedY);
    }
    child!.layout(
      BoxConstraints(
        minWidth: bounds.width,
        maxWidth: bounds.width,
        maxHeight: bounds.height,
      ),
      parentUsesSize: true,
    );
    (child!.parentData! as BoxParentData).offset = bounds.topLeft;
    final renderChild = child!;
    if (renderChild is _RenderMateoContextMenuRevealTransition) {
      renderChild
        ..alignment = Alignment(pivot.x, pivot.y)
        ..sourceDiameter = triggerBounds.shortestSide;
    }
  }

  static double _clamp(double value, double min, double max) => value.clamp(min, math.max(min, max));
}
