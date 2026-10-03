import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/src/i18n/mateo_translations.dart';

void main() {
  final cases = <Locale, String>{
    const Locale('en'): 'Search countries',
    const Locale('en', 'US'): 'Search countries',
    const Locale('pt', 'BR'): 'Buscar países',
    const Locale('pt'): 'Buscar países',
    const Locale('pt', 'PT'): 'Buscar países',
    const Locale.fromSubtags(languageCode: 'pt', scriptCode: 'Latn', countryCode: 'BR'): 'Buscar países',
    const Locale('fr'): 'Search countries',
    const Locale('fr', 'BR'): 'Search countries',
  };
  for (final entry in cases.entries) {
    testWidgets('when the locale is ${entry.key}, it should resolve the supported translation', (tester) async {
      await tester.pumpWidget(
        Localizations(
          locale: entry.key,
          delegates: const [DefaultWidgetsLocalizations.delegate],
          child: Directionality(
            textDirection: .ltr,
            child: Builder(builder: (context) => Text(mateoTranslationsOf(context).textInput.phone.searchCountries)),
          ),
        ),
      );
      expect(find.text(entry.value), findsOneWidget);
    });
  }

  testWidgets('when the inherited locale changes, it should rebuild the same dependent widget', (tester) async {
    final locale = ValueNotifier(const Locale('en'));
    addTearDown(locale.dispose);
    await tester.pumpWidget(
      ValueListenableBuilder<Locale>(
        valueListenable: locale,
        builder: (context, locale, child) => Localizations(
          locale: locale,
          delegates: const [DefaultWidgetsLocalizations.delegate],
          child: child,
        ),
        child: Directionality(
          textDirection: .ltr,
          child: Builder(builder: (context) => Text(mateoTranslationsOf(context).textInput.phone.searchCountries)),
        ),
      ),
    );
    expect(find.text('Search countries'), findsOneWidget);
    locale.value = const Locale('pt', 'BR');
    await tester.pumpAndSettle();
    expect(find.text('Buscar países'), findsOneWidget);
    locale.value = const Locale('en');
    await tester.pumpAndSettle();
    expect(find.text('Search countries'), findsOneWidget);
  });
}
