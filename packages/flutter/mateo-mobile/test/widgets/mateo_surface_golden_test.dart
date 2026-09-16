import 'package:alchemist/alchemist.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

Future<void> main() async {
  await goldenTest(
    'when rendering simple surfaces, it should paint backgrounds padding and rounded containment',
    fileName: 'mateo_surface',
    builder: () {
      final theme = MateoThemeData.light(accentColor: const Color(0xFF4A5CFF), onAccent: MateoPalette().white);
      return MateoTheme(
        data: theme,
        child: ColoredBox(
          color: theme.colorScheme.background,
          child: GoldenTestGroup(
            columns: 3,
            children: [
              for (final (name, shape, padding) in [
                ('None', const MateoSurfaceShape.none(), EdgeInsets.zero),
                ('Capsule', const MateoSurfaceShape.capsule(), EdgeInsets.zero),
                ('Padding', const MateoSurfaceShape.capsule(), const EdgeInsets.all(16)),
              ])
                GoldenTestScenario(
                  name: name,
                  child: Padding(
                    padding: const .all(12),
                    child: MateoSurface(
                      color: theme.colorScheme.accent,
                      width: const .custom(140),
                      height: const .custom(100),
                      shape: shape,
                      padding: padding,
                      child: ColoredBox(color: theme.colorScheme.inverse.background),
                    ),
                  ),
                ),
              GoldenTestScenario(
                name: 'Theme background',
                child: ColoredBox(
                  color: theme.colorScheme.accent,
                  child: const Padding(
                    padding: .all(12),
                    child: MateoSurface(
                      width: .custom(140),
                      height: .custom(100),
                      shape: .none(),
                      child: Center(child: Text('Mateo')),
                    ),
                  ),
                ),
              ),
              for (final direction in TextDirection.values)
                GoldenTestScenario(
                  name: direction.name,
                  child: Directionality(
                    textDirection: direction,
                    child: Padding(
                      padding: const .all(12),
                      child: MateoSurface(
                        color: theme.colorScheme.accent,
                        width: const .custom(140),
                        height: const .custom(100),
                        shape: const .none(),
                        padding: const EdgeInsetsDirectional.only(start: 28, top: 12, bottom: 12),
                        child: ColoredBox(color: theme.colorScheme.inverse.background),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    },
  );
  await goldenTest(
    'when surfaces are elevated, it should paint unclipped authored shadows',
    fileName: 'mateo_surface_elevation',
    builder: () {
      final theme = MateoThemeData.light(accentColor: const Color(0xFF4A5CFF), onAccent: MateoPalette().white);
      return MateoTheme(
        data: theme,
        child: ColoredBox(
          color: theme.colorScheme.background,
          child: GoldenTestGroup(
            columns: 2,
            children: [
              for (final elevation in [0.0, 0.5, 1.0, 2.0])
                GoldenTestScenario(
                  name: 'Elevation $elevation',
                  child: Padding(
                    padding: const .all(64),
                    child: MateoSurface(
                      width: const .custom(140),
                      height: const .custom(100),
                      elevation: MateoElevation(level: elevation),
                      shape: const .none(),
                      child: const Center(child: Text('Mateo')),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    },
  );
  for (final scenario in ['centered', 'overlapping', 'scrolled']) {
    await goldenTest(
      'when aligned content is $scenario, it should retain its preferred position until obstructed',
      fileName: 'mateo_surface_alignment_$scenario',
      pumpBeforeTest: (tester) async {
        await tester.pumpAndSettle();
        if (scenario == 'scrolled') {
          tester.widget<CustomScrollView>(find.byType(CustomScrollView)).controller!.jumpTo(120);
          await tester.pumpAndSettle();
        }
      },
      builder: () {
        final theme = MateoThemeData.light(accentColor: const Color(0xFF4A5CFF), onAccent: MateoPalette().white);
        final content = SizedBox(
          width: 180,
          height: scenario == 'centered'
              ? 60
              : scenario == 'overlapping'
              ? 200
              : 600,
          child: ColoredBox(
            color: theme.colorScheme.accent,
            child: Column(
              mainAxisAlignment: .spaceBetween,
              children: [
                if (scenario == 'scrolled')
                  for (var index = 1; index <= 7; index++)
                    Text('Item $index', style: TextStyle(color: theme.colorScheme.onAccent))
                else ...[
                  Text('Content start', style: TextStyle(color: theme.colorScheme.onAccent)),
                  Text('Content end', style: TextStyle(color: theme.colorScheme.onAccent)),
                ],
              ],
            ),
          ),
        );
        return MateoTheme(
          data: theme,
          child: Directionality(
            textDirection: .ltr,
            child: MediaQuery(
              data: const MediaQueryData(size: Size(300, 300)),
              child: GoldenTestGroup(
                children: [
                  GoldenTestScenario(
                    name: scenario,
                    child: SizedBox(
                      width: 300,
                      height: 300,
                      child: MateoView(
                        header: const MateoViewHeader(principal: Text('Header')),
                        surface: scenario == 'scrolled'
                            ? MateoViewSurface.scrollable(alignment: .center, padding: const .all(10), child: content)
                            : MateoViewSurface(alignment: .center, padding: const .all(10), child: content),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
