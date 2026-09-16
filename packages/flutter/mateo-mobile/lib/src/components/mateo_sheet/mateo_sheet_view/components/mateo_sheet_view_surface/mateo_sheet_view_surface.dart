part of '../../../show_mateo_sheet.dart';

/// A sheet surface with built-in spacing, shape, and presentation.
///
/// Supply this to [MateoSheetView.surface]. Edge effects adapt to the sheet's
/// header and footer when enabled.
class MateoSheetViewSurface extends StatelessWidget {
  /// Creates a sheet surface around [child].
  const MateoSheetViewSurface({
    required this.child,
    this.color,
    this.alignment,
    this.edgeEffect = const .none(),
    super.key,
  }) : _scrollable = false;

  /// Creates a sheet surface that owns vertical scrolling around [child].
  ///
  /// Short content fills the viewport; long content scrolls. The child must
  /// support intrinsic sizing, such as a Column rather than another viewport.
  const MateoSheetViewSurface.scrollable({
    required this.child,
    this.color,
    this.alignment,
    this.edgeEffect = const .none(),
    super.key,
  }) : _scrollable = true;

  /// The content inside the sheet.
  final Widget child;

  /// The background color, defaulting to the Mateo theme background.
  final Color? color;

  /// The content alignment within the surface, respecting its fixed slots.
  final AlignmentGeometry? alignment;

  /// The treatment applied at selected content edges.
  final MateoEdgeEffect edgeEffect;

  final bool _scrollable;

  @override
  Widget build(BuildContext context) {
    return BaseMateoViewSurface(
      scrollable: _scrollable,
      color: color,
      alignment: alignment,
      edgeEffect: edgeEffect,
      child: child,
    );
  }
}
