part of '../../../show_mateo_sheet.dart';

/// A fixed header with sheet-owned spacing.
///
/// Supply this to [MateoSheetView.header]. Use [MateoSheetViewHeaderPresentation]
/// to choose a drag handle, a close button, or custom content.
class MateoSheetViewHeader extends StatelessWidget {
  /// Creates a sheet header using [presentation].
  const MateoSheetViewHeader({required this.presentation, super.key});

  /// The content and interaction provided by the header.
  final MateoSheetViewHeaderPresentation presentation;

  @override
  Widget build(BuildContext context) => presentation;
}
