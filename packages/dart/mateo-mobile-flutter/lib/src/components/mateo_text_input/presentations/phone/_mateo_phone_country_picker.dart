part of '../../mateo_text_input.dart';

typedef _MateoPhoneCountryCatalog =
    List<({Country country, String name, String normalizedName, String lowercaseIso2, String lowercaseIso3})>;

class _MateoPhoneCountryPicker extends StatefulWidget {
  const _MateoPhoneCountryPicker({
    required this.selectedCountry,
    required this.query,
    required this.catalogLocale,
    required this.catalog,
  });

  final Country selectedCountry;
  final ValueListenable<String> query;
  final Locale catalogLocale;
  final _MateoPhoneCountryCatalog? catalog;

  static final List<Country> _skeletonCountries = Country.values
      .where((country) => country.callingCode != null)
      .toList(growable: false);

  static String _normalized(String value) => removeDiacritics(value).toLowerCase();

  static _MateoPhoneCountryCatalog createCatalog(Locale locale) {
    final countries =
        <({Country country, String name, String normalizedName, String lowercaseIso2, String lowercaseIso3})>[];

    for (final country in Country.values) {
      if (country.callingCode == null) continue;
      final name = country.displayName(locale);
      countries.add((
        country: country,
        name: name,
        normalizedName: _normalized(name),
        lowercaseIso2: country.iso2.toLowerCase(),
        lowercaseIso3: country.iso3.toLowerCase(),
      ));
    }

    return countries..sort((left, right) {
      final byName = left.normalizedName.compareTo(right.normalizedName);
      if (byName != 0) return byName;
      return left.country.iso2.compareTo(right.country.iso2);
    });
  }

  @override
  State<_MateoPhoneCountryPicker> createState() => _MateoPhoneCountryPickerState();
}

class _MateoPhoneCountryPickerState extends State<_MateoPhoneCountryPicker> {
  final _catalogsByLocale = <Locale, _MateoPhoneCountryCatalog>{};

  bool _matches(
    ({Country country, String name, String normalizedName, String lowercaseIso2, String lowercaseIso3}) entry,
    String normalizedQuery,
    String callingCodeQuery,
  ) {
    return entry.normalizedName.contains(normalizedQuery) ||
        entry.lowercaseIso2.contains(normalizedQuery) ||
        entry.lowercaseIso3.contains(normalizedQuery) ||
        entry.country.callingCode!.contains(callingCodeQuery);
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final catalog = widget.catalog;
    final countries = catalog == null
        ? null
        : locale == widget.catalogLocale
        ? catalog
        : _catalogsByLocale.putIfAbsent(locale, () => _MateoPhoneCountryPicker.createCatalog(locale));
    final translations = mateoTranslationsOf(context).textInput.phone;
    final mateoTheme = MateoTheme.of(context);

    return Semantics(
      container: countries == null,
      liveRegion: countries == null,
      label: countries == null ? translations.loadingCountries : null,
      child: SizedBox.expand(
        child: ValueListenableBuilder<String>(
          valueListenable: widget.query,
          builder: (context, query, notFound) {
            if (countries == null) {
              return ListView.builder(
                primary: false,
                padding: .zero,
                clipBehavior: .none,
                itemCount: _MateoPhoneCountryPicker._skeletonCountries.length,
                itemBuilder: (context, index) {
                  final country = _MateoPhoneCountryPicker._skeletonCountries[index];
                  return _MateoPhoneCountryRow(
                    country: country,
                    selected: country == widget.selectedCountry,
                  );
                },
              );
            }
            final normalizedQuery = _MateoPhoneCountryPicker._normalized(query.trim());
            final callingCodeQuery = normalizedQuery.replaceFirst('+', '');
            final filteredCountries = normalizedQuery.isEmpty
                ? countries
                : countries
                      .where((entry) => _matches(entry, normalizedQuery, callingCodeQuery))
                      .toList(growable: false);
            if (filteredCountries.isEmpty) return notFound!;
            return ListView.builder(
              primary: false,
              padding: .zero,
              clipBehavior: .none,
              itemCount: filteredCountries.length,
              itemBuilder: (context, index) {
                final entry = filteredCountries[index];
                return _MateoPhoneCountryRow(
                  country: entry.country,
                  name: entry.name,
                  selected: entry.country == widget.selectedCountry,
                  onPressed: () => Navigator.of(context).pop(entry.country),
                );
              },
            );
          },
          child: Semantics(
            container: true,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  $AnimatedIcons.earthRotating(
                    height: 80,
                    width: 80,
                    playback: .loop,
                    overrides: .new(
                      color1: switch (mateoTheme.brightness) {
                        Brightness.dark => throw UnimplementedError('Dark mode not implemented'),
                        Brightness.light => mateoTheme.palette.neutral[4],
                      },
                      color2: switch (mateoTheme.brightness) {
                        Brightness.dark => throw UnimplementedError('Dark mode not implemented'),
                        Brightness.light => mateoTheme.palette.neutral[4],
                      },
                      color3: switch (mateoTheme.brightness) {
                        Brightness.dark => throw UnimplementedError('Dark mode not implemented'),
                        Brightness.light => mateoTheme.palette.neutral[4],
                      },
                    ),
                  ),
                  Align(
                    alignment: .topCenter,
                    child: SizedBox(
                      height: 60,
                      child: Center(
                        child: Text(
                          translations.noCountriesFound,
                          textAlign: .center,
                          style: TextStyle(
                            fontFamily: MateoTypography.fontFamily,
                            letterSpacing: MateoTypography.letterSpacing,
                            fontSize: 15,
                            height: 1.4,
                            fontWeight: .w500,
                            color: MateoTheme.of(context).colorScheme.text.tertiary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 26),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
