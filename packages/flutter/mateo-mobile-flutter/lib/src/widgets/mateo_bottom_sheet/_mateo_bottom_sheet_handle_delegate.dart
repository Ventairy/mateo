part of 'mateo_bottom_sheet.dart';

class _MateoBottomSheetHandleDelegate extends SliverPersistentHeaderDelegate {
  _MateoBottomSheetHandleDelegate({
    required this.backgroundColor,
    required this.handleColor,
  }) : _child = ColoredBox(
         color: backgroundColor,
         child: _MateoBottomSheetHandle(color: handleColor),
       );

  final Color backgroundColor;
  final Color handleColor;
  final Widget _child;

  @override
  double get minExtent => 32;

  @override
  double get maxExtent => 32;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return _child;
  }

  @override
  bool shouldRebuild(_MateoBottomSheetHandleDelegate oldDelegate) {
    return backgroundColor != oldDelegate.backgroundColor ||
        handleColor != oldDelegate.handleColor;
  }
}
