import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';
import 'package:mateo_mobile/src/components/mateo_text/mateo_text.dart' show MateoTextScope;

const _ambient = TextStyle(fontSize: 19, fontWeight: .w600, height: 1.4, color: Color(0xFF342050));

Widget _host(Widget child, {TextStyle style = _ambient, double scale = 1, TextDirection direction = .ltr}) =>
    Directionality(
      textDirection: direction,
      child: MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(scale)),
        child: MateoTextScope(
          fontSize: style.fontSize,
          fontWeight: style.fontWeight,
          color: style.color,
          height: style.height,
          child: Center(child: SizedBox(width: 220, child: child)),
        ),
      ),
    );

RenderParagraph _paragraph(WidgetTester tester) => tester.renderObject<RenderParagraph>(find.byType(RichText));

void main() {
  testWidgets('interface inherits typography while selecting Inter and its tracking', (tester) async {
    await tester.pumpWidget(_host(const MateoText('Olá, São Paulo', presentation: .interface())));
    final style = _paragraph(tester).text.style!;
    expect(style.fontFamily, MateoTypography.interfaceFontFamily);
    expect(style.letterSpacing, -0.38);
    expect(style.fontSize, _ambient.fontSize);
    expect(style.fontWeight, _ambient.fontWeight);
    expect(style.color, _ambient.color);
    expect(style.height, _ambient.height);
  });

  testWidgets('interface applies explicit typography and updates content', (tester) async {
    const presentation = MateoTextPresentation.interface(
      fontSize: 23,
      fontWeight: .w500,
      color: Color(0xFF153040),
      height: 1.2,
      leadingDistribution: .even,
    );
    await tester.pumpWidget(_host(const MateoText('Antes', presentation: presentation)));
    await tester.pumpWidget(_host(const MateoText('Depois', presentation: presentation)));
    final paragraph = _paragraph(tester);
    expect(paragraph.text.toPlainText(), 'Depois');
    expect(paragraph.text.style!.fontSize, 23);
    expect(paragraph.text.style!.letterSpacing, -0.46);
    expect(paragraph.text.style!.fontWeight, FontWeight.w500);
    expect(paragraph.text.style!.color, const Color(0xFF153040));
    expect(paragraph.text.style!.height, 1.2);
    expect(paragraph.text.style!.leadingDistribution, TextLeadingDistribution.even);
  });

  testWidgets('line limits, ellipsis, alignment and wrapping follow the requested layout', (tester) async {
    const text = 'Uma oportunidade perto de você para começar hoje mesmo';
    await tester.pumpWidget(
      _host(
        const MateoText(
          text,
          presentation: .interface(
            maxLines: 1,
            overflow: .ellipsis,
            textAlign: .end,
          ),
        ),
      ),
    );
    final paragraph = _paragraph(tester);
    expect(paragraph.didExceedMaxLines, isTrue);
    expect(paragraph.maxLines, 1);
    expect(paragraph.overflow, TextOverflow.ellipsis);
    expect(paragraph.textAlign, TextAlign.end);
    final singleLineHeight = paragraph.size.height;
    await tester.pumpWidget(_host(const MateoText(text, presentation: .interface())));
    expect(_paragraph(tester).size.height, greaterThan(singleLineHeight));
    await tester.pumpWidget(
      _host(
        const MateoText(
          text,
          presentation: .interface(
            softWrap: false,
          ),
        ),
      ),
    );
    expect(_paragraph(tester).softWrap, isFalse);
    expect(_paragraph(tester).size.height, singleLineHeight);
  });

  for (final (variant, family) in [
    (MateoDecorativeTextVariant.rounded, MateoTypography.decorativeRoundedFontFamily),
    (MateoDecorativeTextVariant.cursive, MateoTypography.decorativeCursiveFontFamily),
  ]) {
    testWidgets('$variant inherits scoped weight and line height while retaining its own face and tracking', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          MateoText('Olá, coração! Ação e café.', presentation: .decorative(variant: variant, fontSize: 32)),
          style: _ambient.copyWith(
            fontStyle: .italic,
            fontWeight: .w900,
            letterSpacing: 6,
            wordSpacing: 12,
            height: 3,
            decoration: .underline,
          ),
        ),
      );
      final style = _paragraph(tester).text.style!;
      expect(style.fontFamily, family);
      expect(style.fontSize, 32);
      expect(style.fontWeight, FontWeight.w900);
      expect(style.fontStyle, FontStyle.normal);
      expect(style.letterSpacing, 0);
      expect(style.wordSpacing, isNull);
      expect(style.height, 3);
      expect(style.decoration, isNull);
      expect(style.color, _ambient.color);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('decorative color can be chosen explicitly', (tester) async {
    await tester.pumpWidget(
      _host(
        const MateoText(
          'Olá',
          presentation: .decorative(variant: .rounded, fontSize: 30, color: Color(0xFF125032)),
        ),
      ),
    );
    expect(_paragraph(tester).text.style!.color, const Color(0xFF125032));
  });

  testWidgets('text retains ambient direction, locale and accessibility scaling', (tester) async {
    for (final presentation in <MateoTextPresentation>[
      const .interface(fontSize: 30),
      const .decorative(variant: .cursive, fontSize: 30),
    ]) {
      await tester.pumpWidget(
        _host(
          Localizations(
            locale: const Locale('pt', 'BR'),
            delegates: const [DefaultWidgetsLocalizations.delegate],
            child: MateoText('Olá', presentation: presentation),
          ),
        ),
      );
      expect(_paragraph(tester).locale, const Locale('pt', 'BR'));
      final initialHeight = _paragraph(tester).size.height;
      await tester.pumpWidget(_host(MateoText('Olá', presentation: presentation), scale: 2, direction: .rtl));
      expect(_paragraph(tester).textDirection, TextDirection.rtl);
      expect(_paragraph(tester).size.height, greaterThan(initialHeight));
      if (presentation == const MateoTextPresentation.interface(fontSize: 30)) {
        expect(_paragraph(tester).text.style!.letterSpacing, -1.2);
      }
    }
  });

  testWidgets('an alternate semantic label is announced once', (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      _host(
        const MateoText(
          'Olá',
          presentation: .decorative(variant: .rounded, fontSize: 30),
          semanticsLabel: 'Boas-vindas',
        ),
      ),
    );
    expect(find.bySemanticsLabel('Boas-vindas'), findsOneWidget);
    expect(find.bySemanticsLabel('Olá'), findsNothing);
    semantics.dispose();
  });
  testWidgets('nested defaults update, explicit fields win and fresh scopes reset', (tester) async {
    Future<void> render(double size) => tester.pumpWidget(
      _host(
        MateoTextScope(
          fontSize: size,
          textAlign: .end,
          child: const MateoTextScope(
            color: Color(0xFF123456),
            child: MateoText('Nested', presentation: .interface(fontWeight: .w300)),
          ),
        ),
      ),
    );
    await render(24);
    expect(_paragraph(tester).text.style!.fontSize, 24);
    expect(_paragraph(tester).text.style!.fontWeight, FontWeight.w300);
    expect(_paragraph(tester).text.style!.height, 1.4);
    expect(_paragraph(tester).text.style!.color, const Color(0xFF123456));
    expect(_paragraph(tester).textAlign, TextAlign.end);
    await render(28);
    expect(_paragraph(tester).text.style!.fontSize, 28);
    await tester.pumpWidget(
      _host(
        const MateoTextScope(
          inherit: false,
          child: MateoText('Fresh', presentation: .decorative(variant: .rounded)),
        ),
      ),
    );
    final style = _paragraph(tester).text.style!;
    expect(style.fontSize, 14);
    expect(style.fontWeight, FontWeight.w600);
    expect(style.height, isNull);
  });

  testWidgets('both decorative variants inherit scoped size', (tester) async {
    for (final variant in MateoDecorativeTextVariant.values) {
      await tester.pumpWidget(_host(MateoText('Ação', presentation: .decorative(variant: variant))));
      expect(_paragraph(tester).text.style!.fontSize, 19);
      expect(_paragraph(tester).text.style!.fontWeight, FontWeight.w600);
      expect(_paragraph(tester).text.style!.height, 1.4);
    }
  });

  testWidgets('native and Mateo defaults remain isolated in both directions', (tester) async {
    await tester.pumpWidget(
      _host(
        const DefaultTextStyle(
          style: TextStyle(fontSize: 60, color: Color(0xFFFF0000), fontStyle: .italic, letterSpacing: 8),
          maxLines: 1,
          softWrap: false,
          textAlign: .right,
          child: Column(
            children: [
              MateoText('Mateo', presentation: .interface()),
              Text('Native'),
            ],
          ),
        ),
      ),
    );
    final paragraphs = tester.renderObjectList<RenderParagraph>(find.byType(RichText)).toList();
    expect(paragraphs[0].text.style!.fontSize, 19);
    expect(paragraphs[0].text.style!.fontStyle, isNull);
    expect(paragraphs[0].text.style!.color, _ambient.color);
    expect(paragraphs[0].textAlign, TextAlign.start);
    expect(paragraphs[0].maxLines, isNull);
    expect(paragraphs[0].softWrap, isTrue);
    expect(paragraphs[1].text.style!.fontSize, 60);
    expect(paragraphs[1].text.style!.color, const Color(0xFFFF0000));
  });

  testWidgets('menu defaults are consumed by decorative and interface text', (tester) async {
    final theme = MateoThemeData.light(accentColor: const Color(0xFF4A5CFF), onAccent: MateoPalette().white);
    await tester.pumpWidget(
      _host(
        MateoTheme(
          data: theme,
          child: MateoMenu(
            presentation: .options(
              items: const [
                MateoMenuOptionsPresentationItem(
                  principal: MateoText('Título', presentation: .decorative(variant: .rounded)),
                  supporting: MateoText('Detalhes', presentation: .interface()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    final paragraphs = tester.renderObjectList<RenderParagraph>(find.byType(RichText)).toList();
    expect(paragraphs[0].text.style!.fontFamily, MateoTypography.decorativeRoundedFontFamily);
    expect(paragraphs[0].text.style!.fontSize, 16);
    expect(paragraphs[0].text.style!.fontWeight, FontWeight.w600);
    expect(paragraphs[0].text.style!.height, 1.4);
    expect(paragraphs[0].text.style!.letterSpacing, 0);
    expect(paragraphs[0].text.style!.color, theme.colorScheme.menus.options.principal);
    expect(paragraphs[1].text.style!.fontFamily, MateoTypography.interfaceFontFamily);
    expect(paragraphs[1].text.style!.fontSize, 14);
    expect(paragraphs[1].text.style!.fontWeight, FontWeight.w500);
    expect(paragraphs[1].text.style!.letterSpacing, -0.28);
  });

  for (final variant in MateoDecorativeTextVariant.values) {
    testWidgets('when $variant is constrained, it should apply its presentation layout', (tester) async {
      await tester.pumpWidget(
        _host(
          MateoText(
            'Uma oportunidade perto de você para começar hoje mesmo',
            presentation: .decorative(
              variant: variant,
              fontSize: 32,
              textAlign: .center,
              maxLines: 1,
              overflow: .ellipsis,
              softWrap: false,
            ),
          ),
        ),
      );
      final paragraph = _paragraph(tester);
      expect(paragraph.didExceedMaxLines, isTrue);
      expect(paragraph.maxLines, 1);
      expect(paragraph.overflow, TextOverflow.ellipsis);
      expect(paragraph.textAlign, TextAlign.center);
      expect(paragraph.softWrap, isFalse);
    });
  }
}
