import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile_old/mateo_mobile_old.dart';

import '../test_app.dart';

void main() {
  group('MateoHeader Golden Tests', () {
    goldenTest(
      'when rendering view-header states, it should match the approved golden',
      fileName: 'mateo_header_states',
      whilePerforming: (tester) async {
        final scrolledList = tester.widget<ListView>(
          find.byKey(const ValueKey('scrolled_list')),
        );
        scrolledList.controller!.jumpTo(120);
        await tester.pump();
        return null;
      },
      builder: () => GoldenTestGroup(
        scenarioConstraints: const BoxConstraints.tightFor(
          width: 320,
          height: 180,
        ),
        children: [
          GoldenTestScenario(
            name: 'fixed fade and 44px leading',
            child: _HeaderScenario(
              leadingSize: 44,
            ),
          ),
          GoldenTestScenario(
            name: 'scroll top',
            child: _HeaderScenario(
              leadingSize: 44,
              listKey: ValueKey('top_list'),
            ),
          ),
          GoldenTestScenario(
            name: 'scrolled',
            child: _HeaderScenario(
              leadingSize: 44,
              listKey: ValueKey('scrolled_list'),
            ),
          ),
          GoldenTestScenario(
            name: 'title only with safe area',
            child: _HeaderScenario(
              safeTop: 24,
            ),
          ),
          GoldenTestScenario(
            name: 'larger leading',
            child: _HeaderScenario(
              leadingSize: 64,
            ),
          ),
          GoldenTestScenario(
            name: 'leading and trailing actions',
            child: _HeaderScenario(
              leadingSize: 44,
              trailingSize: 44,
            ),
          ),
          GoldenTestScenario(
            name: 'centered asymmetric actions',
            child: _HeaderScenario(
              leadingSize: 44,
              trailingSize: 72,
              centerTitle: true,
            ),
          ),
          GoldenTestScenario(
            name: 'large localized RTL title',
            child: _HeaderScenario(
              leadingSize: 44,
              trailingSize: 52,
              centerTitle: true,
              textDirection: TextDirection.rtl,
              textScaler: TextScaler.linear(2),
              title: 'تفاصيل الموقع القريب',
            ),
          ),
          GoldenTestScenario(
            name: 'custom title color',
            child: _HeaderScenario(
              leadingSize: 44,
              title: 'Custom title',
              titleStyle: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  });
}

class _HeaderScenario extends StatefulWidget {
  const _HeaderScenario({
    this.leadingSize,
    this.trailingSize,
    this.centerTitle = false,
    this.listKey,
    this.safeTop = 0,
    this.textDirection = TextDirection.ltr,
    this.textScaler = TextScaler.noScaling,
    this.title = 'View title',
    this.titleStyle,
  });

  final double? leadingSize;
  final double? trailingSize;
  final bool centerTitle;
  final Key? listKey;
  final double safeTop;
  final TextDirection textDirection;
  final TextScaler textScaler;
  final String title;
  final TextStyle? titleStyle;

  @override
  State<_HeaderScenario> createState() => _HeaderScenarioState();
}

class _HeaderScenarioState extends State<_HeaderScenario> {
  ScrollController? _scrollController;

  @override
  void initState() {
    super.initState();
    if (widget.listKey != null) _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        padding: EdgeInsets.only(top: widget.safeTop),
        textScaler: widget.textScaler,
      ),
      child: Directionality(
        textDirection: widget.textDirection,
        child: Navigator(
          onGenerateRoute: (_) => PageRouteBuilder<void>(
            pageBuilder: (context, animation, secondaryAnimation) => ColoredBox(
              color: mateoTestColorScheme.background,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ListView.builder(
                      key: widget.listKey,
                      controller: _scrollController,
                      padding: const EdgeInsets.only(top: 72),
                      itemExtent: 36,
                      itemCount: 8,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: Text(
                          'A warm view item ${index + 1}',
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                  ),
                  MateoHeader(
                    presentation: .standalone(
                      title: Text(widget.title, style: widget.titleStyle),
                      centerTitle: widget.centerTitle,
                      leading: switch (widget.leadingSize) {
                        final size? => DecoratedBox(
                          decoration: BoxDecoration(
                            color: mateoTestPalette.accent[9],
                            shape: BoxShape.circle,
                          ),
                          child: SizedBox.square(
                            dimension: size,
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                        null => null,
                      },
                      trailing: switch (widget.trailingSize) {
                        final size? => DecoratedBox(
                          decoration: BoxDecoration(
                            color: mateoTestPalette.accent[9],
                            shape: BoxShape.circle,
                          ),
                          child: SizedBox(
                            width: size,
                            height: 44,
                            child: const Icon(
                              Icons.more_horiz,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                        null => null,
                      },
                      scrollController: _scrollController,
                    ),
                  ),
                ],
              ),
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) => child,
          ),
        ),
      ),
    );
  }
}
