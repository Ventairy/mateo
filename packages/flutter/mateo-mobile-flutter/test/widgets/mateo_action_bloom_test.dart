import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show PipelineOwner;
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import '../test_app.dart';

const _sourceKey = Key('action_bloom_source');
const _panelKey = Key('mateo_action_bloom_panel');
const _barrierKey = Key('mateo_action_bloom_barrier');

void main() {
  group('MateoActionBloom', () {
    for (final source in _BloomSource.values) {
      testWidgets(
        'when ${source.name} is tapped, it should open the shared action panel',
        (tester) async {
          await _pumpBloom(tester, source: source);

          await _openBloom(tester);

          expect(find.byKey(_panelKey), findsOneWidget);
          expect(find.text('Create'), findsOneWidget);
          expect(find.text('Delete'), findsOneWidget);
        },
      );
    }

    testWidgets(
      'when a factory receives fewer than two actions, it should reject the list',
      (_) async {
        expect(
          () => MateoButton.actionBloom(
            label: 'Actions',
            variant: MateoButtonVariant.primary,
            actions: [_action('Only action', Icons.add)],
          ),
          throwsAssertionError,
        );
        expect(
          () => MateoIconButton.actionBloom(
            actions: [_action('Only action', Icons.add)],
            iconBuilder: (state) => const Icon(Icons.more_horiz),
          ),
          throwsAssertionError,
        );
        expect(
          () => MateoFloatingActionButton.actionBloom(
            actions: [_action('Only action', Icons.add)],
            iconBuilder: (state) => const Icon(Icons.more_horiz),
          ),
          throwsAssertionError,
        );
      },
    );

    testWidgets('when closed, it should keep the overlay subtree unmounted', (
      tester,
    ) async {
      await _pumpBloom(tester);

      expect(find.byKey(_barrierKey), findsNothing);
      expect(find.byKey(_panelKey), findsNothing);
    });

    testWidgets(
      'when opening from the bottom, it should anchor the panel above the bottom safe area',
      (tester) async {
        await _pumpBloom(
          tester,
          mediaQueryData: const MediaQueryData(
            size: Size(400, 800),
            padding: EdgeInsets.only(top: 44, bottom: 34),
          ),
        );

        await _openBloom(tester);

        expect(
          tester.getRect(find.byKey(_panelKey)),
          isA<Rect>()
              .having((rect) => rect.left, 'left', 12)
              .having((rect) => 400 - rect.right, 'right', 12)
              .having((rect) => 800 - rect.bottom, 'bottom', 34),
        );
      },
    );

    testWidgets(
      'when opening from the top, it should anchor the panel below the top safe area',
      (tester) async {
        await _pumpBloom(
          tester,
          alignment: Alignment.topLeft,
          mediaQueryData: const MediaQueryData(
            size: Size(400, 800),
            padding: EdgeInsets.only(top: 44, bottom: 34),
          ),
        );

        await _openBloom(tester);

        expect(
          tester.getRect(find.byKey(_panelKey)),
          isA<Rect>()
              .having((rect) => rect.left, 'left', 12)
              .having((rect) => 400 - rect.right, 'right', 12)
              .having((rect) => rect.top, 'top', 44),
        );
      },
    );

    testWidgets(
      'when the source is equally distant from both safe edges, it should open from the bottom',
      (tester) async {
        await _pumpBloom(
          tester,
          alignment: Alignment.center,
          size: const Size(400, 800),
        );

        await _openBloom(tester);

        expect(tester.getRect(find.byKey(_panelKey)).bottom, 800);
      },
    );

    testWidgets(
      'when landscape safe areas are asymmetric, it should not count the panel inset twice',
      (tester) async {
        await _pumpBloom(
          tester,
          size: const Size(800, 400),
          mediaQueryData: const MediaQueryData(
            size: Size(800, 400),
            padding: EdgeInsets.fromLTRB(44, 0, 20, 21),
          ),
        );

        await _openBloom(tester);

        final panelRect = tester.getRect(find.byKey(_panelKey));
        final actionRect = tester.getRect(
          find.byKey(const ValueKey('create-action')),
        );
        expect(
          (
            panelRect.left,
            800 - panelRect.right,
            actionRect.left,
            800 - actionRect.right,
          ),
          (12, 12, 44, 26),
        );
      },
    );

    testWidgets(
      'when the keyboard is visible, it should stay above the keyboard and use the remaining safe height',
      (tester) async {
        await _pumpBloom(
          tester,
          mediaQueryData: const MediaQueryData(
            size: Size(400, 800),
            padding: EdgeInsets.only(top: 44),
            viewInsets: EdgeInsets.only(bottom: 300),
          ),
        );

        await _openBloom(tester);

        final panelRect = tester.getRect(find.byKey(_panelKey));
        expect(panelRect.bottom, 500);
        expect(panelRect.height, lessThanOrEqualTo((500 - 44) * 0.85));
      },
    );

    testWidgets(
      'when an action has a description, it should render the supporting text below its title',
      (tester) async {
        await _pumpBloom(
          tester,
          actions: [
            _action(
              'Create',
              Icons.add,
              description: 'Start with an empty workspace.',
            ),
            _action('Delete', Icons.delete),
          ],
        );

        await _openBloom(tester);

        expect(find.text('Start with an empty workspace.'), findsOneWidget);
        expect(
          tester.getTopLeft(find.text('Start with an empty workspace.')).dy,
          greaterThan(tester.getTopLeft(find.text('Create')).dy),
        );
      },
    );

    testWidgets(
      'when an action omits a description, it should reserve no description text',
      (tester) async {
        await _pumpBloom(tester);

        await _openBloom(tester);

        expect(find.text('Start with an empty workspace.'), findsNothing);
        expect(
          tester.getSize(find.byKey(const ValueKey('create-action'))).height,
          lessThan(80),
        );
      },
    );

    testWidgets(
      'when action colors resolve, it should use source and custom icon backgrounds',
      (tester) async {
        final iconStates = <MateoActionBloomActionIconState>[];

        await _pumpBloom(
          tester,
          backgroundColor: Colors.blue,
          foregroundColor: Colors.yellow,
          actions: [
            _action(
              'Create',
              Icons.add,
              key: const ValueKey('create-action'),
              onBuild: iconStates.add,
            ),
            _action(
              'Delete',
              Icons.delete,
              key: const ValueKey('delete-action'),
              iconBackgroundColor: Colors.purple,
              onBuild: iconStates.add,
            ),
          ],
        );

        await _openBloom(tester);

        expect(
          (
            _iconBackgroundColor(tester, const ValueKey('create-action')),
            _iconBackgroundColor(tester, const ValueKey('delete-action')),
            iconStates.last.foregroundColor,
            iconStates.last.iconSize,
            iconStates.last.animationProgress,
          ),
          (Colors.blue, Colors.purple, Colors.yellow, 24, 1),
        );
      },
    );

    testWidgets('when opening, it should use the approved timing and curve', (
      tester,
    ) async {
      var progress = 0.0;

      await _pumpBloom(
        tester,
        actions: [
          _action(
            'Create',
            Icons.add,
            onBuild: (state) => progress = state.animationProgress,
          ),
          _action('Delete', Icons.delete),
        ],
      );

      await tester.tap(find.byKey(_sourceKey));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 95));

      expect(progress, closeTo(Curves.easeOutCubic.transform(0.5), 0.001));

      await tester.pump(const Duration(milliseconds: 95));
      expect(progress, 1);

      await tester.tapAt(const Offset(200, 400));
      await tester.pumpAndSettle();
      expect(find.byKey(_panelKey), findsNothing);
    });

    testWidgets(
      'when an action is tapped twice, it should close and invoke its callback once',
      (tester) async {
        var invocationCount = 0;

        await _pumpBloom(
          tester,
          actions: [
            _action(
              'Create',
              Icons.add,
              onPressed: (feedbackAnimation) async => invocationCount += 1,
            ),
            _action('Delete', Icons.delete),
          ],
        );
        await _openBloom(tester);

        await tester.tap(find.text('Create'));
        await tester.tap(find.text('Create'));
        await tester.pumpAndSettle();

        expect(invocationCount, 1);
        expect(find.byKey(_panelKey), findsNothing);
      },
    );

    testWidgets(
      'when a callback awaits feedback, it should resume after press feedback completes',
      (tester) async {
        final callbackStarted = Completer<void>();
        var feedbackCompleted = false;

        await _pumpBloom(
          tester,
          actions: [
            _action(
              'Create',
              Icons.add,
              onPressed: (feedbackAnimation) async {
                callbackStarted.complete();
                await feedbackAnimation;
                feedbackCompleted = true;
              },
            ),
            _action('Delete', Icons.delete),
          ],
        );
        await _openBloom(tester);

        await tester.tap(find.text('Create'));
        await callbackStarted.future;

        expect(feedbackCompleted, isFalse);

        await tester.pumpAndSettle();

        expect(feedbackCompleted, isTrue);
      },
    );

    testWidgets(
      'when the source action list mutates after opening, it should preserve the open snapshot',
      (tester) async {
        final actions = _actions();
        await _pumpBloom(tester, actions: actions);

        await tester.tap(find.byKey(_sourceKey));
        await tester.pump();
        actions.clear();
        await tester.pumpAndSettle();

        expect(find.text('Create'), findsOneWidget);
        expect(find.text('Delete'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'when actions share a title, it should render both without duplicate-key errors',
      (tester) async {
        await _pumpBloom(
          tester,
          actions: [
            _action('Open', Icons.add, key: const ValueKey('open-first')),
            _action('Open', Icons.edit, key: const ValueKey('open-second')),
          ],
        );

        await _openBloom(tester);

        expect(find.text('Open'), findsNWidgets(2));
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'when the scrim is tapped, it should dismiss without invoking an action',
      (tester) async {
        var invocationCount = 0;

        await _pumpBloom(
          tester,
          actions: [
            _action(
              'Create',
              Icons.add,
              onPressed: (feedbackAnimation) async => invocationCount += 1,
            ),
            _action('Delete', Icons.delete),
          ],
        );
        await _openBloom(tester);

        expect(
          tester
              .widget<AnimatedModalBarrier>(find.byKey(_barrierKey))
              .color
              .value,
          mateoTestColorScheme.overlay.scrim,
        );

        await tester.tapAt(const Offset(200, 400));
        await tester.pumpAndSettle();

        expect(invocationCount, 0);
        expect(find.byKey(_panelKey), findsNothing);
      },
    );

    testWidgets(
      'when Escape is pressed, it should dismiss the panel without leaving the route',
      (tester) async {
        await _pumpBloom(tester);
        await _openBloom(tester);

        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        await tester.pumpAndSettle();

        expect(find.byKey(_panelKey), findsNothing);
        expect(find.byKey(_sourceKey), findsOneWidget);
      },
    );

    testWidgets(
      'when system back is requested, it should dismiss the panel without leaving the route',
      (tester) async {
        await _pumpBloom(tester);
        await _openBloom(tester);

        await tester.binding.handlePopRoute();
        await tester.pumpAndSettle();

        expect(find.byKey(_panelKey), findsNothing);
        expect(find.byKey(_sourceKey), findsOneWidget);
      },
    );

    testWidgets(
      'when animations are disabled, it should present and dismiss immediately',
      (tester) async {
        double? progress;

        await _pumpBloom(
          tester,
          disableAnimations: true,
          actions: [
            _action(
              'Create',
              Icons.add,
              onBuild: (state) => progress = state.animationProgress,
            ),
            _action('Delete', Icons.delete),
          ],
        );

        await tester.tap(find.byKey(_sourceKey));
        await tester.pump();

        expect(progress, 1);
        expect(find.byKey(_panelKey), findsOneWidget);

        await tester.tapAt(const Offset(200, 400));
        await tester.pump();

        expect(find.byKey(_panelKey), findsNothing);
      },
    );

    testWidgets(
      'when the safe viewport is short, it should constrain and scroll the actions',
      (tester) async {
        await _pumpBloom(
          tester,
          size: const Size(320, 240),
          actions: [
            for (var index = 0; index < 8; index++)
              _action(
                'Action $index',
                Icons.add,
                description: 'Supporting description',
              ),
          ],
        );

        await _openBloom(tester);

        expect(find.byType(SingleChildScrollView), findsOneWidget);
        expect(
          tester.getSize(find.byKey(_panelKey)).height,
          lessThanOrEqualTo(240 * 0.85),
        );
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets('when opened, it should expose modal action semantics', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();

      await _pumpBloom(tester, semanticLabel: 'Note actions');

      expect(find.bySemanticsLabel('Note actions'), findsOneWidget);

      await _openBloom(tester);

      expect(
        (
          tester
              .getSemantics(find.bySemanticsLabel('Create'))
              .flagsCollection
              .isButton,
          tester.getSemantics(find.bySemanticsLabel('Create')).hint,
        ),
        (true, ''),
      );
      semantics.dispose();
    });

    testWidgets(
      'when closed, it should expose the source as a collapsed control',
      (tester) async {
        final semantics = tester.ensureSemantics();

        await _pumpBloom(tester, semanticLabel: 'Note actions');

        final sourceSemantics = tester.getSemantics(
          find.bySemanticsLabel('Note actions'),
        );
        expect(
          (
            sourceSemantics.flagsCollection.isButton,
            sourceSemantics.flagsCollection.isExpanded.toBoolOrNull(),
          ),
          (true, false),
        );
        semantics.dispose();
      },
    );

    testWidgets(
      'when opened, it should block the source and underlying semantics',
      (tester) async {
        final semantics = tester.ensureSemantics();

        await _pumpBloom(tester, semanticLabel: 'Note actions');

        expect(
          _semanticLabels(tester),
          containsAll(['Underlying content', 'Note actions']),
        );

        await _openBloom(tester);

        expect(_semanticLabels(tester), contains('Create'));
        expect(
          _semanticLabels(tester),
          isNot(contains(anyOf('Underlying content', 'Note actions'))),
        );
        semantics.dispose();
      },
    );

    testWidgets(
      'when visible text is truncated, it should preserve complete action semantics',
      (tester) async {
        final semantics = tester.ensureSemantics();
        const title = 'Create a note with a deliberately complete long title';
        const description =
            'Start with a fresh note and preserve this complete explanation.';

        await _pumpBloom(
          tester,
          size: const Size(280, 500),
          actions: [
            _action(title, Icons.add, description: description),
            _action('Delete', Icons.delete),
          ],
        );
        await _openBloom(tester);

        final actionSemantics = tester.getSemantics(
          find.bySemanticsLabel(title),
        );
        expect(actionSemantics.label, title);
        expect(actionSemantics.hint, description);
        semantics.dispose();
      },
    );

    testWidgets(
      'when dismissed, it should restore the previously focused control',
      (tester) async {
        final sourceFocusNode = FocusNode(debugLabel: 'Action bloom source');
        addTearDown(sourceFocusNode.dispose);

        await _pumpBloom(tester, sourceFocusNode: sourceFocusNode);
        sourceFocusNode.requestFocus();
        await tester.pump();
        expect(sourceFocusNode.hasFocus, isTrue);

        await _openBloom(tester);
        expect(
          FocusManager.instance.primaryFocus,
          isNot(same(sourceFocusNode)),
        );

        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        await tester.pumpAndSettle();

        expect(FocusManager.instance.primaryFocus, same(sourceFocusNode));
      },
    );

    testWidgets(
      'when the source is disposed while open, it should clean up without errors',
      (tester) async {
        await _pumpBloom(tester);
        await _openBloom(tester);

        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.byKey(_panelKey), findsNothing);
      },
    );
  });
}

Future<void> _pumpBloom(
  WidgetTester tester, {
  _BloomSource source = _BloomSource.floating,
  Alignment alignment = Alignment.bottomRight,
  List<MateoActionBloomAction>? actions,
  MediaQueryData? mediaQueryData,
  Size size = const Size(400, 800),
  bool disableAnimations = false,
  String? semanticLabel,
  Color? backgroundColor,
  Color? foregroundColor,
  FocusNode? sourceFocusNode,
}) async {
  final resolvedMediaQueryData =
      mediaQueryData ??
      MediaQueryData(size: size, disableAnimations: disableAnimations);
  tester.view
    ..devicePixelRatio = 1
    ..physicalSize = size
    ..padding = FakeViewPadding(
      left: resolvedMediaQueryData.padding.left,
      top: resolvedMediaQueryData.padding.top,
      right: resolvedMediaQueryData.padding.right,
      bottom: resolvedMediaQueryData.padding.bottom,
    )
    ..viewPadding = FakeViewPadding(
      left: resolvedMediaQueryData.viewPadding.left,
      top: resolvedMediaQueryData.viewPadding.top,
      right: resolvedMediaQueryData.viewPadding.right,
      bottom: resolvedMediaQueryData.viewPadding.bottom,
    )
    ..viewInsets = FakeViewPadding(
      left: resolvedMediaQueryData.viewInsets.left,
      top: resolvedMediaQueryData.viewInsets.top,
      right: resolvedMediaQueryData.viewInsets.right,
      bottom: resolvedMediaQueryData.viewInsets.bottom,
    );
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    _ActionBloomTestApp(
      source: source,
      alignment: alignment,
      actions: actions ?? _actions(),
      mediaQueryData: resolvedMediaQueryData,
      semanticLabel: semanticLabel,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      sourceFocusNode: sourceFocusNode,
    ),
  );
}

Future<void> _openBloom(WidgetTester tester) async {
  await tester.tap(find.byKey(_sourceKey));
  await tester.pumpAndSettle();
}

List<MateoActionBloomAction> _actions() => [
  _action('Create', Icons.add, key: const ValueKey('create-action')),
  _action('Delete', Icons.delete, key: const ValueKey('delete-action')),
];

MateoActionBloomAction _action(
  String title,
  IconData icon, {
  Key? key,
  String? description,
  Color? iconBackgroundColor,
  MateoActionBloomActionCallback? onPressed,
  ValueChanged<MateoActionBloomActionIconState>? onBuild,
}) {
  return MateoActionBloomAction(
    key: key,
    title: title,
    description: description,
    iconBackgroundColor: iconBackgroundColor,
    iconBuilder: (state) {
      onBuild?.call(state);
      return Icon(icon, color: state.foregroundColor, size: state.iconSize);
    },
    onPressed: onPressed ?? (feedbackAnimation) async {},
  );
}

Color? _iconBackgroundColor(WidgetTester tester, Key actionKey) {
  return (tester
              .widget<DecoratedBox>(
                find.descendant(
                  of: find.byKey(actionKey),
                  matching: find.byType(DecoratedBox),
                ),
              )
              .decoration
          as BoxDecoration)
      .color;
}

Set<String> _semanticLabels(WidgetTester tester) {
  final labels = <String>{};

  void collect(SemanticsNode node) {
    if (node.label.isNotEmpty) labels.add(node.label);
    node.visitChildren((child) {
      collect(child);
      return true;
    });
  }

  void collectPipeline(PipelineOwner owner) {
    final root = owner.semanticsOwner?.rootSemanticsNode;
    if (root != null) collect(root);
    owner.visitChildren(collectPipeline);
  }

  collectPipeline(tester.binding.rootPipelineOwner);
  return labels;
}

enum _BloomSource { floating, button, icon }

class _ActionBloomTestApp extends StatelessWidget {
  const _ActionBloomTestApp({
    required this.source,
    required this.alignment,
    required this.actions,
    required this.mediaQueryData,
    this.semanticLabel,
    this.backgroundColor,
    this.foregroundColor,
    this.sourceFocusNode,
  });

  final _BloomSource source;
  final Alignment alignment;
  final List<MateoActionBloomAction> actions;
  final MediaQueryData mediaQueryData;
  final String? semanticLabel;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final FocusNode? sourceFocusNode;

  @override
  Widget build(BuildContext context) {
    final sourceWidget = switch (source) {
      _BloomSource.floating => MateoFloatingActionButton.actionBloom(
        key: _sourceKey,
        semanticLabel: semanticLabel ?? 'Note actions',
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        actions: actions,
        iconBuilder: (state) => Icon(
          Icons.more_horiz,
          color: state.foregroundColor,
          size: state.iconSize,
        ),
      ),
      _BloomSource.button => MateoButton.actionBloom(
        key: _sourceKey,
        label: 'Actions',
        variant: MateoButtonVariant.primary,
        actions: actions,
      ),
      _BloomSource.icon => MateoIconButton.actionBloom(
        key: _sourceKey,
        semanticLabel: semanticLabel ?? 'Note actions',
        backgroundColor: backgroundColor,
        actions: actions,
        iconBuilder: (state) => Icon(
          Icons.more_horiz,
          color: state.recommendedIconColor,
          size: state.iconSize,
        ),
      ),
    };

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: mateoTestTheme,
      home: MediaQuery(
        data: mediaQueryData,
        child: Scaffold(
          body: Stack(
            children: [
              Semantics(
                container: true,
                label: 'Underlying content',
                child: const SizedBox.expand(),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Align(
                  alignment: alignment,
                  child: sourceFocusNode == null
                      ? sourceWidget
                      : Focus(focusNode: sourceFocusNode, child: sourceWidget),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
