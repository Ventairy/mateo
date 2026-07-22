import 'dart:async';

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import '../test_app.dart';

void main() {
  group('MateoButton Golden Tests', () {
    goldenTest(
      'when rendering visual states, it should match the approved goldens',
      fileName: 'mateo_button_states',
      builder: () => GoldenTestGroup(
        scenarioConstraints: const BoxConstraints(minWidth: 260),
        children: [
          GoldenTestScenario(
            name: 'resting label only',
            child: MateoButton(
              variant: MateoButtonVariant.primary,
              label: 'Ver oportunidades',
              onPressed: () {},
            ),
          ),
          GoldenTestScenario(
            name: 'secondary resting label only',
            child: MateoButton(
              variant: MateoButtonVariant.secondary,
              label: 'Ver oportunidades',
              onPressed: () {},
            ),
          ),
          GoldenTestScenario(
            name: 'leading icon',
            child: MateoButton(
              variant: MateoButtonVariant.primary,
              label: 'Buscar',
              leadingIconBuilder: (state) =>
                  Icon(Icons.search, color: state.foregroundColor, size: 20),
              onPressed: () {},
            ),
          ),
          GoldenTestScenario(
            name: 'trailing icon',
            child: MateoButton(
              variant: MateoButtonVariant.primary,
              label: 'Continuar',
              trailingIconBuilder: (state) => Icon(
                Icons.arrow_forward,
                color: state.foregroundColor,
                size: 20,
              ),
              onPressed: () {},
            ),
          ),
          GoldenTestScenario(
            name: 'both icons',
            child: MateoButton(
              variant: MateoButtonVariant.primary,
              label: 'Filtrar',
              leadingIconBuilder: (state) =>
                  Icon(Icons.tune, color: state.foregroundColor, size: 20),
              trailingIconBuilder: (state) => Icon(
                Icons.arrow_drop_down,
                color: state.foregroundColor,
                size: 20,
              ),
              onPressed: () {},
            ),
          ),
          GoldenTestScenario(
            name: 'custom color scheme background',
            child: MateoButton(
              variant: MateoButtonVariant.primary,
              label: 'Mapa',
              colorScheme: MateoButtonColorScheme(
                background: mateoTestColorScheme.buttons.success.background,
                backgroundPressed:
                    mateoTestColorScheme.buttons.success.backgroundPressed,
                backgroundDisabled:
                    mateoTestColorScheme.buttons.primary.backgroundDisabled,
                foreground: mateoTestColorScheme.background,
                foregroundDisabled: mateoTestColorScheme.text.disabled,
              ),
              onPressed: () {},
            ),
          ),
          GoldenTestScenario(
            name: 'custom color scheme foreground',
            child: MateoButton(
              variant: MateoButtonVariant.primary,
              label: 'Salvar',
              colorScheme: MateoButtonColorScheme(
                background: mateoTestColorScheme.toast.warning.icon,
                backgroundPressed:
                    mateoTestColorScheme.toast.warning.background,
                backgroundDisabled:
                    mateoTestColorScheme.buttons.primary.backgroundDisabled,
                foreground: mateoTestColorScheme.text.primary,
                foregroundDisabled: mateoTestColorScheme.text.disabled,
              ),
              onPressed: () {},
            ),
          ),
          GoldenTestScenario(
            name: 'disabled',
            child: MateoButton(
              variant: MateoButtonVariant.primary,
              label: 'Indisponivel',
              leadingIconBuilder: (state) =>
                  Icon(Icons.lock, color: state.foregroundColor, size: 20),
            ),
          ),
          GoldenTestScenario(
            name: 'secondary disabled',
            child: MateoButton(
              variant: MateoButtonVariant.secondary,
              label: 'Indisponivel',
              leadingIconBuilder: (state) =>
                  Icon(Icons.lock, color: state.foregroundColor, size: 20),
            ),
          ),
          GoldenTestScenario(
            name: 'disabled custom color scheme',
            child: MateoButton(
              variant: MateoButtonVariant.primary,
              label: 'Fechado',
              colorScheme: MateoButtonColorScheme(
                background: mateoTestColorScheme.buttons.success.background,
                backgroundPressed:
                    mateoTestColorScheme.buttons.success.backgroundPressed,
                backgroundDisabled:
                    mateoTestColorScheme.buttons.primary.backgroundDisabled,
                foreground: mateoTestColorScheme.background,
                foregroundDisabled: mateoTestColorScheme.text.disabled,
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'expand',
            child: const SizedBox(
              width: 300,
              child: MateoButton(
                variant: MateoButtonVariant.primary,
                label: 'Expandido',
                fit: MateoButtonFit.expand,
                onPressed: null,
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'short label',
            child: MateoButton(
              variant: MateoButtonVariant.primary,
              label: 'OK',
              onPressed: () {},
            ),
          ),
          GoldenTestScenario(
            name: 'long label',
            child: MateoButton(
              variant: MateoButtonVariant.primary,
              label: 'Enviar candidatura completa agora',
              onPressed: () {},
            ),
          ),
          GoldenTestScenario(
            name: 'custom padding',
            child: const MateoButton(
              variant: MateoButtonVariant.primary,
              label: 'Compacto',
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              onPressed: null,
            ),
          ),
          GoldenTestScenario(
            name: 'custom spacing',
            child: MateoButton(
              variant: MateoButtonVariant.primary,
              label: 'Espacado',
              leadingIconSpacing: 14,
              trailingIconSpacing: 18,
              leadingIconBuilder: (state) =>
                  Icon(Icons.tune, color: state.foregroundColor, size: 20),
              trailingIconBuilder: (state) => Icon(
                Icons.arrow_forward,
                color: state.foregroundColor,
                size: 20,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'when rendering alignment variants with expand, it should match the approved goldens',
      fileName: 'mateo_button_alignment',
      builder: () => GoldenTestGroup(
        scenarioConstraints: const BoxConstraints(maxWidth: 300),
        children: [
          GoldenTestScenario(
            name: 'left',
            child: SizedBox(
              width: 300,
              child: MateoButton(
                variant: MateoButtonVariant.primary,
                label: 'Esquerda',
                fit: MateoButtonFit.expand,
                alignment: MateoButtonAlignment.left,
                onPressed: () {},
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'center',
            child: SizedBox(
              width: 300,
              child: MateoButton(
                variant: MateoButtonVariant.primary,
                label: 'Centro',
                fit: MateoButtonFit.expand,
                alignment: MateoButtonAlignment.center,
                onPressed: () {},
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'right',
            child: SizedBox(
              width: 300,
              child: MateoButton(
                variant: MateoButtonVariant.primary,
                label: 'Direita',
                fit: MateoButtonFit.expand,
                alignment: MateoButtonAlignment.right,
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'when pressing the button, it should match the approved golden',
      fileName: 'mateo_button_pressed',
      whilePerforming: (tester) async {
        final gesture = await tester.startGesture(
          tester.getCenter(find.text('Ver oportunidades')),
        );
        await tester.pump(const Duration(milliseconds: 120));
        addTearDown(gesture.removePointer);
        return null;
      },
      builder: () => SizedBox(
        width: 220,
        child: MateoButton(
          variant: MateoButtonVariant.primary,
          label: 'Ver oportunidades',
          onPressed: () {},
        ),
      ),
    );

    goldenTest(
      'when rendering loading states with animations disabled, it should match the approved goldens',
      fileName: 'mateo_button_loading',
      whilePerforming: (tester) async {
        await tester.tap(find.text('Fit loading'));
        await tester.tap(find.text('Expand loading'));
        await tester.tap(find.text('Custom loading'));
        await tester.pump(const Duration(milliseconds: 101));
        await tester.pump();
        return null;
      },
      builder: () => MediaQuery(
        data: MediaQueryData(disableAnimations: true),
        child: GoldenTestGroup(
          scenarioConstraints: BoxConstraints(minWidth: 300),
          children: [
            GoldenTestScenario(
              name: 'fit loading',
              child: MateoButton(
                variant: MateoButtonVariant.primary,
                label: 'Fit loading',
                onPressed: () => Completer<void>().future,
              ),
            ),
            GoldenTestScenario(
              name: 'expand loading',
              child: SizedBox(
                width: 300,
                child: MateoButton(
                  variant: MateoButtonVariant.primary,
                  label: 'Expand loading',
                  fit: MateoButtonFit.expand,
                  onPressed: () => Completer<void>().future,
                ),
              ),
            ),
            GoldenTestScenario(
              name: 'custom color scheme loading',
              child: MateoButton(
                variant: MateoButtonVariant.primary,
                label: 'Custom loading',
                colorScheme: MateoButtonColorScheme(
                  background: mateoTestColorScheme.toast.warning.icon,
                  backgroundPressed:
                      mateoTestColorScheme.toast.warning.background,
                  backgroundDisabled:
                      mateoTestColorScheme.buttons.primary.backgroundDisabled,
                  foreground: mateoTestColorScheme.text.primary,
                  foregroundDisabled: mateoTestColorScheme.text.disabled,
                ),
                onPressed: () => Completer<void>().future,
              ),
            ),
            GoldenTestScenario(
              name: 'loading with icon',
              child: MateoButton(
                variant: MateoButtonVariant.primary,
                label: 'Icon loading',
                leadingIconBuilder: (state) =>
                    Icon(Icons.search, color: state.foregroundColor, size: 20),
                onPressed: () => Completer<void>().future,
              ),
            ),
          ],
        ),
      ),
    );

    goldenTest(
      'when rendering with custom dimensions, it should match the approved goldens',
      fileName: 'mateo_button_custom_dimensions',
      builder: () => GoldenTestGroup(
        scenarioConstraints: const BoxConstraints(maxWidth: 400),
        children: [
          GoldenTestScenario(
            name: 'fit with icons',
            child: MateoButton(
              variant: MateoButtonVariant.primary,
              label: 'Filtrar resultados',
              leadingIconBuilder: (state) =>
                  Icon(Icons.tune, color: state.foregroundColor, size: 20),
              trailingIconBuilder: (state) => Icon(
                Icons.arrow_drop_down,
                color: state.foregroundColor,
                size: 20,
              ),
              onPressed: () {},
            ),
          ),
          GoldenTestScenario(
            name: 'expand with trailing icon',
            child: SizedBox(
              width: 300,
              child: MateoButton(
                variant: MateoButtonVariant.primary,
                label: 'Continuar',
                trailingIconBuilder: (state) => Icon(
                  Icons.arrow_forward,
                  color: state.foregroundColor,
                  size: 20,
                ),
                fit: MateoButtonFit.expand,
                onPressed: () {},
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'expand disabled',
            child: SizedBox(
              width: 300,
              child: MateoButton(
                variant: MateoButtonVariant.primary,
                label: 'Indisponivel',
                fit: MateoButtonFit.expand,
                leadingIconBuilder: (state) =>
                    Icon(Icons.lock, color: state.foregroundColor, size: 20),
              ),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'when rendering isLoading prop states with animations disabled, it should match the approved goldens',
      fileName: 'mateo_button_is_loading',
      whilePerforming: (tester) async {
        await tester.pump();
        await tester.pump();
        return null;
      },
      builder: () => MediaQuery(
        data: const MediaQueryData(disableAnimations: true),
        child: GoldenTestGroup(
          scenarioConstraints: const BoxConstraints(minWidth: 300),
          children: [
            GoldenTestScenario(
              name: 'isLoading enabled',
              child: MateoButton(
                variant: MateoButtonVariant.primary,
                label: 'Carregando',
                isLoading: true,
                onPressed: () {},
              ),
            ),
            GoldenTestScenario(
              name: 'isLoading disabled',
              child: const MateoButton(
                variant: MateoButtonVariant.primary,
                label: 'Indisponivel',
                isLoading: true,
              ),
            ),
            GoldenTestScenario(
              name: 'isLoading secondary',
              child: MateoButton(
                variant: MateoButtonVariant.secondary,
                label: 'Carregando',
                isLoading: true,
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );

    goldenTest(
      'when multiple buttons are stacked, it should match the approved goldens',
      fileName: 'mateo_button_stacked',
      builder: () => GoldenTestGroup(
        scenarioConstraints: const BoxConstraints(maxWidth: 300),
        children: [
          GoldenTestScenario(
            name: 'stacked variants',
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MateoButton(
                  variant: MateoButtonVariant.primary,
                  label: 'Ver oportunidades',
                  onPressed: () {},
                ),
                const SizedBox(height: 12),
                MateoButton(
                  variant: MateoButtonVariant.primary,
                  label: 'Buscar',
                  leadingIconBuilder: (state) => Icon(
                    Icons.search,
                    color: state.foregroundColor,
                    size: 20,
                  ),
                  onPressed: () {},
                ),
                const SizedBox(height: 12),
                MateoButton(
                  variant: MateoButtonVariant.primary,
                  label: 'Continuar',
                  trailingIconBuilder: (state) => Icon(
                    Icons.arrow_forward,
                    color: state.foregroundColor,
                    size: 20,
                  ),
                  onPressed: () {},
                ),
                const SizedBox(height: 12),
                MateoButton(
                  variant: MateoButtonVariant.primary,
                  label: 'Indisponivel',
                  leadingIconBuilder: (state) =>
                      Icon(Icons.lock, color: state.foregroundColor, size: 20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  });
}
