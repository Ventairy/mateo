import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile_old/mateo_mobile_old.dart';
import 'package:mateo_mobile_old/src/components/mateo_button/mateo_button.dart' show MateoButton, MateoButtonScope;
import 'package:mateo_mobile_old/src/foundation/mateo_elevation.dart';

import '../test_app.dart';

void main() {
  BoxDecoration surface(WidgetTester tester) => tester
      .widgetList<DecoratedBox>(
        find.descendant(of: find.byType(MateoButton), matching: find.byType(DecoratedBox)),
      )
      .map((widget) => widget.decoration)
      .whereType<BoxDecoration>()
      .first;
  testWidgets(
    'when elevation resolves for builders, it should remain stable across presentations and disabled states',
    (tester) async {
      MateoButtonState? surfaceState;
      MateoButtonState? iconState;
      Widget background(MateoButtonState state, Widget child) {
        surfaceState = state;
        return DecoratedBox(
          decoration: BoxDecoration(
            boxShadow: MateoElevation.toShadows(elevation: state.elevation, palette: mateoTestPalette),
          ),
          child: child,
        );
      }

      Widget icon(MateoButtonState state) {
        iconState = state;
        return const Icon(Icons.add);
      }

      for (final elevation in [0.0, 0.5, 1.0, 2.0]) {
        for (final enabled in [true, false]) {
          for (final presentation in <MateoButtonPresentation>[
            MateoButtonPresentation.label(
              label: 'Action',
              variant: MateoButtonVariant.primary,
              elevation: elevation,
              leadingIconBuilder: icon,
            ),
            MateoButtonPresentation.icon(
              semanticLabel: 'Action',
              variant: MateoButtonVariant.primary,
              elevation: elevation,
              iconBuilder: icon,
            ),
          ]) {
            await tester.pumpWidget(
              TestApp(
                child: Center(
                  child: MateoButtonScope(
                    backgroundBuilder: background,
                    child: MateoButton(presentation: presentation, onPressed: enabled ? () {} : null),
                  ),
                ),
              ),
            );
            await tester.pumpAndSettle();
            expect(surfaceState!.elevation, elevation);
            expect(iconState!.elevation, elevation);
            expect(
              surface(tester).boxShadow ?? const <BoxShadow>[],
              MateoElevation.toShadows(elevation: elevation, palette: mateoTestPalette),
            );
          }
        }
      }
    },
  );

  testWidgets('when the theme changes, a reused presentation should resolve the current preset', (tester) async {
    final presentation = MateoButtonPresentation.label(label: 'Shared', variant: MateoButtonVariant.primary.neutral);
    Future<void> pump(Color color) => tester.pumpWidget(
      TestApp(
        theme: mateoTestTheme.copyWith(
          extensions: [
            mateoTestThemeData.copyWith(
              colorScheme: mateoTestColorScheme.copyWith(
                buttons: mateoTestColorScheme.buttons.copyWith(
                  primary: mateoTestColorScheme.buttons.primary.copyWith(
                    neutral: mateoTestColorScheme.buttons.primary.neutral.copyWith(background: color),
                  ),
                ),
              ),
            ),
          ],
        ),
        child: MateoButton(presentation: presentation, onPressed: () {}),
      ),
    );
    await pump(Colors.orange);
    expect(surface(tester).color, Colors.orange);
    await pump(Colors.blue);
    await tester.pumpAndSettle();
    expect(surface(tester).color, Colors.blue);
  });

  testWidgets('when a reused tertiary presentation receives a new theme, it should update its foreground', (
    tester,
  ) async {
    const presentation = MateoButtonPresentation.label(label: 'Text action', variant: MateoButtonVariant.tertiary);
    Future<void> pump(Color color) => tester.pumpWidget(
      TestApp(
        theme: mateoTestTheme.copyWith(
          extensions: [
            mateoTestThemeData.copyWith(
              colorScheme: mateoTestColorScheme.copyWith(
                buttons: mateoTestColorScheme.buttons.copyWith(
                  tertiary: mateoTestColorScheme.buttons.tertiary.copyWith(
                    neutral: mateoTestColorScheme.buttons.tertiary.neutral.copyWith(foreground: color),
                  ),
                ),
              ),
            ),
          ],
        ),
        child: MateoButton(presentation: presentation, onPressed: () {}),
      ),
    );
    await pump(Colors.orange);
    expect(tester.widget<Text>(find.text('Text action')).style!.color, Colors.orange);
    await pump(Colors.blue);
    await tester.pumpAndSettle();
    expect(tester.widget<Text>(find.text('Text action')).style!.color, Colors.blue);
    expect(surface(tester).color, Colors.transparent);
    expect(surface(tester).boxShadow, isNull);
  });

  testWidgets('when an elevated button uses custom colors, it should retain shadow geometry and have no border', (
    tester,
  ) async {
    final colors = mateoTestColorScheme.buttons.primary.neutral.copyWith(
      background: Colors.blue,
    );
    await tester.pumpWidget(
      TestApp(
        child: MateoButton(
          presentation: MateoButtonPresentation.label(
            label: 'Float',
            variant: MateoButtonVariant.primary.neutral,
            elevation: 1,
            colorScheme: colors,
          ),
          onPressed: () {},
        ),
      ),
    );
    final decoration = surface(tester);
    expect(decoration.color, colors.background);
    expect(decoration.border, isNull);
    expect(decoration.boxShadow, MateoElevation.toShadows(elevation: 1, palette: mateoTestPalette));
  });

  testWidgets('when an elevated button is disabled, it should retain its shadow and use disabled colors', (
    tester,
  ) async {
    await tester.pumpWidget(
      TestApp(
        child: MateoButton(
          presentation: MateoButtonPresentation.label(
            label: 'Float',
            variant: MateoButtonVariant.primary.neutral,
            elevation: 1,
          ),
        ),
      ),
    );
    final colors = mateoTestColorScheme.buttons.primary.neutral;
    expect(surface(tester).color, colors.backgroundDisabled);
    expect(surface(tester).boxShadow, MateoElevation.toShadows(elevation: 1, palette: mateoTestPalette));
  });

  testWidgets('when an elevated background builder is supplied, it should replace the whole default surface', (
    tester,
  ) async {
    await tester.pumpWidget(
      TestApp(
        child: MateoButtonScope(
          backgroundBuilder: (state, child) => DecoratedBox(
            decoration: const BoxDecoration(color: Colors.orange),
            child: child,
          ),
          child: MateoButton(
            presentation: MateoButtonPresentation.label(
              label: 'Custom',
              variant: MateoButtonVariant.primary.neutral,
              elevation: 1,
            ),
            onPressed: () {},
          ),
        ),
      ),
    );
    expect(surface(tester).color, Colors.orange);
    expect(surface(tester).boxShadow, isNull);
  });
}
