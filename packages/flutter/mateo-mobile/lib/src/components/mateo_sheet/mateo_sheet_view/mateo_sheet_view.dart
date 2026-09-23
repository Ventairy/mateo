part of '../show_mateo_sheet.dart';

/// A sheet's content and fixed header, footer, and overlay.
///
/// Supply this to [showMateoSheet].
///
/// ```dart
/// showMateoSheet<void>(
///   context: context,
///   view: const MateoSheetView(
///     header: MateoSheetViewHeader(presentation: .custom(principal: Text('Details'))),
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
    final colorScheme = stackEntry == null ? null : MateoTheme.of(context).colorScheme;
    final surfaceColor = surface.color ?? colorScheme?.background;

    final content = MateoViewScope(
      padding: const EdgeInsets.all(20),
      child: BaseMateoView(
        fitHeight: !surface._scrollable,
        reserveHeaderSpace: reserveHeaderSpace,
        surfacePresentation: (
          color: surface.color,
          elevation: null,
          shape: _shape,
        ),
        // The stack frame already fills opaque covered sheets. Keep the inner
        // background for the front sheet and for transparent surfaces.
        surfaceBackgroundVisibility: stackEntry != null && surfaceColor!.a == 1.0
            ? (listenable: stackEntry, isVisible: () => stackEntry.depth == 0)
            : null,
        // Background visibility can change without repainting the content.
        isolateContentPaint: stackEntry != null,
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
    return _MateoSheetViewPresentation(
      stackEntry: stackEntry,
      color: surfaceColor!,
      dimColor: colorScheme!.sheet.scrim,
      // The frame changes while another sheet covers it; its content does not.
      child: content,
    );
  }
}
