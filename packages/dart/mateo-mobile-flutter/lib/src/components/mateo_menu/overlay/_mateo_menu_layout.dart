part of 'show_mateo_menu.dart';

class _MateoMenuLayout extends SingleChildLayoutDelegate {
  const _MateoMenuLayout({
    required this.anchorBounds,
    required this.padding,
    required this.placement,
  });

  final Rect anchorBounds;
  final EdgeInsets padding;
  final MateoMenuPlacement placement;

  Rect _availableBounds(Size size) => Rect.fromLTWH(
    padding.left,
    padding.top,
    math.max(0, size.width - padding.horizontal),
    math.max(0, size.height - padding.vertical),
  );

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints(maxWidth: _availableBounds(constraints.biggest).width);
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) => placement(anchorBounds, childSize, _availableBounds(size));

  @override
  bool shouldRelayout(_MateoMenuLayout oldDelegate) {
    return anchorBounds != oldDelegate.anchorBounds ||
        padding != oldDelegate.padding ||
        placement != oldDelegate.placement;
  }
}
