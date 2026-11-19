import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

Widget _labelList(String label, String alternateLabel, {bool reduceMotion = false, bool showAlternate = true}) =>
    Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: MediaQueryData(disableAnimations: reduceMotion),
        child: Align(
          alignment: Alignment.topLeft,
          child: Column(
            children: [
              for (var index = 0; index < 24; index++)
                if (index.isEven || showAlternate)
                  MateoText(
                    index.isEven ? label : alternateLabel,
                    key: ValueKey(index),
                    presentation: const .interface(fontSize: .custom(14)),
                  ),
            ],
          ),
        ),
      ),
    );

({List<ui.Image> created, Set<ui.Image> disposed}) _observeImages() {
  final created = <ui.Image>[];
  final disposed = Set<ui.Image>.identity();
  final previousCreate = ui.Image.onCreate;
  final previousDispose = ui.Image.onDispose;
  ui.Image.onCreate = (image) {
    previousCreate?.call(image);
    created.add(image);
  };
  ui.Image.onDispose = (image) {
    previousDispose?.call(image);
    disposed.add(image);
  };
  addTearDown(() {
    ui.Image.onCreate = previousCreate;
    ui.Image.onDispose = previousDispose;
  });
  return (created: created, disposed: disposed);
}

Future<void> _waitForImages(WidgetTester tester, List<ui.Image> created, int count) async {
  await tester.runAsync(() async {
    final stopwatch = Stopwatch()..start();
    while (created.length < count && stopwatch.elapsed < const Duration(seconds: 3)) {
      await Future<void>.delayed(const Duration(milliseconds: 4));
    }
  });
  expect(created, hasLength(count));
}

void main() {
  testWidgets('three text styles prepare numeral changes together and release images when motion stops', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final (:created, :disposed) = _observeImages();

    const presentations = [
      MateoTextPresentation.interface(color: Color(0xff24212d), fontSize: .custom(14), fontWeight: .w400),
      MateoTextPresentation.interface(color: Color(0xff5b36bb), fontSize: .custom(14), fontWeight: .w400),
      MateoTextPresentation.interface(color: Color(0xff24212d), fontSize: .body, fontWeight: .w400),
    ];
    String label(int style, int value) => switch (style) {
      0 => 'Shelf 1 : $value items',
      1 => 'Total R\$ 1,$value',
      _ => 'Shelf 2 : $value items',
    };
    Widget labels(int value) => Localizations(
      locale: const Locale('pt', 'BR'),
      delegates: const [DefaultWidgetsLocalizations.delegate],
      child: Directionality(
        textDirection: .ltr,
        child: MediaQuery(
          data: const MediaQueryData(),
          child: Column(
            children: [
              for (final (style, presentation) in presentations.indexed)
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: MateoText(label(style, value), presentation: presentation),
                  ),
                ),
            ],
          ),
        ),
      ),
    );

    await tester.pumpWidget(labels(1000));
    expect(created, isEmpty);
    var stylesPreparedTogether = false;
    for (var value = 1001; value < 1021; value++) {
      await tester.pumpWidget(labels(value));
      stylesPreparedTogether |= presentations.indexed.every(
        (entry) => find.text(label(entry.$1, value)).evaluate().isEmpty,
      );
      for (var frame = 0; frame < 7; frame++) {
        await tester.pump(Duration(milliseconds: frame == 6 ? 23 : 17));
      }
    }
    await tester.pumpWidget(labels(1021));
    await tester.pump(const Duration(milliseconds: 80));
    expect(stylesPreparedTogether, isTrue, reason: 'All three native labels stay in place during a prepared update');
    expect(created.any((image) => !disposed.contains(image)), isTrue);

    final semantics = tester.ensureSemantics();
    try {
      await tester.pumpAndSettle();
      for (var style = 0; style < presentations.length; style++) {
        final latest = label(style, 1021);
        expect(find.text(latest), findsOneWidget);
        expect(find.bySemanticsLabel(latest), findsOneWidget);
      }
      expect(disposed, unorderedEquals(created));
      expect(tester.binding.transientCallbackCount, 0);
    } finally {
      semantics.dispose();
    }
  }, semanticsEnabled: false);

  testWidgets('sustained numeral changes release their images when native text returns', (tester) async {
    final (:created, :disposed) = _observeImages();

    Widget label(int count) => Directionality(
      textDirection: .ltr,
      child: Align(
        alignment: .topLeft,
        child: MateoText('Queue $count jobs', presentation: const .interface()),
      ),
    );

    await tester.pumpWidget(label(100));
    expect(created, isEmpty);
    for (final count in [211, 120, 201, 101, 210, 112, 220, 201, 102, 121, 210, 221]) {
      await tester.pumpWidget(label(count));
      await tester.pump(const Duration(milliseconds: 88));
    }
    expect(tester.widget<Text>(find.byType(Text)).data, isNot('Queue 221 jobs'));
    expect(created.any((image) => !disposed.contains(image)), isTrue);

    await tester.pumpAndSettle();

    expect(tester.widget<Text>(find.byType(Text)).data, 'Queue 221 jobs');
    expect(disposed, unorderedEquals(created));
    expect(tester.binding.transientCallbackCount, 0);
  }, semanticsEnabled: false);

  testWidgets('a dense changing list shares a small atlas and releases it at rest', (tester) async {
    tester.view.physicalSize = const Size(1080, 2160);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    const units = [
      'requests',
      'packets',
      'messages',
      'uploads',
      'devices',
      'sessions',
      'alerts',
      'contacts',
      'bookings',
      'tickets',
      'invoices',
      'parcels',
      'reports',
      'widgets',
      'points',
      'votes',
      'queries',
      'records',
      'clients',
      'accounts',
      'vendors',
      'credits',
      'minutes',
      'seconds',
    ];
    String value(int index, int step) => '${400 + index ~/ 2 * 10 + index % 2 + step} ${units[index]}';

    Widget grid(int step) => Localizations(
      locale: const Locale('en', 'US'),
      delegates: const [DefaultWidgetsLocalizations.delegate],
      child: Directionality(
        textDirection: .ltr,
        child: Column(
          children: [
            for (var row = 0; row < units.length ~/ 2; row++)
              Expanded(
                child: Row(
                  children: [
                    for (var column = 0; column < 2; column++)
                      Expanded(
                        child: Align(
                          child: MateoText(
                            value(row * 2 + column, step),
                            presentation: const .interface(fontSize: .custom(14)),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );

    final (:created, :disposed) = _observeImages();
    const lastUpdate = 11;
    for (var step = 0; step <= lastUpdate; step++) {
      await tester.pumpWidget(grid(step));
      for (var frame = 0; frame < 8; frame++) {
        await tester.pump(const Duration(milliseconds: 16));
      }
    }
    final activeAtlasPixels = created
        .where((image) => !disposed.contains(image))
        .fold(0, (pixels, image) => pixels + image.width * image.height);
    expect(activeAtlasPixels, inExclusiveRange(0, 1024 * 1024));
    expect(find.text(value(0, lastUpdate)), findsNothing);

    await tester.pumpAndSettle();

    for (var index = 0; index < units.length; index++) {
      expect(find.text(value(index, lastUpdate)), findsOneWidget);
    }
    expect(disposed, unorderedEquals(created));
    expect(tester.binding.transientCallbackCount, 0);
  }, semanticsEnabled: false);

  testWidgets('a cached mixed-weight list bounds its atlases and releases them at rest', (tester) async {
    tester.view.physicalSize = const Size(1080, 2160);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    const visible = 6;
    const cachePixels = 600.0;
    const rowExtent = 30.0;

    String value(int row, int step) => 'Lista ${row + 1}: ${1000 + row * 3 + step} itens na lista';
    Widget list(int step, double cachePixels) => Directionality(
      textDirection: .ltr,
      child: Center(
        child: SizedBox(
          width: 340,
          height: visible * rowExtent,
          child: ListView.builder(
            itemCount: 36,
            itemExtent: rowExtent,
            scrollCacheExtent: ScrollCacheExtent.pixels(cachePixels),
            itemBuilder: (context, row) => Align(
              alignment: Alignment.centerLeft,
              child: MateoText(
                value(row, step),
                presentation: .interface(
                  color: const Color(0xff24212d),
                  fontSize: const .custom(14),
                  fontWeight: row.isEven ? .w400 : .w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    final (:created, :disposed) = _observeImages();
    Future<int> createdAtlasArea(double cachePixels, int mounted) async {
      final before = created.length;
      await tester.pumpWidget(list(0, cachePixels));
      expect(find.byType(MateoText, skipOffstage: false), findsNWidgets(mounted));
      expect(created, hasLength(before));

      await tester.pumpWidget(list(1, cachePixels));
      await tester.pump(const Duration(milliseconds: 16));
      final images = created.skip(before).toList();
      expect(images.any((image) => !disposed.contains(image)), isTrue);
      final area = images.fold(0, (pixels, image) => pixels + image.width * image.height);

      await tester.pumpAndSettle();
      expect(find.text(value(0, 1)), findsOneWidget);
      expect(disposed, unorderedEquals(created));
      expect(tester.binding.transientCallbackCount, 0);
      await tester.pumpWidget(const SizedBox.shrink());
      return area;
    }

    final visibleArea = await createdAtlasArea(0, visible);
    final cachedArea = await createdAtlasArea(cachePixels, 26);
    expect(
      cachedArea,
      lessThan(visibleArea * 2),
      reason: 'The same six visible rows should fit within twice their uncached atlas area.',
    );

    Future<void> update(int step) async {
      await tester.pumpWidget(list(step, cachePixels));
      for (var frame = 0; frame < 7; frame++) {
        await tester.pump(Duration(milliseconds: frame == 6 ? 23 : 17));
      }
    }

    await tester.pumpWidget(list(0, cachePixels));
    for (var step = 1; step <= 28; step++) {
      await update(step);
    }

    // Prepared pages serve the whole warm interval. Ordinary pages expire
    // as each update replaces their source and destination strings.
    final warmImages = created.where((image) => !disposed.contains(image)).toList();
    const lastStep = 35;
    for (var step = 29; step <= lastStep; step++) {
      await update(step);
      for (var row = 0; row < visible; row++) {
        expect(
          find.text(value(row, step)),
          findsNothing,
          reason: 'Both weights keep their native child during each prepared update.',
        );
      }
    }
    final preparedPixels = warmImages
        .where((image) => !disposed.contains(image))
        .fold(0, (pixels, image) => pixels + image.width * image.height);

    await tester.pumpAndSettle();
    expect(
      preparedPixels,
      inExclusiveRange(0, 640 * 1024),
      reason: 'The two prepared styles fit within 2.5 MiB of RGBA backing.',
    );
    for (var row = 0; row < visible; row++) {
      expect(find.text(value(row, lastStep)), findsOneWidget);
    }
    expect(disposed, unorderedEquals(created));
    expect(tester.binding.transientCallbackCount, 0);
  }, semanticsEnabled: false);

  testWidgets('distinct labels share an image until their last transition stops', (tester) async {
    final (:created, :disposed) = _observeImages();

    await tester.pumpWidget(_labelList('10 segundos', r'Total R$ 1,00'));
    expect(created, isEmpty);

    await tester.pumpWidget(_labelList('1 segundo', r'Total R$ 9,90'));
    await tester.pump(const Duration(milliseconds: 16));
    await _waitForImages(tester, created, 1);
    await tester.pump();
    expect(disposed, isEmpty);

    await tester.pumpWidget(_labelList('1 segundo', r'Total R$ 9,90', showAlternate: false));
    expect(disposed, isEmpty);

    await tester.pumpWidget(_labelList('1 segundo', r'Total R$ 9,90', showAlternate: false, reduceMotion: true));
    expect(disposed, unorderedEquals(created));
    expect(tester.binding.transientCallbackCount, 0);

    // The raster thread can finish an atlas request after its label unmounts.
    await tester.pumpWidget(const SizedBox());
    await tester.pumpWidget(_labelList('10 segundos', r'Total R$ 1,00'));
    await tester.pumpWidget(_labelList('1 segundo', r'Total R$ 9,90'));
    await tester.pumpWidget(const SizedBox());

    await _waitForImages(tester, created, 2);
    await tester.pump();
    expect(disposed, unorderedEquals(created));
    expect(tester.binding.transientCallbackCount, 0);
  });

  testWidgets('a settled label reuses its picture until the system fonts change', (tester) async {
    Widget label(String text) => Directionality(
      textDirection: TextDirection.ltr,
      child: Align(
        alignment: Alignment.topLeft,
        child: MateoText(text, presentation: const .interface(fontSize: .custom(14))),
      ),
    );

    var picturesCreated = 0;
    var picturesDisposed = 0;
    final previousCreate = ui.Picture.onCreate;
    final previousDispose = ui.Picture.onDispose;
    ui.Picture.onCreate = (picture) {
      previousCreate?.call(picture);
      picturesCreated++;
    };
    ui.Picture.onDispose = (picture) {
      previousDispose?.call(picture);
      picturesDisposed++;
    };
    addTearDown(() {
      ui.Picture.onCreate = previousCreate;
      ui.Picture.onDispose = previousDispose;
    });

    await tester.pumpWidget(label('11 seconds'));
    await tester.pumpWidget(label('12 seconds'));
    await tester.pumpAndSettle();

    final beforeWarmUpdate = picturesCreated;
    await tester.pumpWidget(label('11 seconds'));
    final warmUpdatePictures = picturesCreated - beforeWarmUpdate;
    await tester.pumpAndSettle();

    final beforeFontsChange = picturesDisposed;
    await tester.binding.handleSystemMessage(<String, Object>{'type': 'fontsChange'});
    expect(picturesDisposed, greaterThan(beforeFontsChange));

    await tester.pumpWidget(const SizedBox());
    await tester.pumpWidget(label('12 seconds'));
    final beforeColdUpdate = picturesCreated;
    await tester.pumpWidget(label('11 seconds'));
    final coldUpdatePictures = picturesCreated - beforeColdUpdate;

    expect(warmUpdatePictures, coldUpdatePictures - 1);
    await tester.pumpAndSettle();
  });

  testWidgets('a repeated destination reuses geometry after its atlas is released', (tester) async {
    const returning = '9 itens disponíveis';
    const other = '10 itens disponíveis';

    Widget label(String text) => Directionality(
      textDirection: TextDirection.ltr,
      child: Align(
        alignment: Alignment.topLeft,
        child: MateoText(text, presentation: const .interface(fontSize: .custom(14))),
      ),
    );

    final (:created, :disposed) = _observeImages();
    var picturesCreated = 0;
    final previousCreate = ui.Picture.onCreate;
    ui.Picture.onCreate = (picture) {
      previousCreate?.call(picture);
      picturesCreated++;
    };
    addTearDown(() => ui.Picture.onCreate = previousCreate);

    Future<void> advancePastDeparture() async {
      await tester.pump(const Duration(milliseconds: 16));
      await tester.pump(const Duration(milliseconds: 200));
    }

    await tester.pumpWidget(label('8 itens disponíveis'));
    await tester.pumpWidget(label(returning));
    await _waitForImages(tester, created, 1);
    final firstAtlas = created.single;
    await tester.pump(const Duration(milliseconds: 100));

    await tester.pumpWidget(label(other));
    await advancePastDeparture();
    expect(disposed, contains(firstAtlas));

    final beforeFirstReturn = picturesCreated;
    await tester.pumpWidget(label(returning));
    final firstReturnPictures = picturesCreated - beforeFirstReturn;
    await advancePastDeparture();
    await tester.pumpWidget(label(other));
    await advancePastDeparture();

    final beforeNextReturn = picturesCreated;
    await tester.pumpWidget(label(returning));
    expect(picturesCreated - beforeNextReturn, firstReturnPictures - 1);

    await tester.pumpAndSettle();
    expect(find.text(returning), findsOneWidget);
    expect(disposed, unorderedEquals(created));
    expect(tester.binding.transientCallbackCount, 0);
  });

  testWidgets('a former departure can become a full destination and release its cropped page', (tester) async {
    const before = '7 items';
    const after = '8 items';
    const unrelated = '3 boxes';
    const presentation = MateoTextPresentation.interface(fontSize: .custom(14));

    Widget labels(String first, String second, {bool showFirst = true}) => Directionality(
      textDirection: TextDirection.ltr,
      child: Align(
        alignment: Alignment.topLeft,
        child: Column(
          children: [
            if (showFirst) MateoText(first, key: const ValueKey('first'), presentation: presentation),
            MateoText(second, key: const ValueKey('second'), presentation: presentation),
          ],
        ),
      ),
    );

    final (:created, :disposed) = _observeImages();

    await tester.pumpWidget(labels(before, unrelated));
    await tester.pumpWidget(labels(after, unrelated));
    await _waitForImages(tester, created, 1);
    await tester.pump(const Duration(milliseconds: 16));
    final departurePage = created.single;

    await tester.pumpWidget(labels(after, before));
    await _waitForImages(tester, created, 2);
    await tester.pump(const Duration(milliseconds: 16));
    expect(disposed, isEmpty);

    await tester.pumpWidget(labels(after, before, showFirst: false));
    expect(disposed, unorderedEquals([departurePage]));
    expect(tester.binding.transientCallbackCount, 1);

    await tester.pumpAndSettle();
    expect(disposed, unorderedEquals(created));
    expect(tester.binding.transientCallbackCount, 0);
  });

  testWidgets('a departed paragraph releases its atlas after the last glyph fades', (tester) async {
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.resetDevicePixelRatio);

    Widget label(String text) => Directionality(
      textDirection: TextDirection.ltr,
      child: Align(
        alignment: Alignment.topLeft,
        child: MateoText(text, presentation: const .interface(fontSize: .custom(14))),
      ),
    );

    final (:created, :disposed) = _observeImages();
    await tester.pumpWidget(label(List.filled(12, 'W').join('\n')));
    await tester.pumpWidget(label('A'));
    await _waitForImages(tester, created, 2);
    final source = created.first.height > created.last.height ? created.first : created.last;
    expect(disposed, isEmpty);

    await tester.pump(const Duration(milliseconds: 200));
    expect(disposed, unorderedEquals([source]));
    expect(tester.binding.transientCallbackCount, 1);

    await tester.pumpAndSettle();
    expect(disposed, unorderedEquals(created));
    expect(find.text('A'), findsOneWidget);
    expect(tester.binding.transientCallbackCount, 0);
  });
}
