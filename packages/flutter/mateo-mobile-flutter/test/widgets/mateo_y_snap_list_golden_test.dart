import 'dart:async';

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile_old/mateo_mobile_old.dart';

import '../test_app.dart';

void main() {
  group('MateoYSnapList Golden Tests', () {
    goldenTest(
      'when rendering static states, it should match the approved goldens',
      fileName: 'mateo_y_snap_list_static',
      builder: () => GoldenTestGroup(
        scenarioConstraints: const BoxConstraints.tightFor(
          width: 400,
          height: 600,
        ),
        children: [
          GoldenTestScenario(
            name: 'current with next',
            child: const _GoldenFrame(
              child: _GoldenFeed(items: ['first', 'second']),
            ),
          ),
          GoldenTestScenario(
            name: 'single card',
            child: const _GoldenFrame(child: _GoldenFeed(items: ['solo'])),
          ),
          GoldenTestScenario(
            name: 'empty end',
            child: const _GoldenFrame(
              child: _GoldenFeed(items: [], showEndState: true),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'when rendering drag states, it should match the approved goldens',
      fileName: 'mateo_y_snap_list_drag_states',
      whilePerforming: (tester) async {
        await _holdDrag(tester, 'up_first', const Offset(0, -200));
        await tester.drag(
          find.byKey(_cardKey('down_first')),
          const Offset(0, -300),
        );
        await tester.pumpAndSettle();
        await _holdDrag(tester, 'down_second', const Offset(0, 200));
        await _holdDrag(tester, 'high_up_first', const Offset(0, -400));

        return null;
      },
      builder: () => GoldenTestGroup(
        scenarioConstraints: const BoxConstraints.tightFor(
          width: 400,
          height: 600,
        ),
        children: [
          GoldenTestScenario(
            name: 'up partial drag',
            child: const _GoldenFrame(
              child: _GoldenFeed(items: ['up_first', 'up_second']),
            ),
          ),
          GoldenTestScenario(
            name: 'down partial drag',
            child: const _GoldenFrame(
              child: _GoldenFeed(items: ['down_first', 'down_second']),
            ),
          ),
          GoldenTestScenario(
            name: 'high progress up drag',
            child: const _GoldenFrame(
              child: _GoldenFeed(items: ['high_up_first', 'high_up_second']),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'when handing off nested scroll boundaries, it should match the approved goldens',
      fileName: 'mateo_y_snap_list_nested_scroll_handoff',
      whilePerforming: (tester) async {
        await _holdNestedDrag(
          tester,
          item: 'nested_next_first',
          offset: const Offset(0, -200),
          startAtBottom: true,
        );

        final previousPosition = _nestedScrollPosition(
          tester,
          'nested_previous_first',
        );
        previousPosition.jumpTo(previousPosition.maxScrollExtent);
        await tester.pump();
        final advanceGesture = await tester.startGesture(
          tester.getCenter(find.byKey(_scrollKey('nested_previous_first'))),
        );
        await advanceGesture.moveBy(const Offset(0, -20));
        await tester.pump();
        await advanceGesture.moveBy(const Offset(0, -300));
        await tester.pump();
        await advanceGesture.up();
        await tester.pumpAndSettle();

        await _holdNestedDrag(
          tester,
          item: 'nested_previous_second',
          offset: const Offset(0, 200),
        );

        return null;
      },
      builder: () => GoldenTestGroup(
        scenarioConstraints: const BoxConstraints.tightFor(
          width: 400,
          height: 600,
        ),
        children: [
          GoldenTestScenario(
            name: 'partial next handoff',
            child: const _GoldenFrame(
              child: _GoldenScrollableFeed(
                items: ['nested_next_first', 'nested_next_second'],
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'partial previous handoff',
            child: const _GoldenFrame(
              child: _GoldenScrollableFeed(
                items: [
                  'nested_previous_first',
                  'nested_previous_second',
                ],
              ),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'when rendering after actions, it should match the approved goldens',
      fileName: 'mateo_y_snap_list_after_actions',
      whilePerforming: (tester) async {
        await tester.drag(
          find.byKey(_cardKey('next_first')),
          const Offset(0, -300),
        );
        await tester.pumpAndSettle();

        return null;
      },
      builder: () => GoldenTestGroup(
        scenarioConstraints: const BoxConstraints.tightFor(
          width: 400,
          height: 600,
        ),
        children: [
          GoldenTestScenario(
            name: 'after next',
            child: const _GoldenFrame(
              child: _GoldenFeed(items: ['next_first', 'next_second']),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'when rendering pagination states, it should match the approved goldens',
      fileName: 'mateo_y_snap_list_pagination_states',
      whilePerforming: (tester) async {
        await tester.pump();
        await tester.pump();
        await _holdDrag(tester, 'loading_await', const Offset(0, -200));

        return null;
      },
      builder: () => GoldenTestGroup(
        scenarioConstraints: const BoxConstraints.tightFor(
          width: 400,
          height: 600,
        ),
        children: [
          GoldenTestScenario(
            name: 'await drag with spinner',
            child: const _GoldenFrame(
              child: _GoldenFeed(
                items: ['loading_await'],
                isLoadingFixture: true,
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'pagination error',
            child: const _GoldenFrame(
              child: _GoldenFeed(items: [], showLoadMoreError: true),
            ),
          ),
          GoldenTestScenario(
            name: 'end state',
            child: const _GoldenFrame(
              child: _GoldenFeed(items: [], showEndState: true),
            ),
          ),
          GoldenTestScenario(
            name: 'early threshold',
            child: const _GoldenFrame(
              child: _GoldenFeed(
                items: ['first', 'second', 'third'],
                loadMoreThreshold: 0.5,
              ),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'when rendering an exhausted list during a drag, it should show the end card behind the outgoing card',
      fileName: 'mateo_y_snap_list_exhausted_drag',
      whilePerforming: (tester) async {
        await tester.pump();
        await tester.pump();
        await _holdDrag(tester, 'solo', const Offset(0, -200));

        return null;
      },
      builder: () => GoldenTestGroup(
        scenarioConstraints: const BoxConstraints.tightFor(
          width: 400,
          height: 600,
        ),
        children: [
          GoldenTestScenario(
            name: 'exhausted last card dragged up',
            child: const _GoldenFrame(
              child: _GoldenFeed(
                items: ['solo'],
                showEndState: true,
                isExhausted: true,
              ),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'when on the last card while loading more, it should translate the current card up by 200px and show a spinner below',
      fileName: 'mateo_y_snap_list_committed_await',
      whilePerforming: (tester) async {
        await tester.pump();
        await tester.pump();

        await tester.drag(
          find.byKey(_cardKey('ca_first')),
          const Offset(0, -300),
        );
        await tester.pumpAndSettle();

        await _holdDrag(tester, 'ca_second', const Offset(0, -200));

        return null;
      },
      builder: () => GoldenTestGroup(
        scenarioConstraints: const BoxConstraints.tightFor(
          width: 400,
          height: 600,
        ),
        children: [
          GoldenTestScenario(
            name: 'committed await',
            child: const _GoldenFrame(
              child: _GoldenFeed(
                items: ['ca_first', 'ca_second'],
                isLoadingFixture: true,
              ),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'when swiping down from the translated waiting state, it should restore the card to its original position and hide the spinner',
      fileName: 'mateo_y_snap_list_after_exit_await',
      whilePerforming: (tester) async {
        await tester.pump();
        await tester.pump();

        await tester.drag(
          find.byKey(_cardKey('exit_first')),
          const Offset(0, -300),
        );
        for (var i = 0; i < 20; i++) {
          await tester.pump(const Duration(milliseconds: 16));
        }

        var gesture = await tester.startGesture(
          tester.getCenter(find.byKey(_cardKey('exit_second'))),
        );
        await gesture.moveBy(const Offset(0, -200));
        await tester.pump();
        await gesture.up();
        await tester.pump();
        for (var i = 0; i < 20; i++) {
          await tester.pump(const Duration(milliseconds: 16));
        }

        gesture = await tester.startGesture(
          tester.getCenter(find.byKey(_cardKey('exit_second'))),
        );
        await gesture.moveBy(const Offset(0, 400));
        await tester.pump();
        await gesture.up();
        await tester.pump();
        for (var i = 0; i < 20; i++) {
          await tester.pump(const Duration(milliseconds: 16));
        }

        return null;
      },
      builder: () => GoldenTestGroup(
        scenarioConstraints: const BoxConstraints.tightFor(
          width: 400,
          height: 600,
        ),
        children: [
          GoldenTestScenario(
            name: 'after exit from await',
            child: const _GoldenFrame(
              child: _GoldenFeed(
                items: ['exit_first', 'exit_second'],
                isLoadingFixture: true,
              ),
            ),
          ),
        ],
      ),
    );
  });

  goldenTest(
    'when on the last card while loading more with custom loadingMoreOffset, it should translate the card up by the custom amount',
    fileName: 'mateo_y_snap_list_custom_offset_await',
    whilePerforming: (tester) async {
      await tester.pump();
      await tester.pump();

      await tester.drag(
        find.byKey(_cardKey('custom_first')),
        const Offset(0, -300),
      );
      await tester.pumpAndSettle();

      await _holdDrag(tester, 'custom_second', const Offset(0, -200));

      return null;
    },
    builder: () => GoldenTestGroup(
      scenarioConstraints: const BoxConstraints.tightFor(
        width: 400,
        height: 600,
      ),
      children: [
        GoldenTestScenario(
          name: 'custom offset await',
          child: const _GoldenFrame(
            child: _GoldenFeed(
              items: ['custom_first', 'custom_second'],
              isLoadingFixture: true,
              loadingMoreOffset: 1000,
            ),
          ),
        ),
      ],
    ),
  );

  goldenTest(
    'when rendering drag states with spacing, it should match the approved goldens',
    fileName: 'mateo_y_snap_list_spacing_drag_states',
    whilePerforming: (tester) async {
      await _holdDrag(tester, 'spacing_up_first', const Offset(0, -200));

      return null;
    },
    builder: () => GoldenTestGroup(
      scenarioConstraints: const BoxConstraints.tightFor(
        width: 400,
        height: 600,
      ),
      children: [
        GoldenTestScenario(
          name: 'spacing up partial drag',
          child: const _GoldenFrame(
            child: _GoldenFeed(
              items: ['spacing_up_first', 'spacing_up_second'],
              spacing: 40,
            ),
          ),
        ),
      ],
    ),
  );
}

Key _cardKey(String item) => Key('golden_card_$item');

Key _scrollKey(String item) => Key('golden_scroll_$item');

Future<void> _holdDrag(WidgetTester tester, String item, Offset offset) async {
  final gesture = await tester.startGesture(
    tester.getCenter(find.byKey(_cardKey(item))),
  );
  await gesture.moveBy(offset);
  await tester.pump();
}

Future<void> _holdNestedDrag(
  WidgetTester tester, {
  required String item,
  required Offset offset,
  bool startAtBottom = false,
}) async {
  final scrollFinder = find.byKey(_scrollKey(item));
  if (startAtBottom) {
    final position = _nestedScrollPosition(tester, item);
    position.jumpTo(position.maxScrollExtent);
    await tester.pump();
  }
  final gesture = await tester.startGesture(tester.getCenter(scrollFinder));
  await gesture.moveBy(Offset(0, offset.dy.sign * 20));
  await tester.pump();
  await gesture.moveBy(Offset(0, offset.dy - (offset.dy.sign * 20)));
  await tester.pump();
}

ScrollPosition _nestedScrollPosition(WidgetTester tester, String item) {
  return tester
      .state<ScrollableState>(
        find.descendant(
          of: find.byKey(_scrollKey(item)),
          matching: find.byType(Scrollable),
        ),
      )
      .position;
}

Widget _goldenCardBuilder(BuildContext context, String item, int index) {
  return switch (item) {
    'solo' => _GoldenCard(
      key: Key('golden_card_solo'),
      title: 'Entrega rapida',
      neighborhood: 'Bela Vista',
      pay: r'R$ 65',
      color: mateoTestColorScheme.toast.info.background,
    ),
    final String value when value.contains('second') => _GoldenCard(
      key: _cardKey(value),
      title: 'Ajuda em evento',
      neighborhood: 'Vila Madalena',
      pay: r'R$ 240',
      color: mateoTestThemeData.palette.green[9],
    ),
    _ => _GoldenCard(
      key: _cardKey(item),
      title: 'Garcom para hoje',
      neighborhood: 'Pinheiros',
      pay: r'R$ 180',
      color: mateoTestColorScheme.buttons.primary.accent.background,
    ),
  };
}

class _GoldenFeed extends StatelessWidget {
  const _GoldenFeed({
    required this.items,
    this.loadMoreThreshold = 1,
    this.loadingMoreOffset = 200,
    this.spacing = 0,
    this.isLoadingFixture = false,
    this.showLoadMoreError = false,
    this.showEndState = false,
    this.isExhausted = false,
  });

  final List<String> items;
  final double loadMoreThreshold;
  final double loadingMoreOffset;
  final double spacing;
  final bool isLoadingFixture;
  final bool showLoadMoreError;
  final bool showEndState;
  final bool isExhausted;

  @override
  Widget build(BuildContext context) {
    return MateoYSnapList<String>(
      items: (
        count: items.length,
        provider: (int i) => items[i],
        keyBuilder: null,
      ),
      loadMoreThreshold: loadMoreThreshold,
      loadingMoreOffset: loadingMoreOffset,
      spacing: spacing,
      onLoadMore: isLoadingFixture
          ? () => Completer<void>().future
          : isExhausted
          ? () async {}
          : null,
      loadMoreErrorBuilder: showLoadMoreError ? _loadMoreErrorBuilder : null,
      endBuilder: showEndState ? _endBuilder : null,
      builder: _goldenCardBuilder,
    );
  }
}

class _GoldenScrollableFeed extends StatelessWidget {
  const _GoldenScrollableFeed({required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return MateoYSnapList<String>(
      items: (
        count: items.length,
        provider: (int i) => items[i],
        keyBuilder: null,
      ),
      builder: (context, item, index) => SingleChildScrollView(
        key: _scrollKey(item),
        physics: const BouncingScrollPhysics(),
        child: SizedBox(
          height: 800,
          child: _goldenCardBuilder(context, item, index),
        ),
      ),
    );
  }
}

Widget _loadMoreErrorBuilder(BuildContext context, VoidCallback retry) {
  return _PaginationStateCard(
    title: 'Tente de novo',
    subtitle: 'Nao conseguimos carregar agora.',
    icon: Icons.refresh_rounded,
    color: mateoTestColorScheme.buttons.primary.accent.background,
    onPressed: retry,
  );
}

Widget _endBuilder(BuildContext context) {
  return _PaginationStateCard(
    title: 'Tudo visto',
    subtitle: 'Volte em breve para novas chances.',
    icon: Icons.check_rounded,
    color: mateoTestThemeData.palette.green[9],
  );
}

class _GoldenFrame extends StatelessWidget {
  const _GoldenFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: mateoTestColorScheme.background,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SizedBox.expand(child: child),
      ),
    );
  }
}

class _GoldenCard extends StatelessWidget {
  const _GoldenCard({
    required super.key,
    required this.title,
    required this.neighborhood,
    required this.pay,
    required this.color,
  });

  final String title;
  final String neighborhood;
  final String pay;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: mateoTestColorScheme.background,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 30,
            offset: Offset(0, 16),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(
                Icons.bolt_rounded,
                color: mateoTestColorScheme.background,
                size: 30,
              ),
            ),
            const Spacer(),
            Text(
              pay,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 6,
              runSpacing: 6,
              children: [
                const Icon(Icons.place_rounded, size: 18),
                Text(neighborhood),
                const SizedBox(width: 10),
                const Icon(Icons.schedule_rounded, size: 18),
                const Text('Agora'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PaginationStateCard extends StatelessWidget {
  const _PaginationStateCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.onPressed,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: mateoTestColorScheme.background,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 30,
            offset: Offset(0, 16),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                icon,
                color: mateoTestColorScheme.background,
                size: 32,
              ),
            ),
            SizedBox(height: 18),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
            SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: mateoTestColorScheme.text.tertiary,
              ),
            ),
            if (onPressed != null) ...[
              const SizedBox(height: 18),
              TextButton(onPressed: onPressed, child: const Text('Recarregar')),
            ],
          ],
        ),
      ),
    );
  }
}
