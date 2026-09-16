part of 'mateo_text_field.dart';

/// The visual treatment and typography of a Mateo search field.
///
/// Each presentation owns its layout, motion, and elevation. Colors resolve
/// from the matching text-field roles in the Mateo theme.
@immutable
sealed class MateoTextFieldPresentation extends StatefulWidget {
  const MateoTextFieldPresentation._({super.key});

  /// Creates a search field with the selected visual [variant].
  ///
  /// The keyboard defaults to the search action unless the field overrides it.
  const factory MateoTextFieldPresentation.search({required MateoTextFieldVariant variant}) =
      _MateoSearchTextFieldPresentation;

  /// The visual treatment applied to the search field.
  MateoTextFieldVariant get variant;
}
