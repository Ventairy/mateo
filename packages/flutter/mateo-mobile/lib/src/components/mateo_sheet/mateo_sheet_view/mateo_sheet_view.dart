part of '../show_mateo_sheet.dart';

/// A sheet's content and fixed header, footer, and overlay.
///
/// Supply this to [showMateoSheet].
///
/// ```dart
/// showMateoSheet<void>(
///   context: context,
///   view: const MateoSheetView(
///     header: MateoSheetViewHeader(principal: Text('Details')),
///     surface: MateoSheetViewSurface(child: Text('A place to unwind.')),
///   ),
/// );
/// ```
class MateoSheetView extends StatelessWidget {
  /// Creates a sheet with [surface] and optional fixed content.
  const MateoSheetView({
    required this.surface,
    this.header,
    this.footer,
    this.overlay,
    this.reserveHeaderSpace = true,
    super.key,
  });

  static const _shape = MateoRoundedShapeBorder(radius: 44);

  /// The sheet's content surface.
  final MateoSheetViewSurface surface;

  /// The optional fixed header.
  final MateoSheetViewHeader? header;

  /// The optional fixed footer.
  final MateoSheetViewFooter? footer;

  /// Full-view content painted above the surface and fixed slots.
  final Widget? overlay;

  /// Whether surface content reserves space for [header].
  ///
  /// When false, surface content uses the same top spacing it would have
  /// without a header. The header remains fixed, safe-area aware, and painted
  /// above the surface. Use this for content intended to begin beneath the
  /// header, such as imagery, maps, or decorative canvases.
  final bool reserveHeaderSpace;

  @override
  Widget build(BuildContext context) {
    final stackEntry = _MateoSheetStackScope.stackEntryOf(context);

    final content = MateoViewScope(
      padding: const EdgeInsets.all(20),
      child: BaseMateoView(
        fitHeight: !surface._scrollable,
        reserveHeaderSpace: reserveHeaderSpace,
        surface: MateoSurfaceScope(
          shape: _shape,
          child: surface,
        ),
        header: header,
        footer: footer,
        overlay: overlay,
      ),
    );

    if (stackEntry == null) return content;
    return ListenableBuilder(
      listenable: stackEntry,
      child: content,
      builder: (context, content) => Opacity(
        opacity: stackEntry.opacity,
        child: ExcludeSemantics(
          excluding: stackEntry.covered,
          child: ExcludeFocus(
            excluding: stackEntry.covered,
            child: IgnorePointer(
              ignoring: stackEntry.covered,
              child: _MateoSheetFrame(
                stackEntry: stackEntry,
                color: surface.color ?? MateoTheme.of(context).colorScheme.background,
                dimColor: MateoTheme.of(context).colorScheme.sheet.scrim,
                child: content,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
