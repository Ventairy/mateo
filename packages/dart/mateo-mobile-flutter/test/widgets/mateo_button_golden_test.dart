import 'package:alchemist/alchemist.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

final _theme = MateoThemeData.light(accentColor: const Color(0xFF4A5CFF), onAccent: MateoPalette().white);

Widget _appearance(Widget child) => MateoTheme(
  data: _theme,
  child: ColoredBox(color: _theme.colorScheme.background, child: child),
);

Widget _matrix({bool disabled = false, bool loading = false}) => _appearance(
  GoldenTestGroup(
    columns: 3,
    children: [
      for (final (name, variant) in [
        ('Primary accent', MateoButtonVariant.primary),
        ('Primary success', MateoButtonVariant.primary.success),
        ('Primary warning', MateoButtonVariant.primary.warning),
        ('Primary neutral', MateoButtonVariant.primary.neutral),
        ('Primary base', MateoButtonVariant.primary.base),
        ('Secondary accent', MateoButtonVariant.secondary),
        ('Secondary neutral', MateoButtonVariant.secondary.neutral),
        ('Tertiary', MateoButtonVariant.tertiary),
      ])
        for (final size in MateoButtonSize.values)
          GoldenTestScenario(
            name: '$name · ${size.name}',
            child: SizedBox(
              width: 270,
              height: 88,
              child: Row(
                mainAxisAlignment: .spaceEvenly,
                children: [
                  Expanded(
                    child: MateoButton(
                      presentation: .label(
                        label: 'Publish',
                        variant: variant,
                        size: size,
                        elevation: name == 'Primary base' ? 1 : 0,
                        trailingIcon: const MateoIcon(.paperPlaneUpRight),
                      ),
                      onPressed: disabled ? null : () {},
                      isLoading: loading,
                    ),
                  ),
                  const SizedBox(width: 16),
                  MateoButton(
                    presentation: .icon(
                      icon: const MateoIcon(.cross),
                      semanticLabel: 'Close',
                      variant: variant,
                      size: size,
                      elevation: name == 'Primary base' ? 1 : 0,
                    ),
                    onPressed: disabled ? null : () {},
                    isLoading: loading,
                  ),
                ],
              ),
            ),
          ),
    ],
  ),
);

Future<void> main() async {
  for (final (phase, initialLoading, targetLoading, milliseconds) in [
    ('resting', false, false, 0),
    ('enter_60', false, true, 60),
    ('enter_160', false, true, 160),
    ('enter_330', false, true, 330),
    ('loading', true, true, 0),
    ('return_60', true, false, 60),
  ]) {
    late ValueNotifier<bool> fittedLoading;
    await goldenTest(
      'when a fitted label changes loading at $phase, its content should stay inside the moving surface',
      fileName: 'mateo_label_button_fit_$phase',
      builder: () {
        fittedLoading = ValueNotifier(initialLoading);
        addTearDown(fittedLoading.dispose);
        return _appearance(
          ValueListenableBuilder<bool>(
            valueListenable: fittedLoading,
            builder: (context, loading, child) => GoldenTestGroup(
              columns: 3,
              children: [
                for (final size in MateoButtonSize.values)
                  for (final (label, alignment) in [
                    ('I', MateoButtonAlignment.left),
                    ('Save changes', MateoButtonAlignment.center),
                    ('Publicar oportunidade para minha comunidade', MateoButtonAlignment.right),
                  ])
                    GoldenTestScenario(
                      name: '${size.name} / ${alignment.name}',
                      child: SizedBox(
                        width: 280,
                        height: 90,
                        child: Center(
                          child: MateoButton(
                            presentation: .label(
                              label: label,
                              variant: .primary,
                              width: .fit,
                              size: size,
                              alignment: alignment,
                              leadingIcon: label == 'I' ? null : const MateoIcon(.checkmark),
                              trailingIcon: label == 'I' ? null : const MateoIcon(.paperPlaneUpRight),
                            ),
                            onPressed: () {},
                            isLoading: loading,
                          ),
                        ),
                      ),
                    ),
              ],
            ),
          ),
        );
      },
      pumpBeforeTest: (tester) async {
        fittedLoading.value = targetLoading;
        await tester.pump();
        await tester.pump(Duration(milliseconds: milliseconds));
      },
    );
  }
  late ValueNotifier<bool> labelLoading;
  await goldenTest(
    'when label loading is transitioning, it should scale and fade the content and dots together',
    fileName: 'mateo_label_button_loading_transition',
    builder: () {
      labelLoading = ValueNotifier(false);
      addTearDown(labelLoading.dispose);
      return _appearance(
        ValueListenableBuilder<bool>(
          valueListenable: labelLoading,
          builder: (context, loading, child) => GoldenTestGroup(
            columns: 3,
            children: [
              for (final size in MateoButtonSize.values)
                for (final alignment in MateoButtonAlignment.values)
                  GoldenTestScenario(
                    name: '${size.name} / ${alignment.name}',
                    child: SizedBox(
                      width: 220,
                      height: 90,
                      child: Center(
                        child: MateoButton(
                          presentation: .label(
                            label: 'Save changes',
                            leadingIcon: const MateoIcon(.checkmark),
                            variant: .primary,
                            size: size,
                            alignment: alignment,
                          ),
                          onPressed: () {},
                          isLoading: loading,
                        ),
                      ),
                    ),
                  ),
            ],
          ),
        ),
      );
    },
    pumpBeforeTest: (tester) async {
      labelLoading.value = true;
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 60));
    },
  );
  late ValueNotifier<bool> loading;
  await goldenTest(
    'when icon loading is transitioning, it should scale and fade within the stable surface',
    fileName: 'mateo_button_loading_transition',
    builder: () {
      loading = ValueNotifier(false);
      addTearDown(loading.dispose);
      return ValueListenableBuilder<bool>(
        valueListenable: loading,
        builder: (context, value, child) => _matrix(loading: value),
      );
    },
    pumpBeforeTest: (tester) async {
      loading.value = true;
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 60));
    },
  );
  await goldenTest(
    'when resting, every treatment should preserve the shared size proportions',
    fileName: 'mateo_button',
    builder: _matrix,
  );
  await goldenTest(
    'when unavailable, buttons should retain clear content and dimensions',
    fileName: 'mateo_button_disabled',
    builder: () => _matrix(disabled: true),
  );
  await goldenTest(
    'when work is pending, each size should retain its surface and show scoped activity',
    fileName: 'mateo_button_loading',
    builder: () => _matrix(loading: true),
    pumpBeforeTest: (tester) async {
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 240));
    },
  );
  await goldenTest(
    'when pressed, filled and transparent buttons should retain their tactile treatment',
    fileName: 'mateo_button_pressed',
    builder: _matrix,
    whilePerforming: press(find.byType(MateoPress)),
  );
  await goldenTest(
    'when text grows or direction changes, action labels should remain readable',
    fileName: 'mateo_button_content',
    builder: () => _appearance(
      GoldenTestGroup(
        columns: 2,
        children: [
          for (final (name, scale, direction, label) in [
            ('Long label', 1.0, TextDirection.ltr, 'Publicar oportunidade para minha comunidade'),
            ('Large text', 2.0, TextDirection.ltr, 'Publicar oportunidade'),
            ('RTL order', 1.0, TextDirection.rtl, 'Publish'),
            ('Short label', 1.0, TextDirection.ltr, 'OK'),
          ])
            GoldenTestScenario(
              name: name,
              child: SizedBox(
                width: 320,
                child: Directionality(
                  textDirection: direction,
                  child: MediaQuery(
                    data: MediaQueryData(textScaler: TextScaler.linear(scale)),
                    child: Column(
                      mainAxisSize: .min,
                      children: [
                        for (final size in MateoButtonSize.values)
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: MateoButton(
                              presentation: .label(
                                label: label,
                                variant: .primary,
                                size: size,
                                trailingIcon: const MateoIcon(.paperPlaneUpRight),
                              ),
                              onPressed: () {},
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    ),
  );
}
