part of '../../../../show_mateo_sheet.dart';

/// The content and interaction mounted by a Mateo sheet header.
@immutable
sealed class MateoSheetViewHeaderPresentation extends StatelessWidget {
  const MateoSheetViewHeaderPresentation._();

  /// Creates a drag handle connected to the containing sheet.
  const factory MateoSheetViewHeaderPresentation.handle() = _MateoHandleSheetViewHeaderPresentation;

  /// Creates a close button with an automatically localized accessible label.
  ///
  /// Requires a containing Mateo sheet and respects its dismissal decision.
  const factory MateoSheetViewHeaderPresentation.closeButton() = _MateoCloseButtonSheetViewHeaderPresentation;

  /// Creates a header with optional directional side slots and main content.
  ///
  /// [principal] fills the available width. With both sides present, its region
  /// is centered across the header and text defaults to centered alignment.
  /// Children own text alignment, wrapping, and overflow behavior.
  const factory MateoSheetViewHeaderPresentation.custom({
    Widget? leading,
    Widget? principal,
    Widget? trailing,
  }) = _MateoCustomSheetViewHeaderPresentation;
}
