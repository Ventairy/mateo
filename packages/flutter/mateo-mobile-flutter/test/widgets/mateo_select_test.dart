import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart' show SemanticsAction;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile_old/mateo_mobile_old.dart';

import '../test_app.dart';

const _panelKey = Key('mateo_select_panel');
const _sourceKey = Key('mateo_select_source');

void main() {
  group('MateoSelect', () {
    testWidgets('when disposal interrupts selection layout, it should still report the accepted value once', (
      tester,
    ) async {
      final selected = <String>[];
      var completed = false;
      await _pumpSelect(
        tester,
        onSelected: (value, animation) async {
          selected.add(value);
          await animation;
          expectSync(find.byKey(_panelKey), findsNothing);
          completed = true;
        },
      );
      await _openSelect(tester);
      final tap = tester.widget<MateoTap>(
        find.descendant(of: _optionSemantics('range'), matching: find.byType(MateoTap)),
      );
      unawaited(Future<void>.sync(() => tap.onPressed!(Future<void>.value())));
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
      expect(selected, ['range']);
      expect(completed, isTrue);
      expect(tester.takeException(), isNull);
    });

    testWidgets('when reduced motion interrupts pending press feedback, it should remove the menu without waiting', (
      tester,
    ) async {
      final feedback = Completer<void>();
      var reduceMotion = false;
      var completed = false;
      late StateSetter rebuild;
      await _pumpHost(
        tester,
        builder: (context) => StatefulBuilder(
          builder: (context, setState) {
            rebuild = setState;
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(disableAnimations: reduceMotion),
              child: MateoSelect<String>(
                options: _options(),
                initialValue: 'fixed',
                presentation: const MateoSelectPresentation.neutral(),
                onSelected: (value, animation) async {
                  await animation;
                  expectSync(find.byKey(_panelKey), findsNothing);
                  completed = true;
                },
              ),
            );
          },
        ),
      );
      await _openSelect(tester);
      final tap = tester.widget<MateoTap>(
        find.descendant(of: _optionSemantics('range'), matching: find.byType(MateoTap)),
      );
      unawaited(Future<void>.sync(() => tap.onPressed!(feedback.future)));
      await tester.pump();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));
      await tester.pump();
      expect(find.byKey(_panelKey), findsOneWidget);
      expect(completed, isFalse);
      rebuild(() => reduceMotion = true);
      await tester.pumpAndSettle();
      expect(feedback.isCompleted, isFalse);
      expect(find.byKey(_panelKey), findsNothing);
      expect(completed, isTrue);
      feedback.complete();
      await tester.pump();
    });

    testWidgets('when selection is awaited, it should finish after removal without waiting for consumer work', (
      tester,
    ) async {
      final consumerWork = Completer<void>();
      final values = <String>[];
      var closed = false;
      await _pumpSelect(
        tester,
        onSelected: (value, animation) async {
          values.add(value);
          await animation;
          closed = true;
          await consumerWork.future;
        },
      );
      await _openSelect(tester);
      await tester.tap(_optionSemantics('range'));
      await tester.pump();
      expect(values, ['range']);
      expect(closed, isFalse);
      expect(find.byKey(_panelKey), findsOneWidget);
      await tester.pumpAndSettle();
      expect(closed, isTrue);
      expect(find.byKey(_panelKey), findsNothing);
      expect(consumerWork.isCompleted, isFalse);
      consumerWork.complete();
      await tester.pump();
    });

    testWidgets('when a selection disposes its control, it should complete the animation future', (tester) async {
      var show = true;
      var completed = false;
      await _pumpHost(
        tester,
        builder: (context) => StatefulBuilder(
          builder: (context, setState) => show
              ? MateoSelect<String>(
                  initialValue: 'fixed',
                  options: _options(),
                  presentation: const MateoSelectPresentation.neutral(),
                  onSelected: (value, animation) async {
                    setState(() => show = false);
                    await animation;
                    completed = true;
                  },
                )
              : const SizedBox.shrink(),
        ),
      );
      await _openSelect(tester);
      await tester.tap(_optionSemantics('range'));
      await tester.pumpAndSettle();
      expect(completed, isTrue);
      expect(find.byKey(_panelKey), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('when multiple selections share a reopened menu, it should complete every pending future once', (
      tester,
    ) async {
      final selected = <String>[];
      final completed = <String>[];
      await _pumpSelect(
        tester,
        onSelected: (value, animation) async {
          selected.add(value);
          await animation;
          completed.add(value);
        },
      );
      final sourceCenter = tester.getCenter(find.byKey(_sourceKey));
      await _openSelect(tester);
      await tester.tap(_optionSemantics('range'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      await tester.tapAt(sourceCenter);
      await tester.pumpAndSettle();
      expect(completed, isEmpty);
      await tester.tap(_optionSemantics('flexible'));
      await tester.pumpAndSettle();
      expect(selected, ['range', 'flexible']);
      expect(completed, selected);
      await _openSelect(tester);
      await tester.tapAt(const Offset(390, 400));
      await tester.pumpAndSettle();
      expect(completed, ['range', 'flexible']);
    });

    testWidgets('when reduced motion selects the current value, it should complete its future once', (tester) async {
      final completed = <String>[];
      await _pumpSelect(
        tester,
        disableAnimations: true,
        onSelected: (value, animation) async {
          await animation;
          completed.add(value);
        },
      );
      await _openSelect(tester);
      await tester.tap(_optionSemantics('fixed'));
      await tester.pumpAndSettle();
      expect(completed, ['fixed']);
      expect(find.byKey(_panelKey), findsNothing);
    });

    testWidgets('when dismissed without selection, it should never call onSelected', (tester) async {
      var calls = 0;
      await _pumpSelect(tester, onSelected: (value, animation) => calls += 1);
      for (final dismiss in <Future<void> Function()>[
        () => tester.tapAt(const Offset(390, 400)),
        () async {
          await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        },
        () async {
          await tester.binding.handlePopRoute();
        },
      ]) {
        await _openSelect(tester);
        await dismiss();
        await tester.pumpAndSettle();
        expect(find.byKey(_panelKey), findsNothing);
      }
      expect(calls, 0);
    });

    testWidgets('when ghost opens, it should interpolate foreground into independently themed menu colors', (
      tester,
    ) async {
      final closed = mateoTestColorScheme.select.ghost.copyWith(
        title: mateoTestPalette.accent[11],
        icon: mateoTestPalette.accent[10],
      );
      final menu = mateoTestColorScheme.menu.action.copyWith(
        title: mateoTestPalette.green[11],
        icon: mateoTestPalette.green[10],
        description: mateoTestPalette.green[9],
        scrim: mateoTestPalette.neutral[12].withValues(alpha: 0.25),
      );
      final theme = mateoTestTheme.copyWith(
        extensions: [
          mateoTestThemeData.copyWith(
            colorScheme: mateoTestColorScheme.copyWith(menu: mateoTestColorScheme.menu.copyWith(action: menu)),
          ),
        ],
      );
      await _pumpSelect(
        tester,
        theme: theme,
        presentation: MateoSelectPresentation.ghost(colorScheme: closed),
        options: _options(withDescriptions: true),
      );
      expect((tester.widget<Container>(find.byKey(_sourceKey)).decoration! as BoxDecoration).color, Colors.transparent);
      expect(tester.widget<Text>(_inSource('Fixed price')).style!.color, closed.title);
      await tester.tap(find.byKey(_sourceKey));
      await tester.pump();
      await tester.pump();
      final movingTitle = find.descendant(
        of: find.byKey(const ValueKey<Object>(('mateo_select_option', 'fixed'))),
        matching: find.text('Fixed price'),
      );
      expect(tester.widget<Text>(movingTitle).style!.color, closed.title);
      await tester.pump(const Duration(milliseconds: 80));
      final midway = tester.widget<Text>(movingTitle).style!.color;
      expect(midway, isNot(closed.title));
      expect(midway, isNot(menu.title));
      await tester.pumpAndSettle();
      expect(tester.widget<Text>(movingTitle).style!.color, menu.title);
      final movingIcon = find.descendant(
        of: find.byKey(const ValueKey<Object>(('mateo_select_option', 'fixed'))),
        matching: find.byType(Icon),
      );
      expect(tester.widget<Icon>(movingIcon).color, menu.icon);
      expect(tester.widget<Text>(find.text('Pay between two values.')).style!.color, menu.description);
      expect(
        tester.widget<AnimatedModalBarrier>(find.byKey(const Key('mateo_select_barrier'))).color.value,
        menu.scrim,
      );
      await tester.tapAt(const Offset(390, 400));
      await tester.pumpAndSettle();
      expect(tester.widget<Text>(_inSource('Fixed price')).style!.color, closed.title);
    });

    test('when presentations update, it should preserve only matching treatments', () {
      const neutral = MateoSelectPresentation.neutral();
      const ghost = MateoSelectPresentation.ghost();
      final overridden = MateoSelectPresentation.neutral(colorScheme: mateoTestColorScheme.select.neutral);

      expect(neutral, isA<StatefulWidget>());
      expect(neutral.colorScheme, isNull);
      expect(overridden.colorScheme, mateoTestColorScheme.select.neutral);
      expect(Widget.canUpdate(neutral, overridden), isTrue);
      expect(Widget.canUpdate(neutral, ghost), isFalse);
    });

    test(
      'when fewer than two options are provided, it should reject the list',
      () {
        expect(
          () => MateoSelect<String>(
            presentation: const MateoSelectPresentation.neutral(),
            onSelected: (value, animation) {},
            initialValue: 'fixed',
            options: [_option('fixed', 'Fixed price')],
          ),
          throwsAssertionError,
        );
      },
    );

    test('when item values repeat, it should reject the list', () {
      expect(
        () => MateoSelect<String>(
          presentation: const MateoSelectPresentation.neutral(),
          onSelected: (value, animation) {},
          initialValue: 'fixed',
          options: [
            _option('fixed', 'Fixed price'),
            _option('fixed', 'Another fixed price'),
          ],
        ),
        throwsAssertionError,
      );
    });

    test('when initialValue matches no item, it should reject the value', () {
      expect(
        () => MateoSelect<String>(
          presentation: const MateoSelectPresentation.neutral(),
          onSelected: (value, animation) {},
          initialValue: 'missing',
          options: _options(),
        ),
        throwsAssertionError,
      );
    });

    test('when option text is empty, it should reject inaccessible content', () {
      expect(
        () => MateoSelectOption<String>(
          value: 'empty-title',
          title: '',
          iconBuilder: (_) => const SizedBox.shrink(),
        ),
        throwsAssertionError,
      );
      expect(
        () => MateoSelectOption<String>(
          value: 'empty-description',
          title: 'Title',
          description: '',
          iconBuilder: (_) => const SizedBox.shrink(),
        ),
        throwsAssertionError,
      );
    });

    test('when the caller mutates its list, it should preserve the widget snapshot', () {
      final options = _options();
      final select = MateoSelect<String>(
        presentation: const MateoSelectPresentation.neutral(),
        onSelected: (value, animation) {},
        initialValue: 'fixed',
        options: options,
      );

      options.removeLast();

      expect(select.options, hasLength(4));
      expect(select.options.removeLast, throwsUnsupportedError);
    });

    testWidgets(
      'when first built, it should show initialValue and expose its builder state',
      (tester) async {
        final states = <MateoSelectState>[];
        await _pumpSelect(
          tester,
          initialValue: 'range',
          options: _options(onBuild: states.add),
        );

        expect(_inSource('Range'), findsOneWidget);
        expect(_inSource('Fixed price'), findsNothing);
        expect(
          states,
          contains(
            isA<MateoSelectState>()
                .having((state) => state.iconSize, 'iconSize', 22)
                .having(
                  (state) => state.recommendedIconColor,
                  'recommendedIconColor',
                  mateoTestColorScheme.select.neutral.icon,
                ),
          ),
        );
      },
    );

    testWidgets('when accessibility activates the control, it should open and select an option', (tester) async {
      final semantics = tester.ensureSemantics();
      try {
        var calls = 0;
        await _pumpSelect(
          tester,
          onSelected: (value, animation) => calls += 1,
        );

        final source = tester.getSemantics(find.byKey(const Key('mateo_select_source_semantics')));
        source.owner!.performAction(source.id, SemanticsAction.tap);
        await tester.pumpAndSettle();

        final option = tester.getSemantics(_optionSemantics('range'));
        option.owner!.performAction(option.id, SemanticsAction.tap);
        await tester.pumpAndSettle();

        expect(_inSource('Range'), findsOneWidget);
        expect(calls, 1);
      } finally {
        semantics.dispose();
      }
    });

    testWidgets('when no modal route exists, it should report the required host contract', (tester) async {
      await tester.pumpWidget(
        Theme(
          data: mateoTestTheme,
          child: MediaQuery(
            data: const MediaQueryData(size: Size(400, 800)),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Center(
                child: MateoSelect<String>(
                  presentation: const MateoSelectPresentation.neutral(),
                  onSelected: (value, animation) {},
                  initialValue: 'fixed',
                  options: _options(),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(_sourceKey));

      expect(
        tester.takeException(),
        isA<FlutterError>().having(
          (error) => error.message,
          'message',
          'MateoSelect requires a ModalRoute ancestor.',
        ),
      );
    });

    testWidgets('when values are nullable, it should preserve null as a valid identity', (tester) async {
      var calls = 0;
      await _pumpHost(
        tester,
        builder: (context) => MateoSelect<String?>(
          presentation: const MateoSelectPresentation.neutral(),
          onSelected: (value, animation) => calls += 1,
          initialValue: null,
          options: [
            MateoSelectOption<String?>(
              value: null,
              title: 'Not specified',
              iconBuilder: (_) => const Icon(Icons.remove),
            ),
            MateoSelectOption<String?>(
              value: 'fixed',
              title: 'Fixed price',
              iconBuilder: (_) => const Icon(Icons.attach_money),
            ),
          ],
        ),
      );

      expect(_inSource('Not specified'), findsOneWidget);
      await _openSelect(tester);
      await tester.tap(_optionSemantics('fixed'));
      await tester.pumpAndSettle();
      expect(_inSource('Fixed price'), findsOneWidget);
      expect(calls, 1);
    });

    testWidgets(
      'when opened, it should preserve caller order regardless of selection',
      (tester) async {
        await _pumpSelect(tester);

        await _openSelect(tester);
        await tester.tap(_optionSemantics('range'));
        await tester.pumpAndSettle();
        await _openSelect(tester);

        final values = ['fixed', 'range', 'flexible', 'other'];
        final optionTops = [
          for (final value in values) tester.getTopLeft(_optionSemantics(value)).dy,
        ];
        expect(optionTops, orderedEquals([...optionTops]..sort()));
      },
    );

    testWidgets(
      'when tapping between options, it should share the gap between them',
      (tester) async {
        await _pumpSelect(tester);
        await _openSelect(tester);

        final first = tester.getRect(
          find.byKey(const ValueKey<Object>(('mateo_select_option', 'fixed'))),
        );
        final second = tester.getRect(
          find.byKey(const ValueKey<Object>(('mateo_select_option', 'range'))),
        );
        final upperGap = Offset(
          second.center.dx,
          first.bottom + (second.top - first.bottom) / 4,
        );
        final lowerGap = Offset(
          second.center.dx,
          first.bottom + (second.top - first.bottom) * 3 / 4,
        );

        expect(second.top, greaterThan(first.bottom));
        await tester.tapAt(upperGap);
        await tester.pumpAndSettle();

        expect(find.byKey(_panelKey), findsNothing);
        expect(_inSource('Fixed price'), findsOneWidget);

        await _openSelect(tester);
        await tester.tapAt(lowerGap);
        await tester.pumpAndSettle();

        expect(_inSource('Range'), findsOneWidget);
      },
    );

    testWidgets(
      'when opened, it should assign the full panel surface to option hit targets',
      (tester) async {
        await _pumpSelect(tester);
        await _openSelect(tester);

        final panel = tester.getRect(find.byKey(_panelKey));
        final options = [
          for (final value in ['fixed', 'range', 'flexible', 'other']) tester.getRect(_optionSemantics(value)),
        ];

        expect(options.first.top, closeTo(panel.top, 0.01));
        expect(options.last.bottom, closeTo(panel.bottom, 0.01));
        for (final option in options) {
          expect(option.left, closeTo(panel.left, 0.01));
          expect(option.right, closeTo(panel.right, 0.01));
        }
        for (var index = 1; index < options.length; index += 1) {
          expect(options[index].top, closeTo(options[index - 1].bottom, 0.01));
        }

        await tester.tapAt(Offset(panel.right - 1, options.last.center.dy));
        await tester.pumpAndSettle();

        expect(_inSource('Other'), findsOneWidget);
      },
    );

    testWidgets(
      'when a non-first selection opens, it should fly to its fixed row',
      (tester) async {
        await _pumpSelect(tester, initialValue: 'range');
        final sourceTop = tester.getTopLeft(find.byKey(_sourceKey)).dy;
        final flight = find.byKey(
          const ValueKey<Object>(('mateo_select_option', 'range')),
        );

        await tester.tap(find.byKey(_sourceKey));
        await tester.pump();
        await tester.pump();
        final openingTop = tester.getTopLeft(flight).dy;

        await tester.pump(const Duration(milliseconds: 110));
        final midpointTop = tester.getTopLeft(flight).dy;

        await tester.pumpAndSettle();
        final rowTop = tester.getTopLeft(flight).dy;

        expect(openingTop, closeTo(sourceTop, 0.01));
        expect(midpointTop, greaterThan(openingTop));
        expect(midpointTop, lessThan(rowTop));
      },
    );

    testWidgets(
      'when colorScheme is provided, it should override the themed select colors',
      (tester) async {
        final states = <MateoSelectState>[];
        final selectScheme = mateoTestColorScheme.select.neutral.copyWith(
          background: mateoTestPalette.accent[1],
          title: mateoTestPalette.neutral[11],
          icon: mateoTestPalette.accent[9],
        );
        await _pumpSelect(
          tester,
          colorScheme: selectScheme,
          options: _options(withDescriptions: true, onBuild: states.add),
        );

        final source = tester.widget<Container>(find.byKey(_sourceKey));
        final decoration = source.decoration! as BoxDecoration;
        final title = tester.widget<Text>(_inSource('Fixed price'));
        expect(decoration.color, selectScheme.background);
        expect(title.style!.color, selectScheme.title);
        expect(
          states,
          contains(
            isA<MateoSelectState>().having(
              (state) => state.recommendedIconColor,
              'icon',
              selectScheme.icon,
            ),
          ),
        );

        await _openSelect(tester);

        final description = tester.widget<Text>(find.text('Pay between two values.'));
        expect(description.style!.color, mateoTestColorScheme.menu.action.description);
      },
    );

    testWidgets(
      'when tapped, it should open immediately without waiting for press feedback',
      (tester) async {
        await _pumpSelect(tester);

        await tester.tap(find.byKey(_sourceKey));
        await tester.pump();

        expect(find.byKey(_panelKey), findsOneWidget);
        await tester.pumpAndSettle();
      },
    );

    testWidgets(
      'when opened, it should fit its content instead of filling safe width',
      (tester) async {
        await _pumpSelect(tester);
        await _openSelect(tester);

        expect(tester.getSize(find.byKey(_panelKey)).width, lessThan(376));
      },
    );

    testWidgets(
      'when reopened without a layout change, it should preserve its compact width',
      (tester) async {
        await _pumpSelect(tester);
        await _openSelect(tester);

        final firstPanelWidth = tester.getSize(find.byKey(_panelKey)).width;

        await tester.tapAt(const Offset(390, 400));
        await tester.pumpAndSettle();
        await _openSelect(tester);

        expect(tester.getSize(find.byKey(_panelKey)).width, firstPanelWidth);
      },
    );

    testWidgets(
      'when a selected value closes and reopens, it should preserve its compact width',
      (tester) async {
        await _pumpSelect(tester);
        await _openSelect(tester);

        final firstPanelWidth = tester.getSize(find.byKey(_panelKey)).width;

        await tester.tap(_optionSemantics('range'));
        await tester.pumpAndSettle();
        await _openSelect(tester);

        expect(tester.getSize(find.byKey(_panelKey)).width, firstPanelWidth);
      },
    );

    testWidgets(
      'when equivalent option instances rebuild between openings, it should preserve its compact width',
      (tester) async {
        late StateSetter rebuild;
        await _pumpHost(
          tester,
          builder: (context) => StatefulBuilder(
            builder: (context, setState) {
              rebuild = setState;
              return MateoSelect<String>(
                presentation: const MateoSelectPresentation.neutral(),
                onSelected: (value, animation) {},
                initialValue: 'fixed',
                options: _options(),
              );
            },
          ),
        );
        await _openSelect(tester);
        await tester.tapAt(const Offset(390, 400));
        await tester.pumpAndSettle();

        rebuild(() {});
        await tester.pump();
        await _openSelect(tester);
      },
    );

    testWidgets(
      'when text scaling changes between openings, it should recalculate its compact width',
      (tester) async {
        late StateSetter rebuild;
        var textScaler = TextScaler.noScaling;
        await _pumpHost(
          tester,
          builder: (context) => StatefulBuilder(
            builder: (context, setState) {
              rebuild = setState;
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaler: textScaler),
                child: MateoSelect<String>(
                  presentation: const MateoSelectPresentation.neutral(),
                  onSelected: (value, animation) {},
                  initialValue: 'fixed',
                  options: [
                    _option('fixed', 'Fixed price'),
                    _option('range', 'A wider payment range'),
                  ],
                ),
              );
            },
          ),
        );
        await _openSelect(tester);
        final firstPanelWidth = tester.getSize(find.byKey(_panelKey)).width;
        await tester.tapAt(const Offset(390, 400));
        await tester.pumpAndSettle();

        rebuild(() => textScaler = const TextScaler.linear(1.5));
        await tester.pump();
        await _openSelect(tester);

        expect(tester.getSize(find.byKey(_panelKey)).width, greaterThan(firstPanelWidth));
      },
    );

    testWidgets(
      'when a nonlinear text scaler changes between openings, it should recalculate its compact width',
      (tester) async {
        late StateSetter rebuild;
        var textScaler = TextScaler.noScaling;
        final select = MateoSelect<String>(
          presentation: const MateoSelectPresentation.neutral(),
          onSelected: (value, animation) {},
          initialValue: 'fixed',
          options: [
            _option('fixed', 'Fixed price'),
            _option('range', 'A medium payment option'),
          ],
        );
        await _pumpHost(
          tester,
          builder: (context) => StatefulBuilder(
            builder: (context, setState) {
              rebuild = setState;
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaler: textScaler),
                child: select,
              );
            },
          ),
        );
        await _openSelect(tester);
        final firstPanelWidth = tester.getSize(find.byKey(_panelKey)).width;
        await tester.tapAt(const Offset(390, 400));
        await tester.pumpAndSettle();

        rebuild(() => textScaler = const _NonlinearSelectTextScaler());
        await tester.pump();
        await _openSelect(tester);

        expect(tester.getSize(find.byKey(_panelKey)).width, greaterThan(firstPanelWidth));
      },
    );

    testWidgets(
      'when option content changes between openings, it should recalculate its compact width',
      (tester) async {
        late StateSetter rebuild;
        var options = [
          _option('fixed', 'Fixed price'),
          _option('range', 'Range'),
        ];
        await _pumpHost(
          tester,
          builder: (context) => StatefulBuilder(
            builder: (context, setState) {
              rebuild = setState;
              return MateoSelect<String>(
                presentation: const MateoSelectPresentation.neutral(),
                onSelected: (value, animation) {},
                initialValue: 'fixed',
                options: options,
              );
            },
          ),
        );
        await _openSelect(tester);
        final firstPanelWidth = tester.getSize(find.byKey(_panelKey)).width;
        await tester.tapAt(const Offset(390, 400));
        await tester.pumpAndSettle();

        rebuild(
          () => options = [
            _option('fixed', 'Fixed price'),
            _option('range', 'A wider payment range'),
          ],
        );
        await tester.pump();
        await _openSelect(tester);

        expect(tester.getSize(find.byKey(_panelKey)).width, greaterThan(firstPanelWidth));
      },
    );

    testWidgets(
      'when horizontal safe area changes between openings, it should recalculate its compact width',
      (tester) async {
        await _pumpSelect(
          tester,
          options: [
            _option('fixed', 'Fixed price'),
            _option('range', 'A wider payment range'),
          ],
        );
        await _openSelect(tester);
        final firstPanelWidth = tester.getSize(find.byKey(_panelKey)).width;
        await tester.tapAt(const Offset(390, 400));
        await tester.pumpAndSettle();

        tester.view.padding = const FakeViewPadding(left: 100, right: 100);
        await tester.pump();
        await _openSelect(tester);

        expect(tester.getSize(find.byKey(_panelKey)).width, lessThan(firstPanelWidth));
      },
    );

    testWidgets(
      'when opened, it should align its top with the closed control',
      (tester) async {
        await _pumpSelect(tester);
        final sourceTop = tester.getRect(find.byKey(_sourceKey)).top;

        await _openSelect(tester);

        expect(tester.getRect(find.byKey(_panelKey)).top, sourceTop);
      },
    );

    testWidgets(
      'when descriptions are mixed, it should show only provided descriptions',
      (tester) async {
        await _pumpSelect(tester, options: _options(withDescriptions: true));

        await _openSelect(tester);

        expect(find.text('Agree the price together.'), findsOneWidget);
        expect(find.text('Pay an exact amount.'), findsNothing);
        expect(find.text('Pay between two values.'), findsOneWidget);
      },
    );

    testWidgets('when an option is pressed, it should use scale-fade feedback', (tester) async {
      await _pumpSelect(tester);
      await _openSelect(tester);

      final tap = tester.widget<MateoTap>(
        find.descendant(of: _optionSemantics('range'), matching: find.byType(MateoTap)),
      );

      expect(tap.animation, MateoTapAnimationType.scaleFade);
    });

    testWidgets(
      'when another option closes the menu, it should preserve that option\'s scale-fade release feedback',
      (tester) async {
        await _pumpSelect(tester);
        await _openSelect(tester);
        final rangeTap = find.descendant(
          of: _optionSemantics('range'),
          matching: find.byType(MateoTap),
        );
        final originalElement = tester.element(rangeTap);

        final gesture = await tester.startGesture(tester.getCenter(_optionSemantics('range')));
        await tester.pump(const Duration(milliseconds: 50));
        await gesture.up();
        await tester.pump(const Duration(milliseconds: 20));

        expect(tester.element(rangeTap), same(originalElement));
        final scale = tester.widget<ScaleTransition>(
          find.descendant(of: rangeTap, matching: find.byType(ScaleTransition)),
        );
        expect(scale.scale.value, lessThan(1));
      },
    );

    testWidgets(
      'when another option is selected, it should update, close, and callback once',
      (tester) async {
        var calls = 0;
        await _pumpSelect(
          tester,
          onSelected: (value, animation) => calls += 1,
        );
        await _openSelect(tester);

        await tester.tap(_optionSemantics('range'));
        await tester.pumpAndSettle();

        expect(find.byKey(_panelKey), findsNothing);
        expect(_inSource('Range'), findsOneWidget);
        expect(calls, 1);
      },
    );

    testWidgets(
      'when another option reaches the closed position, its content should align with the source',
      (tester) async {
        await _pumpSelect(tester);
        await _openSelect(tester);

        await tester.tap(_optionSemantics('range'));
        await tester.pump();
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 1));
        await tester.pump(const Duration(milliseconds: 150));
        await tester.pump(const Duration(milliseconds: 89));
        await tester.pump(const Duration(milliseconds: 60));

        expect(find.byKey(_panelKey), findsOneWidget);

        final source = find.byKey(_sourceKey);
        final panel = find.byKey(_panelKey);
        final sourceIcon = find.descendant(
          of: source,
          matching: find.byKey(
            const ValueKey<Object>(('mateo_select_icon', 'range')),
          ),
        );
        final flightIcon = find.descendant(
          of: panel,
          matching: find.byKey(
            const ValueKey<Object>(('mateo_select_icon', 'range')),
          ),
        );
        final sourceChevron = find.byKey(
          const ValueKey<Object>((
            'mateo_select_source_chevron',
            'range',
          )),
        );
        final flightChevron = find.byKey(
          const ValueKey<Object>((
            'mateo_select_closed_flight_option',
            'range',
          )),
        );

        expect(tester.getCenter(flightIcon).dx, closeTo(tester.getCenter(sourceIcon).dx, 0.1));
        expect(tester.getCenter(flightChevron).dx, closeTo(tester.getCenter(sourceChevron).dx, 0.1));

        await tester.pumpAndSettle();
        expect(find.byKey(_panelKey), findsNothing);
      },
    );

    testWidgets(
      'when a selected row reaches its endpoint, it should paint there before the source handoff',
      (tester) async {
        final semantics = tester.ensureSemantics();
        await _pumpSelect(tester);
        await _openSelect(tester);

        final option = tester.getSemantics(_optionSemantics('range'));
        option.owner!.performAction(option.id, SemanticsAction.tap);
        await tester.pump();
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 1));
        await tester.pump(const Duration(milliseconds: 199));

        final source = find.byKey(_sourceKey);
        final panel = find.byKey(_panelKey);
        final sourceIcon = find.descendant(
          of: source,
          matching: find.byKey(
            const ValueKey<Object>(('mateo_select_icon', 'range')),
          ),
        );
        final flightIcon = find.descendant(
          of: panel,
          matching: find.byKey(
            const ValueKey<Object>(('mateo_select_icon', 'range')),
          ),
        );
        final sourceCenter = tester.getCenter(sourceIcon);
        Offset? paintedFlightCenter;
        tester.binding.addPostFrameCallback((_) {
          if (flightIcon.evaluate().isNotEmpty) {
            paintedFlightCenter = tester.getCenter(flightIcon);
          }
        });

        await tester.pump(const Duration(milliseconds: 16));

        expect(
          paintedFlightCenter,
          within<Offset>(distance: 0.01, from: sourceCenter),
        );

        await tester.pump();
        expect(find.byKey(_panelKey), findsNothing);
        expect(_inSource('Range'), findsOneWidget);
        expect(
          paintedFlightCenter,
          within<Offset>(distance: 0.01, from: tester.getCenter(sourceIcon)),
        );
        semantics.dispose();
      },
    );

    testWidgets(
      'when a pressed selection rebuilds its centered parent, its flight should match the visible source',
      (tester) async {
        var selectedValue = 'other';
        await _pumpHost(
          tester,
          builder: (context) => StatefulBuilder(
            builder: (context, setState) => SizedBox(
              width: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MateoSelect<String>(
                    presentation: const MateoSelectPresentation.neutral(),
                    onSelected: (value, animation) => setState(() => selectedValue = value),
                    initialValue: selectedValue,
                    options: [
                      _option(
                        'fixed',
                        'Valor fixo',
                      ),
                      _option('range', 'Faixa de preço'),
                      _option('flexible', 'A Combinar'),
                      _option('other', 'Outro pagamento'),
                    ],
                  ),
                  const SizedBox(height: 200),
                ],
              ),
            ),
          ),
        );
        await _openSelect(tester);

        final gesture = await tester.startGesture(
          tester.getCenter(_optionSemantics('fixed')),
        );
        await tester.pump(const Duration(milliseconds: 100));
        await gesture.up();
        final flightIcon = find.descendant(
          of: find.byKey(_panelKey),
          matching: find.byKey(
            const ValueKey<Object>(('mateo_select_icon', 'fixed')),
          ),
        );
        final paintedCenters = <Offset>[];

        void recordFlightPosition(Duration _) {
          if (flightIcon.evaluate().isNotEmpty) {
            paintedCenters.add(tester.getCenter(flightIcon));
          }
          if (find.byKey(_panelKey).evaluate().isNotEmpty) {
            tester.binding.addPostFrameCallback(recordFlightPosition);
          }
        }

        tester.binding.addPostFrameCallback(recordFlightPosition);
        await tester.pumpAndSettle();

        final visibleSourceIcon = find.descendant(
          of: find.byKey(_sourceKey),
          matching: find.byKey(
            const ValueKey<Object>(('mateo_select_icon', 'fixed')),
          ),
        );
        expect(paintedCenters, isNotEmpty);
        expect(
          paintedCenters.last,
          within<Offset>(distance: 0.01, from: tester.getCenter(visibleSourceIcon)),
        );
      },
    );

    testWidgets(
      'when selected is pressed again, it should close and callback once',
      (tester) async {
        var calls = 0;
        await _pumpSelect(
          tester,
          onSelected: (value, animation) => calls += 1,
        );
        await _openSelect(tester);

        await tester.tap(_optionSemantics('fixed'));
        await tester.pumpAndSettle();

        expect((find.byKey(_panelKey).evaluate().length, calls), (0, 1));
      },
    );

    testWidgets(
      'when selected option instances rebuild, it should preserve selected value',
      (tester) async {
        late StateSetter rebuild;
        var options = _options();
        await _pumpHost(
          tester,
          builder: (context) => StatefulBuilder(
            builder: (context, setState) {
              rebuild = setState;
              return MateoSelect<String>(
                presentation: const MateoSelectPresentation.neutral(),
                onSelected: (value, animation) {},
                initialValue: 'fixed',
                options: options,
              );
            },
          ),
        );
        await _openSelect(tester);
        await tester.tap(_optionSemantics('range'));
        await tester.pumpAndSettle();

        rebuild(() => options = _options());
        await tester.pump();

        expect(_inSource('Range'), findsOneWidget);
      },
    );

    testWidgets(
      'when option instances rebuild while open, it should use the current content and callbacks',
      (tester) async {
        late StateSetter rebuild;
        var calls = 0;
        var onSelected = (String value, Future<void> animation) {};
        var options = _options();
        await _pumpHost(
          tester,
          builder: (context) => StatefulBuilder(
            builder: (context, setState) {
              rebuild = setState;
              return MateoSelect<String>(
                presentation: const MateoSelectPresentation.neutral(),
                onSelected: onSelected,
                initialValue: 'fixed',
                options: options,
              );
            },
          ),
        );
        await _openSelect(tester);

        rebuild(
          () {
            onSelected = (value, animation) {
              calls += 1;
            };
            options = [
              _option('fixed', 'Updated fixed'),
              _option('range', 'Updated range'),
            ];
          },
        );
        await tester.pump();

        expect(find.text('Updated fixed'), findsWidgets);
        expect(find.text('Updated range'), findsOneWidget);
        await tester.tap(_optionSemantics('range'));
        await tester.pumpAndSettle();
        expect(_inSource('Updated range'), findsOneWidget);
        expect(calls, 1);
      },
    );

    testWidgets(
      'when selected value disappears, it should fall back to current initialValue',
      (tester) async {
        late StateSetter rebuild;
        var initialValue = 'fixed';
        var options = _options();
        await _pumpHost(
          tester,
          builder: (context) => StatefulBuilder(
            builder: (context, setState) {
              rebuild = setState;
              return MateoSelect<String>(
                presentation: const MateoSelectPresentation.neutral(),
                onSelected: (value, animation) {},
                initialValue: initialValue,
                options: options,
              );
            },
          ),
        );
        await _openSelect(tester);
        await tester.tap(_optionSemantics('range'));
        await tester.pumpAndSettle();

        rebuild(() {
          initialValue = 'flexible';
          options = [
            _option('fixed', 'Fixed price'),
            _option('flexible', 'Flexible'),
          ];
        });
        await tester.pump();

        expect(_inSource('Flexible'), findsOneWidget);
      },
    );

    testWidgets(
      'when outside is tapped, it should dismiss without changing selection',
      (tester) async {
        await _pumpSelect(tester);
        await _openSelect(tester);

        await tester.tapAt(const Offset(390, 400));
        await tester.pump();
        await tester.pump();
        await tester.pump();
        expect(find.byKey(_panelKey), findsOneWidget);
        await tester.pumpAndSettle();

        expect(find.byKey(_panelKey), findsNothing);
        expect(_inSource('Fixed price'), findsOneWidget);
      },
    );

    testWidgets(
      'when closing finishes, it should report completion once',
      (tester) async {
        var closeCompletions = 0;
        await _pumpSelect(
          tester,
          onSelected: (value, animation) => animation.then((_) => closeCompletions += 1),
        );
        await _openSelect(tester);

        await tester.tap(_optionSemantics('range'));
        await tester.pump();

        expect(closeCompletions, 0);

        await tester.pumpAndSettle();

        expect(closeCompletions, 1);
      },
    );

    testWidgets(
      'when the trigger is tapped during closing, it should reverse back open without a visual jump',
      (tester) async {
        var calls = 0;
        var closeCompletions = 0;
        await _pumpSelect(
          tester,
          onSelected: (value, animation) {
            calls += 1;
            return animation.then((_) => closeCompletions += 1);
          },
        );
        final sourceCenter = tester.getCenter(find.byKey(_sourceKey));
        await _openSelect(tester);

        await tester.tap(_optionSemantics('range'));
        await tester.pump();
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 80));

        final flightIcon = find.descendant(
          of: find.byKey(_panelKey),
          matching: find.byKey(
            const ValueKey<Object>(('mateo_select_icon', 'range')),
          ),
        );
        final closingCenter = tester.getCenter(flightIcon);
        final reopenTarget = find.byKey(
          const Key('mateo_select_reopen_target'),
        );

        expect(tester.getRect(reopenTarget).contains(sourceCenter), isTrue);

        await tester.tapAt(sourceCenter);
        await tester.pump();

        expect(
          tester.getCenter(flightIcon),
          within<Offset>(distance: 0.1, from: closingCenter),
        );
        await tester.pumpAndSettle();

        expect(find.byKey(_panelKey), findsOneWidget);
        expect(
          tester.getSemantics(_optionSemantics('range')).flagsCollection.isSelected.toBoolOrNull(),
          isTrue,
        );
        expect(calls, 1);
        expect(closeCompletions, 0);

        expect(await tester.binding.handlePopRoute(), isTrue);
        await tester.pumpAndSettle();
        expect(find.byKey(_panelKey), findsNothing);
        expect(closeCompletions, 1);
        expect(await tester.binding.handlePopRoute(), isFalse);
      },
    );

    testWidgets(
      'when dismissal is requested repeatedly, it should run one closing sequence',
      (tester) async {
        await _pumpSelect(tester);
        await _openSelect(tester);

        await tester.tapAt(const Offset(390, 400));
        await tester.tapAt(const Offset(390, 400));
        await tester.pumpAndSettle();

        expect(find.byKey(_panelKey), findsNothing);
        expect(_inSource('Fixed price'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets('when the viewport changes while open, it should close and clear route history', (tester) async {
      late StateSetter rebuild;
      var size = const Size(400, 800);
      await _pumpHost(
        tester,
        builder: (context) => StatefulBuilder(
          builder: (context, setState) {
            rebuild = setState;
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(size: size),
              child: MateoSelect<String>(
                presentation: const MateoSelectPresentation.neutral(),
                onSelected: (value, animation) {},
                initialValue: 'fixed',
                options: _options(),
              ),
            );
          },
        ),
      );
      await _openSelect(tester);

      rebuild(() => size = const Size(390, 800));
      await tester.pumpAndSettle();

      expect(find.byKey(_panelKey), findsNothing);
      expect(await tester.binding.handlePopRoute(), isFalse);
    });

    testWidgets(
      'when back is requested before the opening frame, it should close without retrying',
      (tester) async {
        await _pumpSelect(tester);

        await tester.tap(find.byKey(_sourceKey));
        await tester.binding.handlePopRoute();
        await tester.pumpAndSettle();

        expect(find.byKey(_panelKey), findsNothing);
        expect(find.byKey(_sourceKey), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets('when animated, it should not mount Morph widgets', (
      tester,
    ) async {
      await _pumpSelect(tester);
      await tester.tap(find.byKey(_sourceKey));
      await tester.pump();

      expect(
        find.byWidgetPredicate(
          (widget) => widget.runtimeType.toString() == 'Morph',
        ),
        findsNothing,
      );
      await tester.pumpAndSettle();
    });

    testWidgets(
      'when closing, it should fade remaining options progressively',
      (tester) async {
        await _pumpSelect(tester);
        await _openSelect(tester);

        await tester.tap(_optionSemantics('range'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));

        final fade = tester.widget<FadeTransition>(
          find
              .ancestor(
                of: find.byKey(
                  const ValueKey<Object>(('mateo_select_option', 'fixed')),
                ),
                matching: find.byType(FadeTransition),
              )
              .first,
        );
        expect(fade.opacity.value, greaterThan(0));
        expect(fade.opacity.value, lessThan(1));
        await tester.pumpAndSettle();
      },
    );

    testWidgets(
      'when opening, it should not rebuild non-flight option contents per frame',
      (tester) async {
        final states = <MateoSelectState>[];
        await _pumpSelect(
          tester,
          options: [
            _option('fixed', 'Fixed price'),
            _option('range', 'Range'),
            _option('flexible', 'Flexible', onBuild: states.add),
          ],
        );

        await tester.tap(find.byKey(_sourceKey));
        await tester.pump();
        await tester.pump();
        await tester.pump();

        final flexible = find.byKey(
          const ValueKey<Object>(('mateo_select_option', 'flexible')),
        );
        final flexibleElement = tester.element(flexible);
        final buildsAfterOpenStarted = states.length;
        for (var frame = 0; frame < 6; frame += 1) {
          await tester.pump(const Duration(milliseconds: 16));
        }

        expect(states.length, buildsAfterOpenStarted);
        expect(identical(tester.element(flexible), flexibleElement), isTrue);
        await tester.pumpAndSettle();
      },
    );

    testWidgets(
      'when closing, it should not rebuild non-flight option contents per frame',
      (tester) async {
        final states = <MateoSelectState>[];
        await _pumpSelect(
          tester,
          options: [
            _option('fixed', 'Fixed price'),
            _option('range', 'Range'),
            _option('flexible', 'Flexible', onBuild: states.add),
          ],
        );
        await _openSelect(tester);

        await tester.tap(_optionSemantics('range'));
        await tester.pump();
        await tester.pump();
        await tester.pump();
        final buildsAfterCloseStarted = states.length;
        for (var frame = 0; frame < 6; frame += 1) {
          await tester.pump(const Duration(milliseconds: 16));
        }

        expect(states.length, buildsAfterCloseStarted);
        await tester.pumpAndSettle();
      },
    );

    testWidgets(
      'when a callback removes the select, it should dispose safely',
      (tester) async {
        var showSelect = true;
        await _pumpHost(
          tester,
          builder: (context) => StatefulBuilder(
            builder: (context, setState) => showSelect
                ? MateoSelect<String>(
                    presentation: const MateoSelectPresentation.neutral(),
                    onSelected: (value, animation) => setState(() => showSelect = false),
                    initialValue: 'fixed',
                    options: _options(),
                  )
                : const SizedBox.shrink(),
          ),
        );
        await _openSelect(tester);

        await tester.tap(_optionSemantics('range'));
        await tester.pumpAndSettle();

        expect(find.byType(MateoSelect<String>), findsNothing);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'when a callback removes the selected value, it should keep the closing flight stable',
      (tester) async {
        late StateSetter rebuild;
        var calls = 0;
        await _pumpHost(
          tester,
          builder: (context) => StatefulBuilder(
            builder: (context, setState) {
              rebuild = setState;
              final options = [
                _option('fixed', 'Fixed price'),
                if (calls == 0)
                  _option(
                    'range',
                    'Range',
                  )
                else
                  _option('flexible', 'Flexible'),
              ];
              return MateoSelect<String>(
                presentation: const MateoSelectPresentation.neutral(),
                onSelected: (value, animation) {
                  calls += 1;
                  rebuild(() {});
                },
                initialValue: 'fixed',
                options: options,
              );
            },
          ),
        );
        await _openSelect(tester);

        await tester.tap(_optionSemantics('range'));
        await tester.pump(const Duration(milliseconds: 16));

        expect(
          find.byKey(
            const ValueKey<Object>((
              'mateo_select_closed_flight_option',
              'range',
            )),
          ),
          findsOneWidget,
        );
        await tester.pumpAndSettle();
        expect(_inSource('Fixed price'), findsOneWidget);
        expect(calls, 1);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'when system back is requested, it should dismiss without popping route',
      (tester) async {
        await _pumpSelect(tester);
        await _openSelect(tester);

        await tester.binding.handlePopRoute();
        await tester.pumpAndSettle();

        expect(find.byKey(_panelKey), findsNothing);
        expect(find.byKey(_sourceKey), findsOneWidget);
      },
    );

    testWidgets('when escape is pressed, it should dismiss the menu', (
      tester,
    ) async {
      await _pumpSelect(tester);
      await _openSelect(tester);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();

      expect(find.byKey(_panelKey), findsNothing);
    });

    testWidgets(
      'when escape is pressed during opening, it should dismiss immediately',
      (tester) async {
        await _pumpSelect(tester);

        await tester.tap(find.byKey(_sourceKey));
        await tester.pump();
        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        await tester.pumpAndSettle();

        expect(find.byKey(_panelKey), findsNothing);
      },
    );

    testWidgets(
      'when selecting after editing another field, it should focus the select without reopening the keyboard',
      (tester) async {
        final textFieldFocusNode = FocusNode();
        addTearDown(textFieldFocusNode.dispose);
        await _pumpHost(
          tester,
          builder: (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(focusNode: textFieldFocusNode),
              MateoSelect<String>(
                presentation: const MateoSelectPresentation.neutral(),
                onSelected: (value, animation) {},
                initialValue: 'fixed',
                options: _options(),
              ),
            ],
          ),
        );
        await tester.showKeyboard(find.byType(TextField));
        await _openSelect(tester);
        tester.testTextInput.log.clear();

        await tester.tap(_optionSemantics('range'));
        await tester.pumpAndSettle();
        final textFieldMethods = tester.testTextInput.log.map((methodCall) => methodCall.method);

        expect(
          (
            textFieldFocusNode.hasFocus,
            Focus.of(tester.element(find.byKey(const Key('mateo_select_source_semantics')))).hasPrimaryFocus,
            textFieldMethods.where((method) => method == 'TextInput.show').length,
            tester.testTextInput.isVisible,
          ),
          (false, true, 0, false),
        );
      },
    );

    testWidgets(
      'when dismissing after editing another field, it should return focus to the select source',
      (tester) async {
        final textFieldFocusNode = FocusNode();
        addTearDown(textFieldFocusNode.dispose);
        await _pumpHost(
          tester,
          builder: (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(focusNode: textFieldFocusNode),
              MateoSelect<String>(
                presentation: const MateoSelectPresentation.neutral(),
                onSelected: (value, animation) {},
                initialValue: 'fixed',
                options: _options(),
              ),
            ],
          ),
        );
        textFieldFocusNode.requestFocus();
        await tester.pump();
        await _openSelect(tester);

        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        await tester.pumpAndSettle();

        expect(
          (
            textFieldFocusNode.hasFocus,
            Focus.of(tester.element(find.byKey(const Key('mateo_select_source_semantics')))).hasPrimaryFocus,
          ),
          (false, true),
        );
      },
    );

    testWidgets(
      'when an option callback moves focus, it should preserve the callback destination',
      (tester) async {
        final textFieldFocusNode = FocusNode();
        final destinationFocusNode = FocusNode();
        addTearDown(textFieldFocusNode.dispose);
        addTearDown(destinationFocusNode.dispose);
        await _pumpHost(
          tester,
          builder: (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(focusNode: textFieldFocusNode),
              MateoSelect<String>(
                presentation: const MateoSelectPresentation.neutral(),
                onSelected: (value, animation) => destinationFocusNode.requestFocus(),
                initialValue: 'fixed',
                options: _options(),
              ),
              Focus(
                focusNode: destinationFocusNode,
                child: const SizedBox(width: 40, height: 40),
              ),
            ],
          ),
        );
        textFieldFocusNode.requestFocus();
        await tester.pump();
        await _openSelect(tester);

        await tester.tap(_optionSemantics('range'));
        await tester.pumpAndSettle();

        expect(destinationFocusNode.hasFocus, isTrue);
      },
    );

    testWidgets(
      'when opened, it should expose expanded and selected semantics',
      (tester) async {
        final semantics = tester.ensureSemantics();
        try {
          await _pumpSelect(tester);

          expect(
            tester
                .getSemantics(
                  find.byKey(const Key('mateo_select_source_semantics')),
                )
                .flagsCollection
                .isExpanded
                .toBoolOrNull(),
            isFalse,
          );
          await _openSelect(tester);

          final overlay = tester.getSemantics(
            find.byKey(const Key('mateo_select_overlay_semantics')),
          );
          expect(overlay.flagsCollection.isExpanded.toBoolOrNull(), isTrue);

          final selected = tester.getSemantics(
            find.byKey(
              const ValueKey<Object>((
                'mateo_select_option_semantics',
                'fixed',
              )),
            ),
          );
          expect(selected.flagsCollection.isSelected.toBoolOrNull(), isTrue);
          expect(selected.flagsCollection.isInMutuallyExclusiveGroup, isTrue);
          expect(selected.label, 'Fixed price');
        } finally {
          semantics.dispose();
        }
      },
    );

    testWidgets(
      'when opened, it should block background semantics until dismissed',
      (tester) async {
        const backgroundKey = Key('background_semantics');
        final semantics = tester.ensureSemantics();
        try {
          await _pumpHost(
            tester,
            builder: (context) => SizedBox(
              width: 300,
              height: 200,
              child: Stack(
                children: [
                  Semantics(
                    key: backgroundKey,
                    container: true,
                    button: true,
                    label: 'Background action',
                    onTap: () {},
                    child: const SizedBox.expand(),
                  ),
                  Align(
                    child: MateoSelect<String>(
                      presentation: const MateoSelectPresentation.neutral(),
                      onSelected: (value, animation) {},
                      initialValue: 'fixed',
                      options: _options(),
                    ),
                  ),
                ],
              ),
            ),
          );

          expect(tester.getSemantics(find.byKey(backgroundKey)).attached, isTrue);
          await _openSelect(tester);
          expect(tester.getSemantics(find.byKey(backgroundKey)).attached, isFalse);

          await tester.tapAt(const Offset(390, 400));
          await tester.pumpAndSettle();
          expect(tester.getSemantics(find.byKey(backgroundKey)).attached, isTrue);
        } finally {
          semantics.dispose();
        }
      },
    );

    testWidgets(
      'when closing, it should remove menu interactions from semantics',
      (tester) async {
        final semantics = tester.ensureSemantics();
        try {
          await _pumpSelect(tester);
          await _openSelect(tester);
          expect(tester.getSemantics(_optionSemantics('flexible')).attached, isTrue);

          await tester.tap(_optionSemantics('range'));
          await tester.pump();

          expect(tester.getSemantics(_optionSemantics('flexible')).attached, isFalse);
          await tester.pumpAndSettle();
        } finally {
          semantics.dispose();
        }
      },
    );

    testWidgets(
      'when source is near top, it should anchor panel below top safe area',
      (tester) async {
        await _pumpSelect(
          tester,
          alignment: Alignment.topCenter,
          mediaQueryData: const MediaQueryData(
            size: Size(400, 800),
            padding: EdgeInsets.fromLTRB(20, 44, 10, 34),
          ),
        );
        await _openSelect(tester);

        final rect = tester.getRect(find.byKey(_panelKey));
        expect(rect.top, 44);
        expect(rect.left, greaterThanOrEqualTo(32));
        expect(400 - rect.right, greaterThanOrEqualTo(22));
      },
    );

    testWidgets(
      'when safe areas are asymmetric in landscape, it should honor each horizontal edge',
      (tester) async {
        await _pumpSelect(
          tester,
          size: const Size(800, 400),
          alignment: Alignment.topCenter,
          mediaQueryData: const MediaQueryData(
            size: Size(800, 400),
            padding: EdgeInsets.fromLTRB(44, 24, 20, 16),
          ),
        );
        await _openSelect(tester);

        final panel = tester.getRect(find.byKey(_panelKey));
        expect(panel.top, 24);
        expect(panel.left, greaterThanOrEqualTo(56));
        expect(800 - panel.right, greaterThanOrEqualTo(32));
        expect(panel.bottom, lessThanOrEqualTo(384));
      },
    );

    testWidgets(
      'when text is extreme, it should truncate and stay within the usable viewport',
      (tester) async {
        const longTitle = 'A very long localized payment option title that cannot fit on one line';
        await _pumpSelect(
          tester,
          size: const Size(240, 320),
          mediaQueryData: const MediaQueryData(
            size: Size(240, 320),
            textScaler: TextScaler.linear(2),
          ),
          initialValue: 'long',
          options: [
            _option('long', longTitle, description: 'A supporting description that also needs to wrap safely.'),
            _option('other', 'Other option', description: 'Another supporting description.'),
          ],
        );

        final source = tester.getRect(find.byKey(_sourceKey));
        expect(source.width, lessThanOrEqualTo(216));
        expect(tester.takeException(), isNull);

        await _openSelect(tester);
        final panel = tester.getRect(find.byKey(_panelKey));
        expect(panel.left, greaterThanOrEqualTo(12));
        expect(panel.right, lessThanOrEqualTo(228));
        expect(panel.bottom, lessThanOrEqualTo(320));
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets('when directionality is RTL, it should mirror option content without overflow', (tester) async {
      await _pumpHost(
        tester,
        size: const Size(320, 480),
        builder: (context) => Directionality(
          textDirection: TextDirection.rtl,
          child: MateoSelect<String>(
            presentation: const MateoSelectPresentation.neutral(),
            onSelected: (value, animation) {},
            initialValue: 'fixed',
            options: [
              _option('fixed', 'سعر ثابت'),
              _option('range', 'نطاق السعر', description: 'اختر قيمة بين حدين'),
            ],
          ),
        ),
      );

      final icon = find.byKey(const ValueKey<Object>(('mateo_select_icon', 'fixed')));
      expect(tester.getCenter(icon).dx, greaterThan(tester.getCenter(_inSource('سعر ثابت')).dx));
      await _openSelect(tester);
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'when source is near bottom, it should align tops and stay in safe area',
      (tester) async {
        await _pumpSelect(
          tester,
          alignment: Alignment.bottomCenter,
          mediaQueryData: const MediaQueryData(
            size: Size(400, 800),
            padding: EdgeInsets.only(top: 44, bottom: 34),
          ),
        );
        final sourceTop = tester.getRect(find.byKey(_sourceKey)).top;
        await _openSelect(tester);

        final panel = tester.getRect(find.byKey(_panelKey));
        expect(panel.top, sourceTop);
        expect(panel.bottom, lessThanOrEqualTo(766));
      },
    );

    testWidgets('when keyboard is visible, it should stay above keyboard', (
      tester,
    ) async {
      await _pumpSelect(
        tester,
        alignment: Alignment.bottomCenter,
        mediaQueryData: const MediaQueryData(
          size: Size(400, 800),
          padding: EdgeInsets.only(top: 44),
          viewInsets: EdgeInsets.only(bottom: 300),
        ),
      );
      final sourceTop = tester.getRect(find.byKey(_sourceKey)).top;
      await _openSelect(tester);

      final panel = tester.getRect(find.byKey(_panelKey));
      expect(panel.top, sourceTop);
      expect(panel.bottom, lessThanOrEqualTo(500));
    });

    testWidgets(
      'when system insets consume the viewport, it should resolve without invalid geometry',
      (tester) async {
        await _pumpSelect(
          tester,
          size: const Size(200, 100),
          alignment: Alignment.topCenter,
          mediaQueryData: const MediaQueryData(
            size: Size(200, 100),
            padding: EdgeInsets.only(top: 60),
            viewInsets: EdgeInsets.only(bottom: 60),
          ),
        );

        await tester.tap(find.byKey(_sourceKey));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        await tester.pumpAndSettle();
        expect(find.byKey(_panelKey), findsNothing);
      },
    );

    testWidgets(
      'when safe viewport is short, it should constrain and scroll options',
      (tester) async {
        await _pumpSelect(
          tester,
          size: const Size(320, 300),
          alignment: Alignment.topCenter,
          options: [
            for (var index = 0; index < 8; index += 1) _option('$index', 'Option $index', description: 'Description'),
          ],
          initialValue: '0',
        );
        await _openSelect(tester);

        final panel = tester.getRect(find.byKey(_panelKey));
        expect(panel.height, lessThanOrEqualTo(300 * 0.85));
        expect(find.byType(SingleChildScrollView), findsOneWidget);
        await tester.drag(
          find.byType(SingleChildScrollView),
          const Offset(0, -150),
        );
        await tester.pump();
        expect(find.text('Option 7'), findsOneWidget);
      },
    );

    testWidgets(
      'when animations are disabled, it should open and close immediately',
      (tester) async {
        await _pumpSelect(tester, disableAnimations: true);

        await tester.tap(find.byKey(_sourceKey));
        await tester.pump();
        expect(find.byKey(_panelKey), findsOneWidget);

        await tester.tapAt(const Offset(390, 400));
        await tester.pump();
        await tester.pump();
        expect(find.byKey(_panelKey), findsNothing);
      },
    );

    testWidgets(
      'when reduced motion is enabled during a transition, it should resolve the active animation',
      (tester) async {
        late StateSetter rebuild;
        var disableAnimations = false;
        await _pumpHost(
          tester,
          builder: (context) => StatefulBuilder(
            builder: (context, setState) {
              rebuild = setState;
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(disableAnimations: disableAnimations),
                child: MateoSelect<String>(
                  presentation: const MateoSelectPresentation.neutral(),
                  onSelected: (value, animation) {},
                  initialValue: 'fixed',
                  options: _options(),
                ),
              );
            },
          ),
        );

        await tester.tap(find.byKey(_sourceKey));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 50));
        rebuild(() => disableAnimations = true);
        await tester.pump();

        final fade = tester.widget<FadeTransition>(
          find
              .ancestor(
                of: find.byKey(const ValueKey<Object>(('mateo_select_option', 'range'))),
                matching: find.byType(FadeTransition),
              )
              .first,
        );
        expect(fade.opacity.value, 1);

        await tester.tapAt(const Offset(390, 400));
        await tester.pump();
        expect(find.byKey(_panelKey), findsNothing);
      },
    );
  });
}

Finder _inSource(String text) => find.descendant(of: find.byKey(_sourceKey), matching: find.text(text));

Finder _optionSemantics(Object? value) => find.byKey(
  ValueKey<Object>(('mateo_select_option_semantics', value)),
);

Future<void> _openSelect(WidgetTester tester) async {
  await tester.tap(find.byKey(_sourceKey));
  await tester.pumpAndSettle();
}

Future<void> _pumpSelect(
  WidgetTester tester, {
  List<MateoSelectOption<String>>? options,
  String initialValue = 'fixed',
  Alignment alignment = Alignment.center,
  MediaQueryData? mediaQueryData,
  Size size = const Size(400, 800),
  bool disableAnimations = false,
  ThemeData? theme,
  MateoSelectVariantColorScheme? colorScheme,
  MateoSelectPresentation? presentation,
  FutureOr<void> Function(String, Future<void>)? onSelected,
}) {
  final resolvedOptions = options ?? _options();
  return _pumpHost(
    tester,
    alignment: alignment,
    mediaQueryData: mediaQueryData ?? MediaQueryData(size: size, disableAnimations: disableAnimations),
    size: size,
    theme: theme,
    builder: (context) => MateoSelect<String>(
      presentation: presentation ?? MateoSelectPresentation.neutral(colorScheme: colorScheme),
      onSelected: onSelected ?? (value, animation) {},
      initialValue: initialValue,
      options: resolvedOptions,
    ),
  );
}

Future<void> _pumpHost(
  WidgetTester tester, {
  required WidgetBuilder builder,
  Alignment alignment = Alignment.center,
  MediaQueryData? mediaQueryData,
  Size size = const Size(400, 800),
  ThemeData? theme,
}) async {
  final resolvedMediaQuery = mediaQueryData ?? MediaQueryData(size: size);
  tester.view
    ..devicePixelRatio = 1
    ..physicalSize = size
    ..padding = FakeViewPadding(
      left: resolvedMediaQuery.padding.left,
      top: resolvedMediaQuery.padding.top,
      right: resolvedMediaQuery.padding.right,
      bottom: resolvedMediaQuery.padding.bottom,
    )
    ..viewPadding = FakeViewPadding(
      left: resolvedMediaQuery.viewPadding.left,
      top: resolvedMediaQuery.viewPadding.top,
      right: resolvedMediaQuery.viewPadding.right,
      bottom: resolvedMediaQuery.viewPadding.bottom,
    )
    ..viewInsets = FakeViewPadding(
      left: resolvedMediaQuery.viewInsets.left,
      top: resolvedMediaQuery.viewInsets.top,
      right: resolvedMediaQuery.viewInsets.right,
      bottom: resolvedMediaQuery.viewInsets.bottom,
    );
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme ?? mateoTestTheme,
      home: MediaQuery(
        data: resolvedMediaQuery,
        child: Scaffold(
          body: Align(
            alignment: alignment,
            child: Builder(
              builder: builder,
            ),
          ),
        ),
      ),
    ),
  );
}

List<MateoSelectOption<String>> _options({
  bool withDescriptions = false,
  ValueChanged<MateoSelectState>? onBuild,
}) => [
  _option('fixed', 'Fixed price', onBuild: onBuild),
  _option(
    'range',
    'Range',
    description: withDescriptions ? 'Pay between two values.' : null,
    onBuild: onBuild,
  ),
  _option(
    'flexible',
    'Flexible',
    description: withDescriptions ? 'Agree the price together.' : null,
    onBuild: onBuild,
  ),
  _option('other', 'Other', onBuild: onBuild),
];

MateoSelectOption<String> _option(
  String value,
  String title, {
  String? description,
  ValueChanged<MateoSelectState>? onBuild,
}) {
  final option = MateoSelectOption(
    value: value,
    title: title,
    description: description,
    iconBuilder: (state) {
      onBuild?.call(state);
      return Icon(
        Icons.attach_money,
        size: state.iconSize,
        color: state.recommendedIconColor,
      );
    },
  );
  return option;
}

class _NonlinearSelectTextScaler extends TextScaler {
  const _NonlinearSelectTextScaler();

  @override
  double get textScaleFactor => 1;

  @override
  double scale(double fontSize) => switch (fontSize) {
    16 => 24,
    14 => 17.5,
    _ => fontSize,
  };
}
