import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile_old/mateo_mobile_old.dart';

import '../test_app.dart';

void main() {
  group('MateoView Golden Tests', () {
    goldenTest(
      'when rendering view states, it should match the approved golden',
      fileName: 'mateo_view_states',
      whilePerforming: (tester) async {
        final middleList = tester.widget<ListView>(find.byKey(const ValueKey('middle_list')));
        middleList.controller!.jumpTo(80);
        final endList = tester.widget<ListView>(find.byKey(const ValueKey('end_list')));
        endList.controller!.jumpTo(endList.controller!.position.maxScrollExtent);
        await tester.pump();
        return null;
      },
      builder: () => GoldenTestGroup(
        scenarioConstraints: const BoxConstraints.tightFor(width: 320, height: 420),
        children: [
          GoldenTestScenario(
            name: 'fixed content',
            child: _ViewScenario(),
          ),
          GoldenTestScenario(
            name: 'footer overlay opt-in',
            child: _ViewScenario(extendContentBehindFooter: true),
          ),
          GoldenTestScenario(
            name: 'overflow behind header',
            child: const _OverflowScenario(),
          ),
          GoldenTestScenario(
            name: 'scroll top',
            child: _ViewScenario(listKey: ValueKey('top_list')),
          ),
          GoldenTestScenario(
            name: 'scroll middle',
            child: _ViewScenario(listKey: ValueKey('middle_list')),
          ),
          GoldenTestScenario(
            name: 'scroll end',
            child: _ViewScenario(listKey: ValueKey('end_list')),
          ),
          GoldenTestScenario(
            name: 'keyboard',
            child: _ViewScenario(keyboardInset: 140),
          ),
          GoldenTestScenario(
            name: 'inset surface',
            child: const _PositionAwareViewScenario(topInset: 120),
          ),
          GoldenTestScenario(
            name: 'partial safe overlap',
            child: const _PositionAwareViewScenario(topInset: 12),
          ),
        ],
      ),
    );
  });
}

class _PositionAwareViewScenario extends StatelessWidget {
  const _PositionAwareViewScenario({required this.topInset});

  final double topInset;

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        padding: const EdgeInsets.only(top: 24),
        viewPadding: const EdgeInsets.only(top: 24),
      ),
      child: ColoredBox(
        color: mateoTestPalette.neutral[4],
        child: Padding(
          padding: EdgeInsets.only(top: topInset),
          child: MateoView(
            surface: MateoSurface(
              color: mateoTestPalette.neutral[1],
              child: Align(
                alignment: Alignment.topLeft,
                child: ColoredBox(
                  color: mateoTestPalette.accent[3],
                  child: const SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: Center(child: Text('Starts after the header')),
                  ),
                ),
              ),
            ),
            header: const MateoHeader(
              presentation: .view(
                title: Text('Location'),
                trailing: _CircleIcon(icon: Icons.close),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ViewScenario extends StatefulWidget {
  const _ViewScenario({
    this.listKey,
    this.keyboardInset = 0,
    this.extendContentBehindFooter = false,
  });

  final Key? listKey;
  final double keyboardInset;
  final bool extendContentBehindFooter;

  @override
  State<_ViewScenario> createState() => _ViewScenarioState();
}

class _ViewScenarioState extends State<_ViewScenario> {
  ScrollController? _controller;

  @override
  void initState() {
    super.initState();
    if (widget.listKey != null) _controller = ScrollController();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        padding: const EdgeInsets.only(top: 24, bottom: 20),
        viewPadding: const EdgeInsets.only(top: 24, bottom: 20),
        viewInsets: EdgeInsets.only(bottom: widget.keyboardInset),
      ),
      child: MateoView(
        extendContentBehindFooter: widget.extendContentBehindFooter,
        header: const MateoHeader(
          presentation: .view(
            title: Text('Nearby work'),
            leading: _CircleIcon(icon: Icons.location_on),
          ),
        ),
        footer: const Align(
          alignment: AlignmentDirectional.bottomEnd,
          child: _CircleIcon(icon: Icons.add, size: 56),
        ),
        surface: MateoSurface(
          boundaryEffect: const MateoBoundaryEffect.fade(),
          child: switch (_controller) {
            final controller? => ListView.builder(
              key: widget.listKey,
              controller: controller,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
              itemCount: 14,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  'A warm view item ${index + 1}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            null => const Center(
              child: Text(
                'Header-aware fixed content',
                style: TextStyle(fontSize: 16),
              ),
            ),
          },
        ),
      ),
    );
  }
}

class _OverflowScenario extends StatelessWidget {
  const _OverflowScenario();

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        padding: const EdgeInsets.only(top: 24),
        viewPadding: const EdgeInsets.only(top: 24),
      ),
      child: MateoView(
        header: const MateoHeader(
          presentation: .view(
            title: Text('Nearby work'),
            leading: _CircleIcon(icon: Icons.location_on),
          ),
        ),
        surface: MateoSurface(
          child: Transform.translate(
            offset: const Offset(0, -40),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: mateoTestPalette.accent[3],
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
              ),
              child: const Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: 24),
                  child: Text('Moving content remains visible'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CircleIcon extends StatelessWidget {
  const _CircleIcon({required this.icon, this.size = 44});

  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: mateoTestPalette.accent[9], shape: BoxShape.circle),
      child: SizedBox.square(
        dimension: size,
        child: Icon(icon, color: mateoTestPalette.accent[1], size: 20),
      ),
    );
  }
}
