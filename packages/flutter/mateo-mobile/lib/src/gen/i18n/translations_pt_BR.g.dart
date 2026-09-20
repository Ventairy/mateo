///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

import 'package:intl/intl.dart';
import 'package:slang/generated.dart';

import 'translations.g.dart';

// Path: <root>
class TranslationsPtBr extends Translations with BaseTranslations<AppLocale, Translations> {
  /// You can call this constructor and build your own translation instance of this locale.
  /// Constructing via the enum [AppLocale.build] is preferred.
  TranslationsPtBr({
    Map<String, Node>? overrides,
    PluralResolver? cardinalResolver,
    PluralResolver? ordinalResolver,
    TranslationMetadata<AppLocale, Translations>? meta,
  }) : assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
       _meta =
           meta ??
           TranslationMetadata(
             locale: AppLocale.ptBr,
             overrides: overrides ?? {},
             cardinalResolver: cardinalResolver,
             ordinalResolver: ordinalResolver,
           ),
       super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
    _meta.setFlatMapFunction(_flatMapFunction);
  }

  /// Metadata for the translations of <pt-BR>.
  final TranslationMetadata<AppLocale, Translations> _meta;
  @override
  TranslationMetadata<AppLocale, Translations> get $meta => _meta;

  /// Access flat map
  @override
  dynamic operator [](String key) => _meta.getTranslation(key) ?? super[key];

  late final TranslationsPtBr _root = this; // ignore: unused_field

  @override
  TranslationsPtBr $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) =>
      TranslationsPtBr(meta: meta ?? this.$meta);

  // Translations
  @override
  late final Translations$textInput$pt_BR textInput = Translations$textInput$pt_BR._(_root);
}

// Path: textInput
class Translations$textInput$pt_BR extends Translations$textInput$en {
  Translations$textInput$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

  final TranslationsPtBr _root; // ignore: unused_field

  // Translations
  @override
  late final Translations$textInput$phone$pt_BR phone = Translations$textInput$phone$pt_BR._(_root);
}

// Path: textInput.phone
class Translations$textInput$phone$pt_BR extends Translations$textInput$phone$en {
  Translations$textInput$phone$pt_BR._(TranslationsPtBr root) : this._root = root, super.internal(root);

  final TranslationsPtBr _root; // ignore: unused_field

  // Translations
  @override
  String changeCountryAccessibilityLabel({required Object country}) => 'Alterar país, atualmente ${country}';
  @override
  String get closeCountryPickerAccessibilityLabel => 'Fechar seletor de países';
  @override
  String countrySelectedAccessibilityLabel({required Object country}) => '${country}, selecionado';
  @override
  String get noCountriesFound => 'Não encontramos nada';
  @override
  String get searchCountries => 'Buscar país';
}

/// The flat map containing all translations for locale <pt-BR>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsPtBr {
  dynamic _flatMapFunction(String path) {
    return switch (path) {
      'textInput.phone.changeCountryAccessibilityLabel' => ({
        required Object country,
      }) => 'Alterar país, atualmente ${country}',
      'textInput.phone.closeCountryPickerAccessibilityLabel' => 'Fechar seletor de países',
      'textInput.phone.countrySelectedAccessibilityLabel' => ({required Object country}) => '${country}, selecionado',
      'textInput.phone.noCountriesFound' => 'Não encontramos nada',
      'textInput.phone.searchCountries' => 'Buscar país',
      _ => null,
    };
  }
}
