import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';
import 'package:mateo_mobile/src/gen/flags.g.dart';
import 'package:oh_my_flutter/src/device/device_locale/device_locale_platform.dart';
import 'package:oh_my_flutter/src/device/device_sim/device_sim_platform.dart';

import '../fixtures/fake_device_country_platform.dart';

final _theme = MateoThemeData.light(
  accentColor: const Color(0xFFFF4A4B),
  onAccent: MateoPalette().white,
);

Widget _host(
  Widget child, {
  Locale locale = const Locale('en', 'US'),
  TextDirection direction = .ltr,
  double textScale = 1,
}) => MateoApp(
  theme: _theme,
  locale: locale,
  supportedLocales: const [Locale('en', 'US'), Locale('pt', 'BR')],
  home: MediaQuery(
    data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
    child: Directionality(
      textDirection: direction,
      child: Center(child: SizedBox(width: 360, child: child)),
    ),
  ),
);

void main() {
  testWidgets(
    'omitted country uses the app locale without native test channels',
    (tester) async {
      await tester.pumpWidget(
        _host(
          MateoTextInput(
            autofocus: false,
            placeholder: 'Phone number',
            presentation: const .phone(),
            onChanged: (_) {},
          ),
          locale: const Locale('pt', 'BR'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('+55'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('omitted country falls back to the United States', (tester) async {
    final originalSimPlatform = DeviceSimPlatform.instance;
    final originalLocalePlatform = DeviceLocalePlatform.instance;
    addTearDown(() {
      DeviceSimPlatform.instance = originalSimPlatform;
      DeviceLocalePlatform.instance = originalLocalePlatform;
    });
    DeviceSimPlatform.instance = FakeDeviceCountryPlatform(() async => null);
    DeviceLocalePlatform.instance = FakeDeviceCountryPlatform(() async => null);

    await tester.pumpWidget(
      _host(
        MateoTextInput(
          autofocus: false,
          placeholder: 'Phone number',
          presentation: const .phone(),
          onChanged: (_) {},
        ),
        locale: const Locale('en'),
      ),
    );

    expect(find.text('+1'), findsOneWidget);
  });

  testWidgets(
    'untouched automatic country updates when SIM knowledge arrives',
    (tester) async {
      final originalSimPlatform = DeviceSimPlatform.instance;
      final originalLocalePlatform = DeviceLocalePlatform.instance;
      addTearDown(() {
        DeviceSimPlatform.instance = originalSimPlatform;
        DeviceLocalePlatform.instance = originalLocalePlatform;
      });
      final simCountry = Completer<String?>();
      final localePlatform = FakeDeviceCountryPlatform(() async => 'CA');
      DeviceSimPlatform.instance = FakeDeviceCountryPlatform(
        () => simCountry.future,
      );
      DeviceLocalePlatform.instance = localePlatform;

      await tester.pumpWidget(
        _host(
          MateoTextInput(
            autofocus: false,
            placeholder: 'Phone number',
            presentation: const .phone(),
            onChanged: (_) {},
          ),
          locale: const Locale('pt', 'BR'),
        ),
      );

      expect(find.text('+55'), findsOneWidget);

      simCountry.complete('US');
      await tester.pumpAndSettle();

      expect(find.text('+1'), findsOneWidget);
      expect(localePlatform.calls, 0);
    },
  );

  testWidgets(
    'automatic country does not replace a country after user input',
    (tester) async {
      final originalSimPlatform = DeviceSimPlatform.instance;
      final originalLocalePlatform = DeviceLocalePlatform.instance;
      addTearDown(() {
        DeviceSimPlatform.instance = originalSimPlatform;
        DeviceLocalePlatform.instance = originalLocalePlatform;
      });
      final simCountry = Completer<String?>();
      DeviceSimPlatform.instance = FakeDeviceCountryPlatform(
        () => simCountry.future,
      );
      DeviceLocalePlatform.instance = FakeDeviceCountryPlatform(
        () async => null,
      );

      await tester.pumpWidget(
        _host(
          MateoTextInput(
            autofocus: false,
            placeholder: 'Phone number',
            presentation: const .phone(),
            onChanged: (_) {},
          ),
          locale: const Locale('pt', 'BR'),
        ),
      );
      await tester.enterText(find.byType(CupertinoTextField), '119');

      simCountry.complete('US');
      await tester.pumpAndSettle();

      expect(find.text('+55'), findsOneWidget);
    },
  );

  testWidgets(
    'automatic country falls back from SIM to the device region',
    (tester) async {
      final originalSimPlatform = DeviceSimPlatform.instance;
      final originalLocalePlatform = DeviceLocalePlatform.instance;
      addTearDown(() {
        DeviceSimPlatform.instance = originalSimPlatform;
        DeviceLocalePlatform.instance = originalLocalePlatform;
      });
      final localeCountry = Completer<String?>();
      DeviceSimPlatform.instance = FakeDeviceCountryPlatform(
        () async => null,
      );
      DeviceLocalePlatform.instance = FakeDeviceCountryPlatform(
        () => localeCountry.future,
      );

      await tester.pumpWidget(
        _host(
          MateoTextInput(
            autofocus: false,
            placeholder: 'Phone number',
            presentation: const .phone(),
            onChanged: (_) {},
          ),
          locale: const Locale('pt', 'BR'),
        ),
      );

      expect(find.text('+55'), findsOneWidget);

      localeCountry.complete('US');
      await tester.pumpAndSettle();

      expect(find.text('+1'), findsOneWidget);
    },
  );

  testWidgets('language changes update an open picker without resetting input', (tester) async {
    final semantics = tester.ensureSemantics();
    final locale = ValueNotifier(const Locale('en', 'US'));
    final controller = TextEditingController(text: '11969230549');
    addTearDown(locale.dispose);
    addTearDown(controller.dispose);
    final changes = <String>[];
    await tester.pumpWidget(
      ValueListenableBuilder<Locale>(
        valueListenable: locale,
        builder: (context, locale, child) => _host(child!, locale: locale),
        child: MateoTextInput(
          placeholder: 'Phone',
          autofocus: false,
          controller: controller,
          presentation: const .phone(initialCountry: .brazil),
          onChanged: changes.add,
        ),
      ),
    );
    controller.selection = const TextSelection.collapsed(offset: 5);
    final originalValue = controller.value;
    await tester.tap(find.byType(MateoCountryFlag));
    await tester.pumpAndSettle();
    final search = find.byType(CupertinoTextField).last;
    await tester.enterText(search, 'zzzz');
    await tester.pumpAndSettle();
    final searchController = tester.widget<CupertinoTextField>(search).controller!;
    final searchValue = searchController.value;
    expect(find.text('No countries found'), findsOneWidget);

    locale.value = const Locale('pt', 'BR');
    await tester.pumpAndSettle();
    expect(find.text('Buscar países'), findsOneWidget);
    expect(find.bySemanticsLabel('Fechar seletor de países'), findsOneWidget);
    expect(find.text('Nenhum país encontrado'), findsOneWidget);
    expect(searchController.value, searchValue);
    expect(controller.value, originalValue);
    expect(changes, isEmpty);

    await tester.enterText(search, 'BR');
    await tester.pumpAndSettle();
    expect(find.text('Brasil'), findsOneWidget);
    expect(find.bySemanticsLabel('Brasil, selecionado'), findsOneWidget);

    locale.value = const Locale('en', 'US');
    await tester.pumpAndSettle();
    expect(find.text('Search countries'), findsOneWidget);
    expect(find.bySemanticsLabel('Close country picker'), findsOneWidget);
    expect(find.text('Brazil'), findsOneWidget);
    expect(find.bySemanticsLabel('Brazil, selected'), findsOneWidget);
    expect(searchController.text, 'BR');
    expect(controller.value, originalValue);
    expect(changes, isEmpty);

    Navigator.of(tester.element(find.byType(MateoSheetView))).pop();
    await tester.pumpAndSettle();
    expect(find.bySemanticsLabel('Change country, currently Brazil'), findsOneWidget);
    locale.value = const Locale('pt', 'BR');
    await tester.pumpAndSettle();
    expect(find.bySemanticsLabel('Alterar país, atualmente Brasil'), findsOneWidget);
    expect(controller.value, originalValue);
    expect(changes, isEmpty);
    semantics.dispose();
  });

  testWidgets('tapping the calling code opens the country picker', (tester) async {
    final focusNode = FocusNode();
    addTearDown(focusNode.dispose);
    await tester.pumpWidget(
      _host(
        MateoTextInput(
          autofocus: false,
          focusNode: focusNode,
          placeholder: 'Phone number',
          presentation: const .phone(initialCountry: .unitedStates),
          onChanged: (_) {},
        ),
      ),
    );

    await tester.tap(find.text('+1'));
    await tester.pumpAndSettle();
    expect(focusNode.hasFocus, isFalse);
    expect(find.byType(MateoSheetView), findsOneWidget);
  });

  test('phone presentation resolves its fixed treatment and defaults', () {
    const presentation = MateoTextInputPresentation.phone();

    expect(presentation.variant, MateoTextInputVariant.plain);
    expect(presentation.elevation, 0);
    expect(presentation.size, MateoTextInputSize.standard);
  });

  test('every selectable country has a bundled flag', () {
    for (final country in Country.values.where((country) => country.callingCode != null)) {
      expect(
        $Flags.findByName('${country.iso3.toLowerCase()}.svg'),
        isNotNull,
        reason: country.iso3,
      );
    }
  });

  testWidgets('formats initial controller text without reporting a user edit', (tester) async {
    final controller = TextEditingController(text: '11969230546');
    final changes = <String>[];
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      _host(
        MateoTextInput(
          autofocus: false,
          controller: controller,
          placeholder: 'Phone number',
          presentation: const .phone(initialCountry: .brazil),
          onChanged: changes.add,
        ),
      ),
    );

    expect(controller.text, '11 96923-0546');
    expect(changes, isEmpty);
    expect(find.text('+55'), findsOneWidget);
  });

  testWidgets('reports international values and follows an explicit international paste', (tester) async {
    final changes = <String>[];
    final submissions = <String>[];
    await tester.pumpWidget(
      _host(
        MateoTextInput(
          autofocus: false,
          placeholder: 'Phone number',
          presentation: const .phone(initialCountry: .brazil),
          onChanged: changes.add,
          onSubmitted: submissions.add,
        ),
      ),
    );

    await tester.enterText(find.byType(CupertinoTextField), '+1 202-555-0123');
    await tester.testTextInput.receiveAction(.done);
    await tester.pump();

    expect(find.text('+1'), findsOneWidget);
    expect(tester.widget<CupertinoTextField>(find.byType(CupertinoTextField)).controller!.text, '(202) 555-0123');
    expect(changes, ['+12025550123']);
    expect(submissions, ['+12025550123']);
  });

  testWidgets('keeps formatting with the country detected from a paste', (
    tester,
  ) async {
    final changes = <String>[];
    await tester.pumpWidget(
      _host(
        MateoTextInput(
          autofocus: false,
          placeholder: 'Phone number',
          presentation: const .phone(initialCountry: .brazil),
          onChanged: changes.add,
        ),
      ),
    );

    final field = find.byType(CupertinoTextField);
    await tester.enterText(field, '+1 202-555');
    await tester.pump();
    await tester.enterText(field, '2025550123');
    await tester.pump();

    expect(find.text('+1'), findsOneWidget);
    expect(
      tester.widget<CupertinoTextField>(field).controller!.text,
      '(202) 555-0123',
    );
    expect(changes, ['+1202555', '+12025550123']);
  });

  testWidgets('reformats the current value when initial country changes', (
    tester,
  ) async {
    final controller = TextEditingController(text: '2025550123');
    final changes = <String>[];
    addTearDown(controller.dispose);

    Widget input(Country country) => _host(
      MateoTextInput(
        key: const ValueKey('phone'),
        autofocus: false,
        controller: controller,
        placeholder: 'Phone number',
        presentation: .phone(initialCountry: country),
        onChanged: changes.add,
      ),
    );

    await tester.pumpWidget(input(Country.brazil));
    await tester.pumpWidget(input(Country.unitedStates));

    expect(find.text('+1'), findsOneWidget);
    expect(controller.text, '(202) 555-0123');
    expect(changes, isEmpty);
  });

  for (final size in MateoTextInputSize.values) {
    testWidgets('keeps the ${size.name} country selector physically left in right-to-left layouts', (tester) async {
      await tester.pumpWidget(
        _host(
          MateoTextInput(
            autofocus: false,
            placeholder: 'Phone number',
            presentation: .phone(initialCountry: .brazil, size: size),
            onChanged: (_) {},
          ),
          direction: .rtl,
        ),
      );

      final selector = find.descendant(of: find.byType(MateoTextInput), matching: find.byType(MateoPress));
      final flag = find.descendant(of: find.byType(MateoTextInput), matching: find.byType(ClipOval));
      final code = find.text('+55');
      final editor = find.byType(EditableText);
      expect(find.descendant(of: selector, matching: code), findsOneWidget);
      expect(tester.getRect(flag).right, lessThan(tester.getRect(code).left));
      expect(find.byType(MateoIcon), findsNothing);
      expect(tester.getRect(code).right, lessThan(tester.getRect(editor).left));
      expect(tester.getSize(selector).height, size.height);
      expect(tester.getSize(flag), Size.square(size == .large ? 32 : size.leadingIconSize));
      expect(find.byType(MateoSurface), findsNothing);
      final expectedFontSize = switch (size) {
        .small => 16.0,
        .standard => 18.0,
        .large => 20.0,
      };
      final field = tester.widget<CupertinoTextField>(find.byType(CupertinoTextField));
      expect(field.style!.fontSize, expectedFontSize);
      expect(field.placeholderStyle!.fontSize, expectedFontSize);
      expect(tester.widget<Text>(code).style!.fontSize, expectedFontSize);
      expect(tester.widget<Text>(code).style!.fontWeight, FontWeight.w600);
      expect(tester.widget<CupertinoTextField>(find.byType(CupertinoTextField)).style!.fontWeight, FontWeight.w500);
    });
  }

  testWidgets('disables the editor and country selector together', (tester) async {
    await tester.pumpWidget(
      _host(
        const MateoTextInput(
          autofocus: false,
          placeholder: 'Phone number',
          presentation: .phone(initialCountry: .brazil),
        ),
      ),
    );

    final field = tester.widget<CupertinoTextField>(find.byType(CupertinoTextField));
    final flagOpacity = find.ancestor(of: find.byType(MateoCountryFlag), matching: find.byType(Opacity));
    expect(tester.widget<Opacity>(flagOpacity).opacity, 0.65);
    expect(field.enabled, isFalse);
    expect(field.style!.color, _theme.colorScheme.textInputs.plain.textDisabled);
    expect(tester.widget<Text>(find.text('+55')).style!.color, field.style!.color);

    await tester.tap(find.byType(MateoCountryFlag));
    await tester.tap(find.text('+55'));
    await tester.pumpAndSettle();
    expect(find.byType(MateoSheetView), findsNothing);

    await tester.pumpWidget(
      _host(
        MateoTextInput(
          autofocus: false,
          placeholder: 'Phone number',
          presentation: const .phone(initialCountry: .brazil),
          onChanged: (_) {},
        ),
      ),
    );
    expect(tester.widget<Opacity>(flagOpacity).opacity, 1);
  });

  testWidgets('grows the number and calling code for accessible text sizes', (tester) async {
    await tester.pumpWidget(
      _host(
        MateoTextInput(
          autofocus: false,
          placeholder: 'Phone number',
          presentation: const .phone(initialCountry: .brazil),
          onChanged: (_) {},
        ),
        textScale: 3,
      ),
    );

    expect(tester.getSize(find.byType(CupertinoTextField)).height, greaterThan(MateoTextInputSize.standard.height));
    expect(
      tester.getSize(find.text('+55')).height,
      greaterThan(MateoTextInputVariant.plain.resolveTypography(.standard).lineHeight),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('large plain supports disabled state and accessibility scaling', (tester) async {
    await tester.pumpWidget(
      _host(
        const MateoTextInput(
          autofocus: false,
          placeholder: 'Phone number',
          presentation: .phone(initialCountry: .brazil, size: .large),
        ),
        textScale: 2,
      ),
    );
    final field = tester.widget<CupertinoTextField>(find.byType(CupertinoTextField));
    expect(field.enabled, isFalse);
    expect(field.style!.fontSize, 20);
    expect(field.style!.height, 28 / 20);
    expect(field.style!.color, _theme.colorScheme.textInputs.plain.textDisabled);
    expect(tester.getSize(find.byType(CupertinoTextField)).height, greaterThan(57));
    expect(tester.getSize(find.byType(MateoCountryFlag)), const Size.square(32));
    expect(tester.takeException(), isNull);
  });

  testWidgets('rejects an initial country without a calling code', (tester) async {
    await tester.pumpWidget(
      _host(
        MateoTextInput(
          autofocus: false,
          placeholder: 'Phone number',
          presentation: const .phone(initialCountry: Country.antarctica),
          onChanged: (_) {},
        ),
      ),
    );

    expect(tester.takeException(), isAssertionError);
  });

  testWidgets('selects a country from the localized searchable sheet and preserves digits', (tester) async {
    final controller = TextEditingController.fromValue(
      const TextEditingValue(
        text: '1196923054',
        selection: TextSelection.collapsed(offset: 6),
      ),
    );
    final changes = <String>[];
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      _host(
        MateoTextInput(
          autofocus: false,
          controller: controller,
          placeholder: 'Número',
          presentation: const .phone(initialCountry: .brazil),
          onChanged: changes.add,
        ),
        locale: const Locale('pt', 'BR'),
      ),
    );

    controller.selection = const TextSelection.collapsed(offset: 7);

    await tester.tap(find.byType(MateoCountryFlag));
    await tester.pumpAndSettle();
    expect(find.byType(MateoSheetView), findsOneWidget);
    expect(find.text('Buscar países'), findsOneWidget);

    final searchField = find.byType(CupertinoTextField).last;
    await tester.enterText(searchField, 'estados unidos');
    await tester.pump();
    expect(find.text('Estados Unidos'), findsOneWidget);

    await tester.tap(find.text('Estados Unidos'));
    await tester.pumpAndSettle();
    expect(find.byType(MateoSheetView), findsNothing);
    expect(find.text('+1'), findsOneWidget);
    expect(controller.text.replaceAll(RegExp(r'\D'), ''), '1196923054');
    expect(controller.selection, const TextSelection.collapsed(offset: 6));
    expect(changes, ['+11196923054']);
  });

  testWidgets('keyboard changes preserve the phone picker query, focus, and scroll state', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(800, 600);
    addTearDown(tester.view.reset);
    final controller = TextEditingController(text: '11969230549');
    addTearDown(controller.dispose);
    final changes = <String>[];
    await tester.pumpWidget(
      _host(
        MateoTextInput(
          autofocus: false,
          placeholder: 'Phone',
          controller: controller,
          presentation: const .phone(initialCountry: .brazil),
          onChanged: changes.add,
        ),
      ),
    );
    controller.selection = const TextSelection.collapsed(offset: 5);
    final phoneValue = controller.value;
    await tester.tap(find.byType(MateoCountryFlag));
    await tester.pumpAndSettle();
    final search = find.byType(CupertinoTextField).last;
    await tester.enterText(search, 'a');
    await tester.pumpAndSettle();
    final searchField = tester.widget<CupertinoTextField>(search);
    final searchValue = searchField.controller!.value;
    final list = find.byType(ListView);
    await tester.drag(list, const Offset(0, -180));
    await tester.pumpAndSettle();
    final position = tester
        .state<ScrollableState>(find.descendant(of: list, matching: find.byType(Scrollable)))
        .position;
    final scrollOffset = position.pixels;
    expect(scrollOffset, greaterThan(0));
    for (final inset in [200.0, 300.0, 0.0]) {
      tester.view.viewInsets = FakeViewPadding(bottom: inset);
      await tester.pumpAndSettle();
      expect(tester.getBottomRight(find.byType(MateoSheetView)).dy, 600 - inset - 12);
      expect(position.pixels, scrollOffset);
      expect(searchField.focusNode!.hasFocus, isTrue);
      expect(searchField.controller!.value, searchValue);
      expect(controller.value, phoneValue);
      expect(changes, isEmpty);
    }
    Navigator.of(tester.element(find.byType(MateoSheetView))).pop();
    await tester.pumpAndSettle();
    expect(find.text('+55'), findsOneWidget);
    expect(controller.value, phoneValue);
    expect(changes, isEmpty);
  });

  testWidgets('country picker builds rows lazily and keeps its size while filtering', (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      _host(
        MateoTextInput(
          autofocus: false,
          placeholder: 'Phone number',
          presentation: const .phone(initialCountry: .brazil),
          onChanged: (_) {},
        ),
      ),
    );
    await tester.tap(find.byType(MateoCountryFlag));
    await tester.pumpAndSettle();

    final sheet = find.byType(MateoSheetView);
    final originalSize = tester.getSize(sheet);
    final list = find.descendant(of: sheet, matching: find.byType(ListView));
    expect(tester.widget<ListView>(list).clipBehavior, Clip.none);
    expect(find.text('Zimbabwe'), findsNothing);
    expect(find.descendant(of: sheet, matching: find.byType(MateoCountryFlag)).evaluate().length, lessThan(30));

    await tester.scrollUntilVisible(
      find.text('Zimbabwe'),
      500,
      scrollable: find.descendant(of: list, matching: find.byType(Scrollable)),
      maxScrolls: 60,
    );
    await tester.pumpAndSettle();
    expect(find.text('Zimbabwe').hitTestable(), findsOneWidget);

    final search = find.byType(CupertinoTextField).last;
    await tester.enterText(search, 'curacao');
    await tester.pumpAndSettle();
    expect(find.text('Curaçao').hitTestable(), findsOneWidget);
    expect(tester.getSize(sheet), originalSize);
    await tester.enterText(search, 'zzzz');
    await tester.pumpAndSettle();
    expect(find.text('No countries found'), findsOneWidget);
    expect(tester.getSize(sheet), originalSize);
    await tester.enterText(search, 'Zimbabwe');
    await tester.pumpAndSettle();
    await tester.tap(find.descendant(of: list, matching: find.text('Zimbabwe')));
    await tester.pumpAndSettle();
    expect(sheet, findsNothing);
    expect(find.bySemanticsLabel('Change country, currently Zimbabwe'), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('country search ignores diacritics and shows localized empty results', (tester) async {
    await tester.pumpWidget(
      _host(
        MateoTextInput(
          autofocus: false,
          placeholder: 'Phone number',
          presentation: const .phone(initialCountry: .brazil),
          onChanged: (_) {},
        ),
      ),
    );

    await tester.tap(find.byType(MateoCountryFlag));
    await tester.pumpAndSettle();
    final searchField = find.byType(CupertinoTextField).last;
    await tester.enterText(searchField, 'curacao');
    await tester.pump();
    expect(find.text('Curaçao'), findsOneWidget);

    await tester.enterText(searchField, 'zzzz');
    await tester.pump();
    expect(find.text('No countries found'), findsOneWidget);
  });

  testWidgets('country search preserves the not-found animation across empty queries', (tester) async {
    await tester.pumpWidget(
      _host(
        MateoTextInput(
          autofocus: false,
          placeholder: 'Phone number',
          presentation: const .phone(initialCountry: .brazil),
          onChanged: (_) {},
        ),
      ),
    );

    await tester.tap(find.byType(MateoCountryFlag));
    await tester.pumpAndSettle();
    final searchField = find.byType(CupertinoTextField).last;
    await tester.enterText(searchField, 'zzzz');
    await tester.pump();

    final animatedEarth = find.byWidgetPredicate(
      (widget) => widget.runtimeType.toString() == '_EarthRotating',
      description: 'earth rotating animated icon',
    );
    final animationState = tester.state(animatedEarth);

    await tester.enterText(searchField, 'xxxx');
    await tester.pump();
    expect(tester.state(animatedEarth), same(animationState));

    await tester.enterText(searchField, 'Brazil');
    await tester.pump();
    expect(animatedEarth, findsNothing);

    await tester.enterText(searchField, 'zzzz');
    await tester.pump();
    expect(tester.state(animatedEarth), isNot(same(animationState)));
  });
}
