part of '../../mateo_text_input.dart';

class _MateoPhoneCountryPicker extends StatelessWidget {
  const _MateoPhoneCountryPicker({
    required this.selectedCountry,
    required this.query,
  });

  final Country selectedCountry;
  final ValueListenable<String> query;

  String _normalized(String value) => removeDiacritics(value).toLowerCase();

  List<({Country country, String name, String normalizedName})> _countries(
    Locale locale,
  ) {
    final countries = <({Country country, String name, String normalizedName})>[];

    for (final country in Country.values) {
      if (country.callingCode == null) continue;
      final name = country.displayName(locale);
      countries.add((
        country: country,
        name: name,
        normalizedName: _normalized(name),
      ));
    }

    return countries..sort((left, right) {
      final byName = left.normalizedName.compareTo(right.normalizedName);
      if (byName != 0) return byName;
      return left.country.iso2.compareTo(right.country.iso2);
    });
  }

  bool _matches(
    ({Country country, String name, String normalizedName}) entry,
    String value,
  ) {
    final normalizedQuery = _normalized(value.trim());
    if (normalizedQuery.isEmpty) return true;
    return entry.normalizedName.contains(normalizedQuery) ||
        entry.country.iso2.toLowerCase().contains(normalizedQuery) ||
        entry.country.iso3.toLowerCase().contains(normalizedQuery) ||
        entry.country.callingCode!.contains(
          normalizedQuery.replaceFirst('+', ''),
        );
  }

  @override
  Widget build(BuildContext context) {
    final countries = _countries(Localizations.localeOf(context));
    final translations = mateoTranslationsOf(context).textInput.phone;
    final mateoTheme = MateoTheme.of(context);

    return SizedBox.expand(
      child: ValueListenableBuilder<String>(
        valueListenable: query,
        builder: (context, query, notFound) {
          final filteredCountries = countries.where((entry) => _matches(entry, query)).toList(growable: false);

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
                selected: entry.country == selectedCountry,
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
                          fontWeight: .w600,
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
    );
  }
}
