part of '../mateo_text_input.dart';

/// The visual presentation of a Mateo text input.
@immutable
sealed class MateoTextInputPresentation extends StatefulWidget {
  const MateoTextInputPresentation._();

  /// Creates a search text input presentation.
  ///
  /// ```dart
  /// MateoTextInputPresentation.search(variant: .filled.base, elevation: 1)
  /// ```
  const factory MateoTextInputPresentation.search({
    required MateoTextInputVariant variant,
    MateoTextInputSize size,
    double elevation,
  }) = _MateoSearchTextInputPresentation;

  /// Creates a phone-number input presentation.
  ///
  /// When [initialCountry] is omitted, Mateo selects a likely country from
  /// device knowledge, the resolved app locale, or a fallback (United States)
  const factory MateoTextInputPresentation.phone({
    Country? initialCountry,
    MateoTextInputSize size,
  }) = _MateoPhoneTextInputPresentation;

  /// The surface lift
  ///
  /// Defaults to zero (flat).
  double get elevation;

  /// The visual treatment applied to the text input.
  MateoTextInputVariant get variant;

  /// The text input's surface size.
  ///
  /// Defaults to [MateoTextInputSize.standard].
  MateoTextInputSize get size;
}
