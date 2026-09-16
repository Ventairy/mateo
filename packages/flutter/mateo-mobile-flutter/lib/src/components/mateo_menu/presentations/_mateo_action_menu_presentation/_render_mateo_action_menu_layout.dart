part of '../../mateo_menu_button.dart';

final class _RenderMateoActionMenuLayout extends RenderShiftedBox {
  _RenderMateoActionMenuLayout(this.triggerBounds, this.mediaQuery, this.textDirection) : super(null);

  Rect triggerBounds;
  MediaQueryData mediaQuery;
  TextDirection textDirection;
  Size _naturalSize = Size.zero;

  @override
  void performLayout() {
    size = constraints.biggest;
    final safe = _safeBounds(size, mediaQuery);
    final top = triggerBounds.top.clamp(safe.top, safe.bottom);
    final bottom = triggerBounds.bottom.clamp(safe.top, safe.bottom);
    final limits = BoxConstraints(maxWidth: safe.width);
    child!.layout(BoxConstraints(minWidth: limits.maxWidth, maxWidth: limits.maxWidth), parentUsesSize: true);
    _naturalSize = child!.size;
    final opensAbove = _naturalSize.height <= math.max(0.0, bottom - safe.top);
    final height = math.min(
      _naturalSize.height,
      opensAbove ? bottom - safe.top : safe.bottom - top,
    );
    final left = _clamp(
      textDirection == TextDirection.ltr ? triggerBounds.left : triggerBounds.right - _naturalSize.width,
      safe.left,
      safe.right - _naturalSize.width,
    );
    final bounds = Rect.fromLTWH(
      left,
      opensAbove ? bottom - height : top,
      _naturalSize.width,
      height,
    );
    if (child!.size != bounds.size) child!.layout(BoxConstraints.tight(bounds.size), parentUsesSize: true);
    (child!.parentData! as BoxParentData).offset = bounds.topLeft;
  }

  static Rect _safeBounds(Size viewport, MediaQueryData mediaQuery) {
    final left = mediaQuery.padding.left + mediaQuery.viewInsets.left + 12;
    final right = viewport.width - mediaQuery.padding.right - mediaQuery.viewInsets.right - 12;
    final top = mediaQuery.padding.top + mediaQuery.viewInsets.top;
    final bottom = viewport.height - mediaQuery.padding.bottom - mediaQuery.viewInsets.bottom;
    return Rect.fromLTRB(left, top, right, bottom);
  }

  static double _clamp(double value, double min, double max) => value.clamp(min, math.max(min, max));
}
