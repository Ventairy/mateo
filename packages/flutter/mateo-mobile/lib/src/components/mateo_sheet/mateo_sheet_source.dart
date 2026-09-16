part of 'show_mateo_sheet.dart';

/// The edge from which a Mateo sheet enters.
enum MateoSheetSource {
  /// The bottom edge, with an upward entrance and downward exit.
  bottom(
    dismissDirection: .down,
    sheetAlignment: .bottomCenter,
    beginOffset: Offset(0, 1),
    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    maxExtentFraction: 0.9,
    stackCrossAxisInset: 16,
    stackEdgeGap: 12,
    duration: Duration(milliseconds: 360),
    reverseDuration: Duration(milliseconds: 300),
    curve: _MateoSheetLandingCurve(),
    reverseCurve: FlippedCurve(_MateoSheetLandingCurve()),
  );

  const MateoSheetSource({
    required this._dismissDirection,
    required this._sheetAlignment,
    required this._beginOffset,
    required this._margin,
    required this._maxExtentFraction,
    required this._stackCrossAxisInset,
    required this._stackEdgeGap,
    required this._duration,
    required this._reverseDuration,
    required this._curve,
    required this._reverseCurve,
  });

  final InteractiveSwipeDismissDirection _dismissDirection;
  final Alignment _sheetAlignment;
  final Offset _beginOffset;
  final Duration _duration;
  final Duration _reverseDuration;
  final Curve _curve;
  final Curve _reverseCurve;

  final EdgeInsets _margin;
  final double _maxExtentFraction;
  final double _stackCrossAxisInset;
  final double _stackEdgeGap;
}
