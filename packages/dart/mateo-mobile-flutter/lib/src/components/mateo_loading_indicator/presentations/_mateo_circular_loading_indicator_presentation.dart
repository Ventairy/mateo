part of '../mateo_loading_indicator.dart';

final class _MateoCircularLoadingIndicatorPresentation extends MateoLoadingIndicatorPresentation {
  const _MateoCircularLoadingIndicatorPresentation({required this.color, this.size = 24})
    : assert(size >= 0 && size < double.infinity, 'size must be finite and nonnegative.'),
      super._();

  final double size;
  final Color color;

  @override
  Duration get _duration => const Duration(milliseconds: 800);

  @override
  Widget build(BuildContext context) {
    final scope = _MateoLoadingIndicatorScope.of(context);
    return Semantics(
      role: .loadingSpinner,
      label: scope.semanticLabel,
      child: Center(
        widthFactor: 1,
        heightFactor: 1,
        child: SizedBox(
          width: size,
          height: size,
          child: RepaintBoundary(
            child: CustomPaint(
              painter: _MateoCircularLoadingIndicatorPainter(
                color: color,
                trackColor: color.withValues(alpha: color.a * 0.27),
                progress: scope.progress,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
