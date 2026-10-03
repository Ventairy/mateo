///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

part of 'translations.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element

class Translations with BaseTranslations<AppLocale, Translations> {
  /// You can call this constructor and build your own translation instance of this locale.
  /// Constructing via the enum [AppLocale.build] is preferred.
  Translations({
    Map<String, Node>? overrides,
    PluralResolver? cardinalResolver,
    PluralResolver? ordinalResolver,
    TranslationMetadata<AppLocale, Translations>? meta,
  }) : assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
       _meta =
           meta ??
           TranslationMetadata(
             locale: AppLocale.en,
             overrides: overrides ?? {},
             cardinalResolver: cardinalResolver,
             ordinalResolver: ordinalResolver,
           ) {
    _meta.setFlatMapFunction(_flatMapFunction);
  }

  /// Metadata for the translations of <en>.
  final TranslationMetadata<AppLocale, Translations> _meta;
  @override
  TranslationMetadata<AppLocale, Translations> get $meta => _meta;

  /// Access flat map
  dynamic operator [](String key) => _meta.getTranslation(key);

  late final Translations _root = this; // ignore: unused_field

  Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) =>
      Translations(meta: meta ?? this.$meta);

  // Translations
  late final Translations$textInput$en textInput = Translations$textInput$en.internal(_root);
}

// Path: textInput
class Translations$textInput$en {
  Translations$textInput$en.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations
  late final Translations$textInput$phone$en phone = Translations$textInput$phone$en.internal(_root);
}

// Path: textInput.phone
class Translations$textInput$phone$en {
  Translations$textInput$phone$en.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Change country, currently $country'
  String changeCountryAccessibilityLabel({required Object country}) => 'Change country, currently ${country}';

  /// en: 'Close country picker'
  String get closeCountryPickerAccessibilityLabel => 'Close country picker';

  /// en: '$country, selected'
  String countrySelectedAccessibilityLabel({required Object country}) => '${country}, selected';

  /// en: 'Loading countries'
  String get loadingCountries => 'Loading countries';

  /// en: 'We couldn't find it'
  String get noCountriesFound => 'We couldn\'t find it';

  /// en: 'Search country'
  String get searchCountries => 'Search country';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
  dynamic _flatMapFunction(String path) {
    return switch (path) {
      'textInput.phone.changeCountryAccessibilityLabel' => ({
        required Object country,
      }) => 'Change country, currently ${country}',
      'textInput.phone.closeCountryPickerAccessibilityLabel' => 'Close country picker',
      'textInput.phone.countrySelectedAccessibilityLabel' => ({required Object country}) => '${country}, selected',
      'textInput.phone.loadingCountries' => 'Loading countries',
      'textInput.phone.noCountriesFound' => 'We couldn\'t find it',
      'textInput.phone.searchCountries' => 'Search country',
      _ => null,
    };
  }
}
