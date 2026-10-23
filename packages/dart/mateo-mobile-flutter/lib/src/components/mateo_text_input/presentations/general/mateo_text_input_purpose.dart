import 'package:flutter/services.dart';

/// The typing assistance for a general text input's intended content.
///
/// Purposes configure the keyboard and autofill without changing entered text.
enum MateoTextInputPurpose {
  /// Ordinary text with sentence capitalization, correction, and suggestions.
  text(
    keyboardType: .text,
    textCapitalization: .sentences,
    autocorrect: true,
    enableSuggestions: true,
    autofillHints: [],
  ),

  /// A person's first name with word capitalization and given-name autofill.
  givenName(
    keyboardType: .text,
    textCapitalization: .words,
    autocorrect: false,
    enableSuggestions: true,
    smartDashesType: .disabled,
    smartQuotesType: .disabled,
    autofillHints: [AutofillHints.givenName],
  ),

  /// An email address without automatic capitalization or correction.
  email(
    keyboardType: .emailAddress,
    textCapitalization: .none,
    autocorrect: false,
    enableSuggestions: false,
    smartDashesType: .disabled,
    smartQuotesType: .disabled,
    autofillHints: [AutofillHints.email],
  ),

  /// A phone number with a phone keyboard and telephone-number autofill.
  ///
  /// Does not format the number or add a country selector.
  phone(
    keyboardType: .phone,
    textCapitalization: .none,
    autocorrect: false,
    enableSuggestions: false,
    smartDashesType: .disabled,
    smartQuotesType: .disabled,
    autofillHints: [AutofillHints.telephoneNumber],
  );

  const MateoTextInputPurpose({
    required this.keyboardType,
    required this.textCapitalization,
    required this.autocorrect,
    required this.enableSuggestions,
    required this.autofillHints,
    this.smartDashesType,
    this.smartQuotesType,
  });

  /// The keyboard requested for this content.
  final TextInputType keyboardType;

  /// The automatic capitalization suggested by the keyboard.
  final TextCapitalization textCapitalization;

  /// Whether the keyboard may correct entered words.
  final bool autocorrect;

  /// Whether the keyboard may offer text suggestions.
  final bool enableSuggestions;

  /// The smart-dash behavior, or null to use the native default.
  final SmartDashesType? smartDashesType;

  /// The smart-quote behavior, or null to use the native default.
  final SmartQuotesType? smartQuotesType;

  /// The content hints supplied to the platform autofill service.
  final List<String> autofillHints;
}
