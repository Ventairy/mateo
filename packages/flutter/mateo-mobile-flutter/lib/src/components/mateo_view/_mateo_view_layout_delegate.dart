part of '../mateo_view.dart';

final class _MateoViewLayoutDelegate extends MultiChildLayoutDelegate {
  _MateoViewLayoutDelegate({
    required this.topSafeInset,
    required this.bottomSafeInset,
    required this.bottomInset,
    required this.keyboardViewportBehavior,
    required this.paddingOverride,
    required this.reserveLeadingExtent,
    required this.reserveTrailingExtent,
  });

  final double topSafeInset;
  final double bottomSafeInset;
  final double bottomInset;
  final MateoSurfaceKeyboardViewportBehavior keyboardViewportBehavior;
  final EdgeInsets? paddingOverride;
  final bool reserveLeadingExtent;
  final bool reserveTrailingExtent;

  @override
  void performLayout(Size size) {
    final slotConstraints = BoxConstraints(
      minWidth: size.width,
      maxWidth: size.width,
    );
    Size? headerSize;
    Size? footerSize;
    if (hasChild(_MateoViewLayoutId.header)) {
      headerSize = layoutChild(_MateoViewLayoutId.header, slotConstraints);
    }
    if (hasChild(_MateoViewLayoutId.footer)) {
      footerSize = layoutChild(_MateoViewLayoutId.footer, slotConstraints);
    }

    final bottomBoundary = math.max<double>(0, size.height - bottomInset);
    final extendsBehindKeyboard = keyboardViewportBehavior == MateoSurfaceKeyboardViewportBehavior.extendBehind;
    layoutChild(
      _MateoViewLayoutId.surface,
      MateoSurfaceLayoutConstraints(
        size: size,
        leadingExtent: topSafeInset + (headerSize?.height ?? 0),
        trailingExtent: bottomSafeInset + (footerSize?.height ?? 0) + (extendsBehindKeyboard ? bottomInset : 0),
        viewportExtent: extendsBehindKeyboard ? size.height : bottomBoundary,
        paddingOverride: paddingOverride,
        reserveLeadingExtent: reserveLeadingExtent,
        reserveTrailingExtent: reserveTrailingExtent,
      ),
    );
    positionChild(_MateoViewLayoutId.surface, Offset.zero);

    if (headerSize != null) {
      positionChild(_MateoViewLayoutId.header, Offset(0, topSafeInset));
    }
    if (footerSize != null) {
      positionChild(
        _MateoViewLayoutId.footer,
        Offset(0, bottomBoundary - bottomSafeInset - footerSize.height),
      );
    }
    if (hasChild(_MateoViewLayoutId.overlay)) {
      layoutChild(_MateoViewLayoutId.overlay, BoxConstraints.tight(size));
      positionChild(_MateoViewLayoutId.overlay, Offset.zero);
    }
  }

  @override
  bool shouldRelayout(_MateoViewLayoutDelegate oldDelegate) =>
      topSafeInset != oldDelegate.topSafeInset ||
      bottomSafeInset != oldDelegate.bottomSafeInset ||
      bottomInset != oldDelegate.bottomInset ||
      keyboardViewportBehavior != oldDelegate.keyboardViewportBehavior ||
      paddingOverride != oldDelegate.paddingOverride ||
      reserveLeadingExtent != oldDelegate.reserveLeadingExtent ||
      reserveTrailingExtent != oldDelegate.reserveTrailingExtent;
}
