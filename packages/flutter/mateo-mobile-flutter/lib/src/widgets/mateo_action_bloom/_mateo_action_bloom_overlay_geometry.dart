part of 'mateo_action_bloom.dart';

class _MateoActionBloomOverlayGeometry {
  const _MateoActionBloomOverlayGeometry({
    required this.opensAtTop,
    required this.panelTop,
    required this.panelBottom,
    required this.panelMaxHeight,
    required this.panelHorizontalInset,
    required this.sourceOffsetFromPanelAnchor,
  });

  factory _MateoActionBloomOverlayGeometry.resolve({
    required Size overlaySize,
    required Rect sourceRect,
    required MediaQueryData mediaQuery,
    required bool opensAtTop,
  }) {
    final safeTop = _safeTop(mediaQuery);
    final safeBottom = _safeBottom(
      overlayHeight: overlaySize.height,
      mediaQuery: mediaQuery,
    );
    final panelHorizontalInset = math.min<double>(
      12,
      math.max<double>(0, (overlaySize.width - sourceRect.width) / 2),
    );

    return _MateoActionBloomOverlayGeometry(
      opensAtTop: opensAtTop,
      panelTop: opensAtTop ? safeTop : null,
      panelBottom: opensAtTop ? null : overlaySize.height - safeBottom,
      panelMaxHeight: math.max<double>(0, safeBottom - safeTop) * 0.85,
      panelHorizontalInset: panelHorizontalInset,
      sourceOffsetFromPanelAnchor: Offset(
        sourceRect.right - (overlaySize.width - panelHorizontalInset),
        opensAtTop ? sourceRect.top - safeTop : sourceRect.bottom - safeBottom,
      ),
    );
  }

  final bool opensAtTop;
  final double? panelTop;
  final double? panelBottom;
  final double panelMaxHeight;
  final double panelHorizontalInset;
  final Offset sourceOffsetFromPanelAnchor;

  static bool shouldOpenAtTop({
    required double sourceCenterY,
    required double overlayHeight,
    required MediaQueryData mediaQuery,
  }) =>
      math.max<double>(0, sourceCenterY - _safeTop(mediaQuery)) <
      math.max<double>(
        0,
        _safeBottom(
              overlayHeight: overlayHeight,
              mediaQuery: mediaQuery,
            ) -
            sourceCenterY,
      );

  static double _safeTop(MediaQueryData mediaQuery) => mediaQuery.padding.top + mediaQuery.viewInsets.top;

  static double _safeBottom({
    required double overlayHeight,
    required MediaQueryData mediaQuery,
  }) => overlayHeight - mediaQuery.viewInsets.bottom - mediaQuery.padding.bottom;
}
