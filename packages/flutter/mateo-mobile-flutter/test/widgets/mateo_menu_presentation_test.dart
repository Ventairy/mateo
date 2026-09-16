import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile_old/mateo_mobile_old.dart';

import '../test_app.dart';

const _surfaceKey = ValueKey('mateo_menu_button_menu_surface');
const _trigger = MateoButtonPresentation.label(label: 'More', variant: MateoButtonVariant.primary);

void main() {
  Future<void> mount(WidgetTester tester, Widget child, {ThemeData? theme}) async {
    tester.view
      ..devicePixelRatio = 1
      ..physicalSize = const Size(400, 800);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(TestApp(theme: theme, child: child));
  }

  test('when factories are compared, they should retain widget compatibility by presentation', () {
    expect(
      Widget.canUpdate(const MateoMenuPresentation.action(), const MateoMenuPresentation.action()),
      isTrue,
    );
    expect(
      Widget.canUpdate(const MateoMenuPresentation.context(), const MateoMenuPresentation.context()),
      isTrue,
    );
    expect(
      Widget.canUpdate(const MateoMenuPresentation.context(), const MateoMenuPresentation.action()),
      isFalse,
    );
  });

  testWidgets('when action is explicitly selected, it should expand the menu', (tester) async {
    final button = MateoMenuButton(
      menuPresentation: const MateoMenuPresentation.action(),
      buttonPresentation: _trigger,
      items: [MateoMenuItem(title: 'Share')],
    );
    expect(Widget.canUpdate(button.menuPresentation, const MateoMenuPresentation.action()), isTrue);
    await mount(tester, button);
    await tester.tap(find.text('More'));
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byKey(_surfaceKey)).width, 376);
  });

  for (final preset in [
    (
      name: 'action',
      value: const MateoMenuPresentation.action(),
      spacing: 26.0,
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 22),
    ),
    (
      name: 'context',
      value: const MateoMenuPresentation.context(),
      spacing: 18.0,
      padding: const EdgeInsets.fromLTRB(20, 22, 40, 22),
    ),
  ]) {
    for (final direction in TextDirection.values) {
      testWidgets('when ${preset.name} opens in $direction, it should use its exact layout and clickable spacing', (
        tester,
      ) async {
        var selected = '';
        await mount(
          tester,
          Directionality(
            textDirection: direction,
            child: MateoMenuButton(
              buttonPresentation: _trigger,
              menuPresentation: preset.value,
              items: [
                MateoMenuItem(title: 'First', onPressed: (_) => selected = 'First'),
                MateoMenuItem(title: 'Last', onPressed: (_) => selected = 'Last'),
              ],
            ),
          ),
        );
        Future<void> open() async {
          await tester.tap(find.text('More'));
          await tester.pumpAndSettle();
        }

        await open();
        final surface = tester.getRect(find.byKey(_surfaceKey));
        final first = tester.getRect(find.text('First'));
        final last = tester.getRect(find.text('Last'));
        final row = tester.getRect(find.ancestor(of: find.text('First'), matching: find.byType(Row)));
        expect(last.top - first.bottom, preset.spacing);
        expect(first.top - surface.top, preset.padding.top);
        expect(surface.bottom - last.bottom, preset.padding.bottom);
        expect(row.left - surface.left, preset.padding.left);
        expect(surface.right - row.right, preset.padding.right);
        expect(surface.width, preset.name == 'action' ? 376 : lessThan(376));
        final boundary = first.bottom + preset.spacing / 2;
        for (final target in [
          (y: surface.top + 1, selected: 'First'),
          (y: boundary - 1, selected: 'First'),
          (y: boundary + 1, selected: 'Last'),
          (y: surface.bottom - 1, selected: 'Last'),
        ]) {
          await tester.tapAt(Offset(surface.center.dx, target.y));
          await tester.pumpAndSettle();
          expect(selected, target.selected);
          await open();
        }
      });
    }

    testWidgets('when ${preset.name} reads themed colors, it should apply disabled content and scrim', (tester) async {
      final menuColors = mateoTestColorScheme.menu;
      final scheme = (preset.name == 'action' ? menuColors.action : menuColors.context).copyWith(
        titleDisabled: Colors.purple,
        descriptionDisabled: Colors.blue,
        iconDisabled: Colors.red,
        scrim: Colors.green,
      );
      final otherScheme = scheme.copyWith(
        titleDisabled: Colors.orange,
        descriptionDisabled: Colors.yellow,
        iconDisabled: Colors.pink,
        scrim: Colors.teal,
      );
      MateoMenuItemState? state;
      await mount(
        tester,
        MateoMenuButton(
          buttonPresentation: _trigger,
          menuPresentation: preset.value,
          items: [
            MateoMenuItem(
              title: 'Disabled',
              description: 'Unavailable',
              leadingIconBuilder: (value) {
                state = value;
                return const Icon(Icons.add);
              },
            ),
          ],
        ),
        theme: mateoTestTheme.copyWith(
          extensions: [
            mateoTestThemeData.copyWith(
              colorScheme: mateoTestColorScheme.copyWith(
                menu: preset.name == 'action'
                    ? menuColors.copyWith(action: scheme, context: otherScheme)
                    : menuColors.copyWith(action: otherScheme, context: scheme),
              ),
            ),
          ],
        ),
      );
      await tester.tap(find.text('More'));
      await tester.pumpAndSettle();
      expect(state!.titleColor, scheme.titleDisabled);
      expect(state!.descriptionColor, scheme.descriptionDisabled);
      expect(state!.iconColor, scheme.iconDisabled);
      expect(
        tester.widget<AnimatedModalBarrier>(find.byKey(const Key('mateo_menu_button_barrier'))).color.value,
        scheme.scrim,
      );
      await tester.tap(find.text('Disabled'));
      await tester.pumpAndSettle();
      expect(find.byKey(_surfaceKey), findsOneWidget);
    });

    testWidgets('when ${preset.name} is reused, buttons should retain independent sessions', (tester) async {
      await mount(
        tester,
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final name in ['One', 'Two'])
              MateoMenuButton(
                buttonPresentation: MateoButtonPresentation.label(label: name, variant: MateoButtonVariant.primary),
                menuPresentation: preset.value,
                items: [MateoMenuItem(title: '$name action', onPressed: (_) {})],
              ),
          ],
        ),
      );
      for (final name in ['One', 'Two']) {
        await tester.tap(find.text(name));
        await tester.pumpAndSettle();
        expect(find.byKey(_surfaceKey), findsOneWidget);
        await tester.tap(find.text('$name action'));
        await tester.pumpAndSettle();
        expect(find.byKey(_surfaceKey), findsNothing);
      }
    });

    testWidgets('when ${preset.name} is disposed during entrance, it should remove its route and restore focus', (
      tester,
    ) async {
      final visible = ValueNotifier(true);
      final previousFocus = FocusNode();
      addTearDown(visible.dispose);
      addTearDown(previousFocus.dispose);
      var selected = 0;
      await mount(
        tester,
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(focusNode: previousFocus, onPressed: () {}, child: const Text('Previous')),
            ValueListenableBuilder<bool>(
              valueListenable: visible,
              builder: (_, show, _) => show
                  ? MateoMenuButton(
                      buttonPresentation: _trigger,
                      menuPresentation: preset.value,
                      items: [MateoMenuItem(title: 'Share', onPressed: (_) => selected++)],
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      );
      previousFocus.requestFocus();
      await tester.pump();
      await tester.tap(find.text('More'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 40));
      expect(find.byKey(_surfaceKey), findsOneWidget);

      visible.value = false;
      await tester.pumpAndSettle();
      expect(find.byKey(_surfaceKey), findsNothing);
      expect(previousFocus.hasFocus, isTrue);
      expect(selected, 0);
      expect(tester.takeException(), isNull);

      visible.value = true;
      await tester.pump();
      await tester.tap(find.text('More'));
      await tester.pumpAndSettle();
      expect(find.byKey(_surfaceKey), findsOneWidget);
      await tester.tap(find.text('Share'));
      await tester.pumpAndSettle();
      expect(selected, 1);
      expect(find.byKey(_surfaceKey), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('when ${preset.name} action navigates after closing, it should keep focus on the new route', (
      tester,
    ) async {
      final previousFocus = FocusNode();
      final destinationFocus = FocusNode();
      addTearDown(previousFocus.dispose);
      addTearDown(destinationFocus.dispose);
      await mount(
        tester,
        Builder(
          builder: (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(focusNode: previousFocus, onPressed: () {}, child: const Text('Previous')),
              MateoMenuButton(
                buttonPresentation: _trigger,
                menuPresentation: preset.value,
                items: [
                  MateoMenuItem(
                    title: 'Continue',
                    onPressed: (closed) async {
                      final navigator = Navigator.of(context);
                      await closed;
                      await navigator.push<void>(
                        MaterialPageRoute<void>(
                          builder: (_) => Scaffold(
                            body: TextButton(
                              focusNode: destinationFocus,
                              autofocus: true,
                              onPressed: () {},
                              child: const Text('Destination'),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      );
      previousFocus.requestFocus();
      await tester.pump();
      await tester.tap(find.text('More'));
      await tester.pumpAndSettle();
      expect(Focus.of(tester.element(find.byKey(_surfaceKey))).hasPrimaryFocus, isTrue);
      expect(previousFocus.hasFocus, isFalse);
      await tester.tap(find.text('Continue'));
      expect(find.text('Destination'), findsNothing);
      await tester.pumpAndSettle();

      expect(find.text('Destination'), findsOneWidget);
      expect(destinationFocus.hasPrimaryFocus, isTrue);
      expect(previousFocus.hasFocus, isFalse);
      await tester.pump(const Duration(milliseconds: 500));
      expect(destinationFocus.hasPrimaryFocus, isTrue);
      expect(tester.takeException(), isNull);
    });

    for (final phase in ['opening', 'open', 'closing']) {
      testWidgets(
        'when ${preset.name} is replaced while $phase, it should dispose its session',
        (tester) async {
          final selection = ValueNotifier(preset.value);
          addTearDown(selection.dispose);
          var closed = false;
          await mount(
            tester,
            ValueListenableBuilder<MateoMenuPresentation>(
              valueListenable: selection,
              builder: (_, value, _) => MateoMenuButton(
                buttonPresentation: _trigger,
                menuPresentation: value,
                items: [
                  MateoMenuItem(
                    title: 'Share',
                    onPressed: (future) async {
                      await future;
                      closed = true;
                    },
                  ),
                ],
              ),
            ),
          );
          await tester.tap(find.text('More'));
          if (phase == 'opening') {
            await tester.pump();
            await tester.pump(const Duration(milliseconds: 40));
          } else {
            await tester.pumpAndSettle();
            // A normal rebuild with the same presentation keeps the current route.
            tester.element(find.byType(MateoMenuButton)).markNeedsBuild();
            await tester.pumpAndSettle();
          }
          expect(find.byKey(_surfaceKey), findsOneWidget);
          if (phase == 'closing') await tester.tap(find.text('Share'));
          selection.value = preset.name == 'action'
              ? const MateoMenuPresentation.context()
              : const MateoMenuPresentation.action();
          await tester.pumpAndSettle();
          expect(find.byKey(_surfaceKey), findsNothing);
          expect(closed, phase == 'closing');
          expect(tester.takeException(), isNull);
          await tester.tap(find.text('More'));
          await tester.pumpAndSettle();
          expect(find.byKey(_surfaceKey), findsOneWidget);
        },
      );
    }
  }
}
