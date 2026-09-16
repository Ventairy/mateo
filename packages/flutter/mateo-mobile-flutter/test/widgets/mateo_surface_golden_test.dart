import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile_old/mateo_mobile_old.dart';

import '../test_app.dart';

void main() {
  group('MateoSurface Golden Tests', () {
    goldenTest(
      'renders the approved surface states',
      fileName: 'mateo_surface_states',
      whilePerforming: (tester) async {
        final scrollView = find.descendant(
          of: find.byKey(const ValueKey('scrolled-surface')),
          matching: find.byType(CustomScrollView),
        );
        PrimaryScrollController.of(
          tester.element(scrollView),
        ).jumpTo(110);
        await tester.pump();
        return null;
      },
      builder: () => GoldenTestGroup(
        scenarioConstraints: const BoxConstraints.tightFor(
          width: 280,
          height: 180,
        ),
        children: [
          GoldenTestScenario(
            name: 'flat ordinary surface',
            child: const _SurfaceFrame(
              surface: MateoSurface(child: _SurfaceContent('Ordinary')),
            ),
          ),
          GoldenTestScenario(
            name: 'rounded fractional elevation',
            child: _SurfaceFrame(
              surface: MateoSurface(
                color: mateoTestPalette.accent[2],
                borderRadius: BorderRadius.circular(36),
                elevation: 1.5,
                child: const _SurfaceContent('Rounded'),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'top boundary only',
            child: const _SurfaceFrame(
              surface: MateoSurface(
                boundaryEffect: MateoBoundaryEffect.fade(bottom: false),
                child: _StripedContent(),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'rounded boundaries',
            child: const _SurfaceFrame(
              surface: MateoSurface(
                borderRadius: BorderRadius.all(Radius.circular(36)),
                boundaryEffect: MateoBoundaryEffect.fade(),
                child: _StripedContent(),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'translucent mask',
            child: const _SurfaceFrame(
              checkerboard: true,
              surface: MateoSurface(
                color: Color(0x99FFFFFF),
                borderRadius: BorderRadius.all(Radius.circular(28)),
                boundaryEffect: MateoBoundaryEffect.fade(),
                child: _StripedContent(),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'scroll top',
            child: const _SurfaceFrame(
              surface: MateoSurface.scrollable(
                child: _TallContent(),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'scroll middle',
            child: const _SurfaceFrame(
              surface: MateoSurface.scrollable(
                key: ValueKey('scrolled-surface'),
                child: _TallContent(),
              ),
            ),
          ),
        ],
      ),
    );
  });
}

class _SurfaceFrame extends StatelessWidget {
  const _SurfaceFrame({required this.surface, this.checkerboard = false});

  final MateoSurface surface;
  final bool checkerboard;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: checkerboard ? mateoTestPalette.accent[6] : mateoTestPalette.neutral[4],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: surface,
      ),
    );
  }
}

class _SurfaceContent extends StatelessWidget {
  const _SurfaceContent(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(label, style: const TextStyle(fontSize: 18)),
    );
  }
}

class _StripedContent extends StatelessWidget {
  const _StripedContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var index = 0; index < 6; index++)
          Expanded(
            child: ColoredBox(
              color: index.isEven ? mateoTestPalette.green[5] : mateoTestPalette.accent[5],
              child: SizedBox(width: double.infinity, child: Text(' $index')),
            ),
          ),
      ],
    );
  }
}

class _TallContent extends StatelessWidget {
  const _TallContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var index = 0; index < 12; index++)
          SizedBox(
            height: 36,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Surface item ${index + 1}'),
            ),
          ),
      ],
    );
  }
}
