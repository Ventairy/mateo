part of '../mateo_loading_indicator.dart';

final class _MateoDotsLoadingIndicatorPresentation extends MateoLoadingIndicatorPresentation {
  const _MateoDotsLoadingIndicatorPresentation({required this.color, this.height = 20})
    : assert(height >= 0 && height < double.infinity, 'height must be finite and nonnegative.'),
      super._();

  final double height;
  final Color color;

  static const int _dotCount = 3;
  static const double _jumpHeightInRadii = 1.9;
  static const double _dotSpacingInRadii = 1.35;

  double get _dotRadius => height / (2 + _jumpHeightInRadii);
  double get _jumpHeight => _dotRadius * _jumpHeightInRadii;
  double get _dotSpacing => _dotRadius * _dotSpacingInRadii;
  double get _width => _dotCount * _dotRadius * 2 + (_dotCount - 1) * _dotSpacing;

  @override
  Duration get _duration => const Duration(milliseconds: 1000);

  @override
  Widget build(BuildContext context) {
    final scope = _MateoLoadingIndicatorScope.of(context);
    return Semantics(
      role: .loadingSpinner,
      label: scope.semanticLabel,
      child: Center(
        widthFactor: 1,
        heightFactor: 1,
        child: FittedBox(
          fit: .scaleDown,
          child: SizedBox(
            width: _width,
            height: height,
            child: RepaintBoundary(
              child: CustomPaint(
                painter: _MateoDotsLoadingIndicatorPainter(
                  color: color,
                  dotCount: _dotCount,
                  dotRadius: _dotRadius,
                  jumpHeight: _jumpHeight,
                  spacing: _dotSpacing,
                  progress: scope.progress,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
