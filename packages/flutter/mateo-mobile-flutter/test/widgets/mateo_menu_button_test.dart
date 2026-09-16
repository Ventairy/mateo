import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart' show SemanticsAction;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile_old/mateo_mobile_old.dart';
import 'package:mateo_mobile_old/src/components/mateo_button/mateo_button.dart' show MateoButton, MateoButtonScope;
import 'package:oh_my_flutter/oh_my_flutter.dart';

import '../test_app.dart';

const _panelPositionKey = Key('mateo_menu_button_panel_position');
const _sourceSemanticsKey = Key('mateo_menu_button_source_semantics');

void main() {
  testWidgets('when a presentation overrides colors, the menu should preserve them through opening and closing', (
    tester,
  ) async {
    const surfaceKey = Key('mateo_menu_button_source_background');
    await tester.pumpWidget(
      TestApp(
        child: MateoMenuButton(
          menuPresentation: const MateoMenuPresentation.action(),
          buttonPresentation: MateoButtonPresentation.label(
            label: 'Options',
            variant: MateoButtonVariant.primary,
            colorScheme: mateoTestColorScheme.buttons.primary.accent.copyWith(background: Colors.orange),
          ),
          items: [_action('Share')],
        ),
      ),
    );
    expect(find.byKey(surfaceKey), findsOneWidget);
    expect((tester.widget<Container>(find.byKey(surfaceKey)).decoration! as BoxDecoration).color, Colors.orange);
    await tester.tap(find.text('Options'));
    await tester.pumpAndSettle();
    expect(find.text('Share'), findsOneWidget);
    await tester.tap(find.text('Share'));
    await tester.pumpAndSettle();
    expect(find.byKey(surfaceKey), findsOneWidget);
    expect(find.text('Options'), findsOneWidget);
  });

  testWidgets('when an icon presentation triggers a menu, it should open and restore the circular control', (
    tester,
  ) async {
    final presentation = MateoButtonPresentation.icon(
      semanticLabel: 'More options',
      variant: MateoButtonVariant.secondary,
      iconBuilder: (state) => Icon(Icons.more_horiz, color: state.foregroundColor, size: state.iconSize),
    );
    await tester.pumpWidget(
      TestApp(
        child: Center(
          child: MateoMenuButton(
            menuPresentation: const MateoMenuPresentation.action(),
            buttonPresentation: presentation,
            items: [_action('Share')],
          ),
        ),
      ),
    );
    final trigger = tester.widget<MateoButton>(find.byType(MateoButton));
    expect(trigger.presentation, presentation);
    expect(tester.getSize(find.byType(MateoButton)), const Size(53, 53));
    await tester.tap(find.byType(MateoButton));
    await tester.pumpAndSettle();
    expect(find.text('Share'), findsOneWidget);
    await tester.tap(find.text('Share'));
    await tester.pumpAndSettle();
    expect(find.text('Share'), findsNothing);
    expect(tester.getSize(find.byType(MateoButton)), const Size(53, 53));
  });

  group('MateoMenuButton', () {
    test('when actions are empty, it should reject the list', () {
      expect(
        () => MateoMenuButton(
          menuPresentation: const MateoMenuPresentation.action(),
          buttonPresentation: MateoButtonPresentation.label(
            label: 'More',
            variant: MateoButtonVariant.secondary,
          ),
          items: const [],
        ),
        throwsAssertionError,
      );
    });

    test('when action text is empty, it should reject inaccessible content', () {
      expect(
        () => MateoMenuItem(title: ''),
        throwsAssertionError,
      );
      expect(
        () => MateoMenuItem(
          title: 'Share',
          description: '',
        ),
        throwsAssertionError,
      );
    });

    test('when the caller mutates actions, it should preserve its copied list', () {
      final actions = [_action('Share')];
      final button = MateoMenuButton(
        menuPresentation: const MateoMenuPresentation.action(),
        buttonPresentation: MateoButtonPresentation.label(
          label: 'More',
          variant: MateoButtonVariant.secondary,
        ),
        items: actions,
      );

      actions.clear();

      expect(button.items, hasLength(1));
      expect(button.items.clear, throwsUnsupportedError);
    });

    testWidgets('when built, it should forward every trigger property', (
      tester,
    ) async {
      const colorScheme = MateoButtonColorScheme(
        background: Colors.red,
        backgroundPressed: Colors.orange,
        foreground: Colors.white,
        backgroundDisabled: Colors.grey,
        foregroundDisabled: Colors.black38,
      );
      final presentation = MateoButtonPresentation.label(
        label: 'Options',
        variant: MateoButtonVariant.primary.neutral,
        leadingIconBuilder: (_) => const Icon(Icons.add),
        trailingIconBuilder: (_) => const Icon(Icons.expand_more),
        colorScheme: colorScheme,
        alignment: MateoButtonAlignment.left,
        fit: MateoButtonFit.expand,
        padding: const EdgeInsets.all(7),
      );
      await tester.pumpWidget(
        TestApp(
          child: MateoMenuButton(
            menuPresentation: const MateoMenuPresentation.action(),
            buttonPresentation: presentation,
            items: [_action('Share')],
          ),
        ),
      );

      final trigger = tester.widget<MateoButton>(find.byType(MateoButton));
      expect(trigger.presentation, presentation);
      expect(trigger.presentation.variant, MateoButtonVariant.primary.neutral);

      expect(trigger.presentation.colorScheme, colorScheme);
      expect(find.text('Options'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.expand_more), findsOneWidget);
      expect(tester.widget<Padding>(find.byKey(const Key('mateo_button_container'))).padding, const EdgeInsets.all(7));
      expect(tester.widget<MateoButtonScope>(find.byType(MateoButtonScope)).backgroundBuilder, isNotNull);
    });

    testWidgets('when opened, it should resolve every action state from the shared menu colors', (tester) async {
      final states = <MateoMenuItemState>[];
      await tester.pumpWidget(
        TestApp(
          child: MateoMenuButton(
            buttonPresentation: MateoButtonPresentation.label(
              label: 'More',
              variant: MateoButtonVariant.secondary,
            ),
            menuPresentation: const MateoMenuPresentation.action(),
            items: [
              _action(
                'Enabled',
                description: 'Enabled description',
                leadingIconBuilder: (state) {
                  states.add(state);
                  return const Icon(Icons.check);
                },
              ),
              MateoMenuItem(
                title: 'Disabled',
                description: 'Disabled description',
                leadingIconBuilder: (state) {
                  states.add(state);
                  return const Icon(Icons.close);
                },
              ),
            ],
          ),
        ),
      );

      await _openMenu(tester);

      final expected = mateoTestColorScheme.menu.action;
      final enabled = states.lastWhere((state) => state.isEnabled);
      final disabled = states.lastWhere((state) => !state.isEnabled);
      expect(enabled.iconColor, expected.icon);
      expect(enabled.titleColor, expected.title);
      expect(enabled.descriptionColor, expected.description);
      expect(disabled.iconColor, expected.iconDisabled);
      expect(disabled.titleColor, expected.titleDisabled);
      expect(disabled.descriptionColor, expected.descriptionDisabled);
      final surface = tester.widget<Container>(
        find.byKey(const ValueKey('mateo_menu_button_menu_surface')),
      );
      expect(
        (surface.decoration! as BoxDecoration).color,
        expected.background,
      );
      expect(tester.widget<Text>(find.text('Enabled')).style!.color, expected.title);
      expect(
        tester.widget<Text>(find.text('Disabled')).style!.color,
        expected.titleDisabled,
      );
      expect(
        tester.widget<Text>(find.text('Enabled description')).style!.color,
        expected.description,
      );
      expect(
        tester.widget<Text>(find.text('Disabled description')).style!.color,
        expected.descriptionDisabled,
      );
      expect(
        tester
            .widget<AnimatedModalBarrier>(
              find.byKey(const Key('mateo_menu_button_barrier')),
            )
            .color
            .value,
        expected.scrim,
      );
    });

    testWidgets('when opened, it should show optional action content in caller order', (tester) async {
      await _pumpMenu(
        tester,
        items: [
          _action(
            'Share',
            description: 'Send this item',
            leadingIconBuilder: (_) => const Icon(
              Icons.share,
              key: Key('share_icon'),
              size: 19,
            ),
          ),
          _action('Duplicate'),
        ],
      );

      await _openMenu(tester);

      expect(find.byKey(const Key('share_icon')), findsOneWidget);
      expect(find.text('Send this item'), findsOneWidget);
      expect(find.text('Duplicate'), findsOneWidget);
      final tops = [
        tester.getTopLeft(find.text('Share')).dy,
        tester.getTopLeft(find.text('Duplicate')).dy,
      ];
      expect(tops, orderedEquals([...tops]..sort()));
    });

    testWidgets('when opened, action press areas should own all menu whitespace', (tester) async {
      final pressed = <String>[];
      await _pumpMenu(
        tester,
        items: [
          _action('First', onPressed: (_) => pressed.add('First')),
          _action('Second', onPressed: (_) => pressed.add('Second')),
        ],
      );
      await _openMenu(tester);

      final panelRect = tester.getRect(find.byKey(_panelPositionKey));
      final firstTapRect = tester.getRect(
        find.ancestor(
          of: find.text('First'),
          matching: find.byType(MateoTap),
        ),
      );
      final secondTapRect = tester.getRect(
        find.ancestor(
          of: find.text('Second'),
          matching: find.byType(MateoTap),
        ),
      );

      expect(firstTapRect.left, panelRect.left);
      expect(firstTapRect.right, panelRect.right);
      expect(firstTapRect.top, panelRect.top);
      expect(firstTapRect.bottom, secondTapRect.top);
      expect(secondTapRect.left, panelRect.left);
      expect(secondTapRect.right, panelRect.right);
      expect(secondTapRect.bottom, panelRect.bottom);

      await tester.tapAt(Offset(panelRect.center.dx, panelRect.top + 1));
      await tester.pump();
      expect(pressed, ['First']);
      await tester.pumpAndSettle();

      await _openMenu(tester);
      await tester.tapAt(
        Offset(panelRect.left + 12, firstTapRect.center.dy),
      );
      await tester.pump();
      expect(pressed, ['First', 'First']);
      await tester.pumpAndSettle();

      await _openMenu(tester);
      await tester.tapAt(Offset(panelRect.center.dx, panelRect.bottom - 1));
      await tester.pump();
      expect(pressed, ['First', 'First', 'Second']);
      await tester.pumpAndSettle();

      await _openMenu(tester);
      await tester.tapAt(
        Offset(panelRect.center.dx, firstTapRect.bottom - 1),
      );
      await tester.pump();
      expect(pressed, ['First', 'First', 'Second', 'First']);
      await tester.pumpAndSettle();

      await _openMenu(tester);
      await tester.tapAt(
        Offset(panelRect.center.dx, secondTapRect.top + 1),
      );
      await tester.pump();
      expect(pressed, ['First', 'First', 'Second', 'First', 'Second']);
    });

    testWidgets('when opened, it should build each leading icon once per session', (tester) async {
      var buildCount = 0;
      await _pumpMenu(
        tester,
        items: [
          for (var index = 0; index < 3; index += 1)
            _action(
              'Action $index',
              leadingIconBuilder: (_) {
                buildCount += 1;
                return const Icon(Icons.check);
              },
            ),
        ],
      );

      await _openMenu(tester);
      expect(buildCount, 3);

      await tester.pump();
      expect(buildCount, 3);
    });

    testWidgets('when an action icon needs live constraints, it should lay out normally', (tester) async {
      await _pumpMenu(
        tester,
        items: [
          _action(
            'Responsive icon',
            leadingIconBuilder: (_) => LayoutBuilder(
              builder: (context, constraints) {
                return SizedBox(
                  width: constraints.constrainWidth(20),
                  height: 20,
                  child: const Icon(Icons.check),
                );
              },
            ),
          ),
        ],
      );

      await _openMenu(tester);

      expect(tester.takeException(), isNull);
      expect(find.text('Responsive icon'), findsOneWidget);
    });

    testWidgets('when opening, it should keep the source Morph mounted until the destination is ready', (
      tester,
    ) async {
      await _pumpMenu(tester, items: [_action('Share')]);

      await tester.tap(find.text('More'));
      await tester.pump();

      expect(
        find.byKey(const ValueKey('mateo_menu_button_source_surface')),
        findsOneWidget,
      );
    });

    testWidgets('when the default surface opens, it should use compatible direct Container endpoints', (tester) async {
      const sourceColor = Color(0xFF000000);
      await tester.pumpWidget(
        TestApp(
          child: MateoMenuButton(
            menuPresentation: const MateoMenuPresentation.action(),
            buttonPresentation: MateoButtonPresentation.label(
              label: 'More',
              variant: MateoButtonVariant.primary,
              colorScheme: const MateoButtonColorScheme(
                background: sourceColor,
                backgroundPressed: sourceColor,
                foreground: Colors.white,
                backgroundDisabled: Colors.black38,
                foregroundDisabled: Colors.white38,
              ),
            ),
            items: [_action('Share')],
          ),
        ),
      );

      final source = tester.widget<Morph>(
        find.byKey(const ValueKey('mateo_menu_button_source_surface')),
      );
      expect(source.child, isA<Container>());
      expect((source.child as Container).clipBehavior, Clip.antiAlias);
      expect(source.switchThreshold, 0.5);

      final sourceContent = tester.widget<MorphDescendant>(
        find.descendant(
          of: find.byKey(
            const ValueKey('mateo_menu_button_source_background'),
          ),
          matching: find.byType(MorphDescendant),
        ),
      );
      expect(
        sourceContent.flightBehavior,
        MorphDescendantFlightBehavior.snapshot,
      );

      await _openMenu(tester);

      expect(
        find.byKey(const Key('mateo_menu_button_source_placeholder')),
        findsNothing,
      );
      expect(
        find.byKey(const ValueKey('mateo_menu_button_source_surface')),
        findsOneWidget,
      );
      expect(find.byType(RawMenuAnchor), findsNothing);
      final endpoints = tester.widgetList<Morph>(find.byType(Morph)).where((morph) => morph.tag == source.tag).toList();
      expect(endpoints, hasLength(2));
      final destination = endpoints.singleWhere(
        (morph) => morph.child.key == const ValueKey('mateo_menu_button_menu_surface'),
      );
      expect(destination.child, isA<Container>());
      expect((destination.child as Container).clipBehavior, Clip.antiAlias);
      expect(destination.switchThreshold, 0.5);

      expect(
        find.descendant(
          of: find.byKey(
            const ValueKey('mateo_menu_button_menu_surface'),
          ),
          matching: find.byType(ClipRRect),
        ),
        findsNothing,
      );
      expect(find.byType(Scrollable), findsNothing);
      expect(find.byType(OverflowBox), findsNothing);
      expect(find.byType(FittedBox), findsNothing);
      final menuContent = tester.widget<MorphDescendant>(
        find.descendant(
          of: find.byKey(
            const ValueKey('mateo_menu_button_menu_surface'),
          ),
          matching: find.byType(MorphDescendant),
        ),
      );
      expect(
        menuContent.flightBehavior,
        MorphDescendantFlightBehavior.snapshot,
      );
    });

    testWidgets('when the popup route opens, it should keep the trigger and surrounding layout in place', (
      tester,
    ) async {
      const siblingKey = Key('menu_button_layout_sibling');
      await tester.pumpWidget(
        TestApp(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MateoMenuButton(
                menuPresentation: const MateoMenuPresentation.action(),
                buttonPresentation: MateoButtonPresentation.label(
                  label: 'More',
                  variant: MateoButtonVariant.secondary,
                ),
                items: [_action('Share')],
              ),
              const SizedBox(key: siblingKey, width: 20, height: 20),
            ],
          ),
        ),
      );
      final sourceRect = tester.getRect(find.byType(MateoButton));
      final siblingRect = tester.getRect(find.byKey(siblingKey));

      await _openMenu(tester);

      expect(tester.getRect(find.byType(MateoButton)), sourceRect);
      expect(tester.getRect(find.byKey(siblingKey)), siblingRect);
    });

    testWidgets('when opened, it should use the menu padding and action spacing', (tester) async {
      await _pumpMenu(
        tester,
        items: [_action('Share'), _action('Duplicate'), _action('Delete')],
      );

      await _openMenu(tester);

      final panelRect = tester.getRect(find.byKey(_panelPositionKey));
      final actionRects = [
        for (final label in ['Share', 'Duplicate', 'Delete'])
          tester.getRect(
            find.ancestor(
              of: find.text(label),
              matching: find.byType(Row),
            ),
          ),
      ];
      expect(actionRects.first.left - panelRect.left, 25);
      expect(panelRect.right - actionRects.first.right, 25);
      expect(actionRects.first.top - panelRect.top, 22);
      expect(actionRects[1].top - actionRects[0].bottom, 26);
      expect(actionRects[2].top - actionRects[1].bottom, 26);
      expect(panelRect.bottom - actionRects.last.bottom, 22);
    });

    testWidgets('when action text is long, it should cap title and description at two lines', (tester) async {
      const title = 'A deliberately long title that needs more than two lines to render in a narrow menu';
      const description = 'A deliberately long description that also needs more than two lines to render completely';
      await _pumpMenu(
        tester,
        width: 240,
        items: [_action(title, description: description)],
      );
      await _openMenu(tester);

      final titleText = tester.widget<Text>(find.text(title));
      final descriptionText = tester.widget<Text>(find.text(description));
      expect(titleText.maxLines, 2);
      expect(titleText.overflow, TextOverflow.ellipsis);
      expect(descriptionText.maxLines, 2);
      expect(descriptionText.overflow, TextOverflow.ellipsis);
    });

    testWidgets('when an action is disabled, it should neither close nor invoke it', (tester) async {
      await _pumpMenu(
        tester,
        items: [
          const MateoMenuItem(title: 'Unavailable'),
          _action('Share'),
        ],
      );
      await _openMenu(tester);

      await tester.tap(find.text('Unavailable'));
      await tester.pumpAndSettle();

      expect(find.byKey(_panelPositionKey), findsOneWidget);
      final actionTap = tester.widget<MateoTap>(
        find.ancestor(
          of: find.text('Unavailable'),
          matching: find.byType(MateoTap),
        ),
      );
      expect(actionTap.onPressed, isNull);
    });

    testWidgets('when an action is selected, it should pass the pending menu-close future', (tester) async {
      Future<void>? receivedClose;
      var closeCompleted = false;
      await _pumpMenu(
        tester,
        items: [
          _action(
            'Share',
            onPressed: (closeAnimation) {
              receivedClose = closeAnimation;
              closeAnimation.then((_) => closeCompleted = true);
            },
          ),
        ],
      );
      await _openMenu(tester);

      await tester.tap(find.text('Share'));

      expect(receivedClose, isNotNull);
      expect(closeCompleted, isFalse);
      await tester.pump();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 90));
      expect(closeCompleted, isFalse);

      await tester.pumpAndSettle();
      expect(closeCompleted, isTrue);
      expect(find.byKey(_panelPositionKey), findsNothing);
    });

    testWidgets('when the scrim is tapped, it should close the menu', (
      tester,
    ) async {
      await _pumpMenu(tester);
      await _openMenu(tester);

      final barrier = tester.widget<AnimatedModalBarrier>(
        find.byKey(const Key('mateo_menu_button_barrier')),
      );
      expect(barrier.dismissible, isTrue);
      expect(
        barrier.color.value,
        mateoTestColorScheme.menu.action.scrim,
      );

      await tester.tapAt(const Offset(8, 8));
      await tester.pumpAndSettle();
      expect(find.byKey(_panelPositionKey), findsNothing);
    });

    testWidgets('when system Back is invoked, it should close before the route', (tester) async {
      await _pumpMenu(tester);
      await _openMenu(tester);

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      expect(find.byKey(_panelPositionKey), findsNothing);
      expect(find.byType(MateoMenuButton), findsOneWidget);
    });

    testWidgets('when Escape is pressed, it should close the menu', (
      tester,
    ) async {
      await _pumpMenu(tester);
      await _openMenu(tester);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();

      expect(find.byKey(_panelPositionKey), findsNothing);
    });

    testWidgets('when the menu fits above, it should align its bottom with the trigger bottom', (tester) async {
      await _pumpMenu(
        tester,
        alignment: Alignment.bottomCenter,
        items: [_action('Share'), _action('Duplicate')],
      );
      final sourceRect = tester.getRect(find.byType(MateoButton));
      await _openMenu(tester);
      final panelRect = tester.getRect(find.byKey(_panelPositionKey));

      expect(panelRect.bottom, moreOrLessEquals(sourceRect.bottom));
      expect(panelRect.top, lessThan(sourceRect.top));
    });

    testWidgets('when the menu does not fit above, it should open downward from the trigger top', (tester) async {
      await _pumpMenu(
        tester,
        alignment: Alignment.topCenter,
        items: [_action('Share'), _action('Duplicate')],
      );
      final sourceRect = tester.getRect(find.byType(MateoButton));
      await _openMenu(tester);
      final panelRect = tester.getRect(find.byKey(_panelPositionKey));

      expect(panelRect.top, moreOrLessEquals(sourceRect.top));
      expect(panelRect.bottom, greaterThan(sourceRect.bottom));
    });

    testWidgets('when opened, it should fill the overlay width with twelve-point gutters', (tester) async {
      await _pumpMenu(tester, width: 400);
      await _openMenu(tester);

      final panelRect = tester.getRect(find.byKey(_panelPositionKey));
      expect(panelRect.left, 12);
      expect(panelRect.right, 388);
    });

    testWidgets('when animations are disabled, it should open and close immediately', (tester) async {
      await _pumpMenu(tester, disableAnimations: true);

      await tester.tap(find.text('More'));
      await tester.pump();
      await tester.pump();
      await tester.pump();
      expect(find.byKey(_panelPositionKey), findsOneWidget);

      await tester.tapAt(const Offset(8, 8));
      await tester.pump();
      await tester.pump();
      expect(find.byKey(_panelPositionKey), findsNothing);
    });

    testWidgets('when actions rebuild while open, it should preserve the open-session snapshot', (tester) async {
      late StateSetter rebuild;
      var actions = [_action('Original')];
      await tester.pumpWidget(
        TestApp(
          child: StatefulBuilder(
            builder: (context, setState) {
              rebuild = setState;
              return MateoMenuButton(
                menuPresentation: const MateoMenuPresentation.action(),
                buttonPresentation: MateoButtonPresentation.label(
                  label: 'More',
                  variant: MateoButtonVariant.secondary,
                ),
                items: actions,
              );
            },
          ),
        ),
      );
      await _openMenu(tester);

      rebuild(() => actions = [_action('Replacement')]);
      await tester.pump();

      expect(find.text('Original'), findsOneWidget);
      expect(find.text('Replacement'), findsNothing);
    });

    testWidgets('when closing completes, it should restore the previously focused control', (tester) async {
      final previousFocus = FocusNode(debugLabel: 'previous focus');
      addTearDown(previousFocus.dispose);
      await tester.pumpWidget(
        TestApp(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                focusNode: previousFocus,
                onPressed: () {},
                child: const Text('Previous'),
              ),
              MateoMenuButton(
                menuPresentation: const MateoMenuPresentation.action(),
                buttonPresentation: MateoButtonPresentation.label(
                  label: 'More',
                  variant: MateoButtonVariant.secondary,
                ),
                items: [_action('Share')],
              ),
            ],
          ),
        ),
      );
      previousFocus.requestFocus();
      await tester.pump();
      expect(previousFocus.hasFocus, isTrue);

      await _openMenu(tester);
      await tester.tapAt(const Offset(8, 8));
      await tester.pumpAndSettle();

      expect(previousFocus.hasFocus, isTrue);
    });

    testWidgets('when disposed while closing, it should complete the action close future', (tester) async {
      Future<void>? closeAnimation;
      var completed = false;
      await _pumpMenu(
        tester,
        items: [
          _action(
            'Share',
            onPressed: (animation) {
              closeAnimation = animation;
              animation.then((_) => completed = true);
            },
          ),
        ],
      );
      await _openMenu(tester);
      await tester.tap(find.text('Share'));
      expect(closeAnimation, isNotNull);
      expect(completed, isFalse);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();

      expect(completed, isTrue);
    });

    testWidgets('when safe-area and keyboard insets are present, it should keep the full-width menu inside them', (
      tester,
    ) async {
      tester.view
        ..devicePixelRatio = 1
        ..physicalSize = const Size(400, 800)
        ..padding = const FakeViewPadding(
          left: 20,
          top: 24,
          right: 28,
          bottom: 20,
        )
        ..viewInsets = const FakeViewPadding(bottom: 200);
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        TestApp(
          child: MediaQuery(
            data: const MediaQueryData(
              size: Size(400, 800),
            ),
            child: Align(
              alignment: Alignment.topCenter,
              child: MateoMenuButton(
                menuPresentation: const MateoMenuPresentation.action(),
                buttonPresentation: MateoButtonPresentation.label(
                  label: 'More',
                  variant: MateoButtonVariant.secondary,
                ),
                items: [for (var index = 0; index < 3; index += 1) _action('Action $index')],
              ),
            ),
          ),
        ),
      );
      await _openMenu(tester);

      final panelRect = tester.getRect(find.byKey(_panelPositionKey));
      final viewData = MediaQueryData.fromView(tester.view);
      expect(panelRect.left, 32);
      expect(panelRect.right, 360);
      expect(panelRect.top, greaterThanOrEqualTo(24));
      expect(
        panelRect.bottom,
        lessThanOrEqualTo(
          800 - viewData.padding.bottom - viewData.viewInsets.bottom,
        ),
      );
    });

    testWidgets('when accessibility activates the source and action, it should preserve button semantics', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      try {
        var calls = 0;
        await _pumpMenu(
          tester,
          items: [
            _action(
              'Share',
              description: 'Send this item',
              onPressed: (_) => calls += 1,
            ),
          ],
        );

        final source = tester.getSemantics(find.byKey(_sourceSemanticsKey));
        source.owner!.performAction(source.id, SemanticsAction.tap);
        await tester.pumpAndSettle();

        final action = tester.getSemantics(find.text('Share'));
        action.owner!.performAction(action.id, SemanticsAction.tap);
        await tester.pumpAndSettle();

        expect(calls, 1);
      } finally {
        semantics.dispose();
      }
    });

    testWidgets('when multiple buttons are mounted, each should own a distinct Morph tag', (tester) async {
      await tester.pumpWidget(
        TestApp(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MateoMenuButton(
                menuPresentation: const MateoMenuPresentation.action(),
                buttonPresentation: MateoButtonPresentation.label(
                  label: 'First',
                  variant: MateoButtonVariant.secondary,
                ),
                items: [_action('One')],
              ),
              MateoMenuButton(
                menuPresentation: const MateoMenuPresentation.action(),
                buttonPresentation: MateoButtonPresentation.label(
                  label: 'Second',
                  variant: MateoButtonVariant.secondary,
                ),
                items: [_action('Two')],
              ),
            ],
          ),
        ),
      );

      final tags = tester.widgetList<Morph>(find.byType(Morph)).map((morph) => morph.tag).toList();
      expect(tags, hasLength(2));
      expect(identical(tags.first, tags.last), isFalse);
    });
  });
}

MateoMenuItem _action(
  String title, {
  String? description,
  MateoMenuItemLeadingIconBuilder? leadingIconBuilder,
  MateoMenuItemCallback? onPressed,
}) => MateoMenuItem(
  title: title,
  description: description,
  leadingIconBuilder: leadingIconBuilder,
  onPressed: onPressed ?? (_) {},
);

Future<void> _pumpMenu(
  WidgetTester tester, {
  List<MateoMenuItem>? items,
  Alignment alignment = Alignment.center,
  double width = 400,
  double height = 800,
  bool disableAnimations = false,
}) async {
  tester.view
    ..devicePixelRatio = 1
    ..physicalSize = Size(width, height);
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    TestApp(
      child: MediaQuery(
        data: MediaQueryData(
          size: Size(width, height),
          disableAnimations: disableAnimations,
        ),
        child: Align(
          alignment: alignment,
          child: MateoMenuButton(
            menuPresentation: const MateoMenuPresentation.action(),
            buttonPresentation: MateoButtonPresentation.label(
              label: 'More',
              variant: MateoButtonVariant.secondary,
            ),
            items: items ?? [_action('Share')],
          ),
        ),
      ),
    ),
  );
}

Future<void> _openMenu(WidgetTester tester) async {
  await tester.tap(find.text('More'));
  await tester.pump();
  await tester.pump();
  await tester.pumpAndSettle();
}
