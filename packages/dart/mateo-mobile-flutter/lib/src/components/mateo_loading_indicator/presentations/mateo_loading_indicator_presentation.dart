part of '../mateo_loading_indicator.dart';

/// The visual form mounted by a Mateo loading indicator.
@immutable
sealed class MateoLoadingIndicatorPresentation extends StatelessWidget {
  const new _();

  /// Creates circular activity with a finite, nonnegative [size] diameter.
  ///
  /// Supply [color] for the foreground of the containing surface or action.
  const factory circular({
    required Color color,
    double size,
  }) = _MateoCircularLoadingIndicatorPresentation;

  /// Creates three sequential dots with a finite, nonnegative [height].
  ///
  /// Supply [color] for the foreground of the containing surface or action.
  const factory dots({
    required Color color,
    double height,
  }) = _MateoDotsLoadingIndicatorPresentation;

  Duration get _duration;
}
