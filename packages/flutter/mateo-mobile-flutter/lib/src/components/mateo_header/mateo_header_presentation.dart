part of 'mateo_header.dart';

/// The mounted visual presentation of a [MateoHeader].
@immutable
sealed class MateoHeaderPresentation extends StatefulWidget {
  const MateoHeaderPresentation._({super.key});

  /// Creates a header coordinated by a [MateoView].
  const factory MateoHeaderPresentation.view({
    required Widget title,
    Widget? leading,
    Widget? trailing,
    bool centerTitle,
    ScrollController? scrollController,
  }) = _MateoHeaderViewPresentation;

  /// Creates a header that owns its placement and top-edge fade.
  const factory MateoHeaderPresentation.standalone({
    required Widget title,
    Widget? leading,
    Widget? trailing,
    bool centerTitle,
    EdgeInsetsGeometry padding,
    ScrollController? scrollController,
  }) = _MateoHeaderStandalonePresentation;

  bool get _isView;
  ScrollController? get _scrollController;
}
