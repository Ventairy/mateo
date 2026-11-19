import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

Widget _host(
  String text, {
  MateoTextInterfaceFontSize? fontSize,
  FontWeight? fontWeight,
  String? semanticsLabel,
  Locale? locale,
}) {
  final child = Directionality(
    textDirection: .ltr,
    child: Align(
      alignment: .topLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 225),
        child: MateoText(
          text,
          presentation: .interface(fontSize: fontSize, fontWeight: fontWeight),
          semanticsLabel: semanticsLabel,
        ),
      ),
    ),
  );
  return locale == null
      ? child
      : Localizations(locale: locale, delegates: const [DefaultWidgetsLocalizations.delegate], child: child);
}

String? _nativeText(WidgetTester tester) => tester.widget<Text>(find.byType(Text)).data;

Future<void> _updateQueue(
  WidgetTester tester, {
  MateoTextInterfaceFontSize? fontSize,
  FontWeight? fontWeight,
  String? semanticsLabel,
}) async {
  for (final reading in [100, 211, 120, 201, 101, 210, 112, 220, 201, 102, 121, 210, 221]) {
    await tester.pumpWidget(
      _host('Queue $reading jobs', fontSize: fontSize, fontWeight: fontWeight, semanticsLabel: semanticsLabel),
    );
    await tester.pump(const Duration(milliseconds: 88));
  }
}

void main() {
  for (final (name, fontSize, fontWeight) in <(String, MateoTextInterfaceFontSize?, FontWeight?)>[
    ('standard interface size', null, null),
    ('body size', .body, null),
    ('medium interface weight', null, .w500),
  ]) {
    testWidgets('a changing queue length settles to native text at the $name', (tester) async {
      await _updateQueue(tester, fontSize: fontSize, fontWeight: fontWeight);
      expect(_nativeText(tester), isNot('Queue 221 jobs'));
      expect(tester.binding.transientCallbackCount, 1);
      final paragraph = tester.renderObject<RenderParagraph>(find.byType(RichText));

      await tester.pumpAndSettle();

      expect(_nativeText(tester), 'Queue 221 jobs');
      expect(tester.renderObject<RenderParagraph>(find.byType(RichText)), same(paragraph));
      expect(tester.binding.transientCallbackCount, 0);
    }, semanticsEnabled: false);
  }

  testWidgets('a change to the number format updates the native child in the same frame', (tester) async {
    await _updateQueue(tester);
    expect(_nativeText(tester), isNot('Queue 221 jobs'));

    await tester.pumpWidget(_host('Queue 99 jobs'));

    expect(_nativeText(tester), 'Queue 99 jobs');
    await tester.pumpAndSettle();
    expect(tester.binding.transientCallbackCount, 0);
  }, semanticsEnabled: false);

  for (final (locale, separator) in const [
    (Locale('en', 'US'), '.'),
    (Locale('en', 'GB'), '.'),
    (Locale('ja', 'JP'), '.'),
    (Locale('pt', 'BR'), ','),
  ]) {
    testWidgets('fixed-width decimal amounts settle to native text in ${locale.toLanguageTag()}', (tester) async {
      final readings = [
        for (final reading in [
          '100',
          '211',
          '120',
          '201',
          '101',
          '210',
          '112',
          '220',
          '201',
          '102',
          '121',
          '210',
          '221',
        ])
          'Total \$ ${reading[0]}$separator${reading.substring(1)}',
      ];
      for (final text in readings) {
        await tester.pumpWidget(_host(text, locale: locale));
        await tester.pump(const Duration(milliseconds: 88));
      }

      final paragraph = tester.renderObject<RenderParagraph>(find.byType(RichText));
      expect(paragraph.locale, locale);
      expect(_nativeText(tester), isNot(readings.last));
      expect(tester.binding.transientCallbackCount, 1);

      await tester.pumpAndSettle();

      expect(_nativeText(tester), readings.last);
      expect(tester.renderObject<RenderParagraph>(find.byType(RichText)), same(paragraph));
      expect(tester.binding.transientCallbackCount, 0);
    }, semanticsEnabled: false);
  }

  for (final (name, locale, prefix, separator) in const [
    ('a negative decimal', Locale('en', 'US'), 'Balance -', '.'),
    ('a dot under a comma locale', Locale('pt', 'BR'), 'Total ', '.'),
    ('a comma under a dot locale', Locale('en', 'US'), 'Total ', ','),
    ('a currency affix attached to the number', Locale('en', 'US'), r'Total $', '.'),
  ]) {
    testWidgets('$name keeps the native text update during motion', (tester) async {
      const readings = ['100', '211', '120', '201', '101', '210', '112', '220', '201', '102', '121', '210', '221'];
      for (final reading in readings) {
        final text = '$prefix${reading[0]}$separator${reading.substring(1)}';
        await tester.pumpWidget(_host(text, locale: locale));
        expect(_nativeText(tester), text);
        await tester.pump(const Duration(milliseconds: 88));
      }
      expect(tester.binding.transientCallbackCount, 1);
      await tester.pumpAndSettle();
      expect(tester.binding.transientCallbackCount, 0);
    }, semanticsEnabled: false);
  }

  testWidgets('turning on accessibility commits the current text and keeps its spoken label', (tester) async {
    await _updateQueue(tester, semanticsLabel: 'Queued jobs');
    expect(_nativeText(tester), isNot('Queue 221 jobs'));

    final semantics = tester.ensureSemantics();
    try {
      await tester.pump(const Duration(milliseconds: 17));
      expect(_nativeText(tester), 'Queue 221 jobs');
      final node = tester.getSemantics(find.bySemanticsLabel('Queued jobs'));

      await tester.pumpWidget(_host('Queue 222 jobs', semanticsLabel: 'Queued jobs'));
      await tester.pumpAndSettle();

      expect(tester.getSemantics(find.bySemanticsLabel('Queued jobs')).id, node.id);
      expect(_nativeText(tester), 'Queue 222 jobs');
    } finally {
      semantics.dispose();
    }
  }, semanticsEnabled: false);
}
