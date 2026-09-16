part of '../../mateo_select.dart';

final class _MateoNeutralSelectMenuPlacement {
  const _MateoNeutralSelectMenuPlacement({
    required this.left,
    required this.right,
    required this.top,
    required this.maxWidth,
    required this.maxHeight,
  });

  factory _MateoNeutralSelectMenuPlacement.resolve({
    required Size overlaySize,
    required Rect sourceRect,
    required MediaQueryData mediaQuery,
    required double horizontalSafeAreaGutter,
  }) {
    final safeTop = (mediaQuery.padding.top + mediaQuery.viewInsets.top).clamp(0.0, overlaySize.height);
    final safeBottom = (overlaySize.height - mediaQuery.padding.bottom - mediaQuery.viewInsets.bottom).clamp(
      safeTop,
      overlaySize.height,
    );
    final usableHeight = math.max<double>(0, safeBottom - safeTop);
    final safeLeft = (mediaQuery.padding.left + mediaQuery.viewInsets.left).clamp(0.0, overlaySize.width);
    final safeRight = (mediaQuery.padding.right + mediaQuery.viewInsets.right).clamp(
      0.0,
      overlaySize.width - safeLeft,
    );
    final usableWidth = math.max<double>(0, overlaySize.width - safeLeft - safeRight);
    final resolvedGutter = math.min<double>(horizontalSafeAreaGutter, usableWidth / 2);
    final anchoredTop = sourceRect.top.clamp(safeTop, safeBottom);
    final availableHeight = math.max<double>(0, safeBottom - anchoredTop);

    return _MateoNeutralSelectMenuPlacement(
      left: safeLeft + resolvedGutter,
      right: safeRight + resolvedGutter,
      top: anchoredTop,
      maxWidth: math.max<double>(0, usableWidth - (resolvedGutter * 2)),
      maxHeight: math.min<double>(
        usableHeight * _MateoNeutralSelectPresentation._menuHeightFraction,
        availableHeight,
      ),
    );
  }

  final double left;
  final double right;
  final double top;
  final double maxWidth;
  final double maxHeight;
}
