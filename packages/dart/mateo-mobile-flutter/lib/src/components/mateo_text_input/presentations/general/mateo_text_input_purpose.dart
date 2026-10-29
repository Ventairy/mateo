import 'package:flutter/services.dart';

part 'input_formatters/_code_text_input_purpose_formatter.dart';

/// The typing assistance for a general text input's intended content.
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
  ),

  /// A code for something, for example a referral code
  code(
    keyboardType: .text,
    textCapitalization: .characters,
    inputFormatters: [_CodeTextInputFormatter()],
    autocorrect: false,
    enableSuggestions: false,
    smartDashesType: .disabled,
    smartQuotesType: .disabled,
    autofillHints: [],
  );

  const MateoTextInputPurpose({
    required this.keyboardType,
    required this.textCapitalization,
    required this.autocorrect,
    required this.enableSuggestions,
    required this.autofillHints,
    this.inputFormatters = const [],
    this.smartDashesType,
    this.smartQuotesType,
  });

  /// The formatters applied to user edits for this purpose.
  ///
  /// App-supplied controller values are not formatted.
  final List<TextInputFormatter> inputFormatters;

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
