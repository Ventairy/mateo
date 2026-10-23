import 'package:alchemist/alchemist.dart';
import 'package:flutter/widgets.dart';
import 'package:mateo_mobile/mateo_mobile.dart';
import 'package:mateo_mobile/src/components/mateo_text/mateo_text.dart' show MateoTextScope;

Future<void> main() async {
  await goldenTest(
    'when arranging footer slots, it should preserve centering across content and reading directions',
    fileName: 'mateo_view_footer_slots',
    builder: () {
      final theme = MateoThemeData.light(accentColor: const Color(0xFF4A5CFF), onAccent: MateoPalette().white);
      return MateoTheme(
        data: theme,
        child: ColoredBox(
          color: theme.colorScheme.background,
          child: GoldenTestGroup(
            columns: 1,
            children: [
              for (final (name, direction, scale) in [
                ('Principal only', TextDirection.ltr, 1.0),
                ('Asymmetric actions', TextDirection.ltr, 1.0),
                ('RTL', TextDirection.rtl, 1.0),
                ('Large text', TextDirection.ltr, 2.0),
              ])
                GoldenTestScenario(
                  name: name,
                  child: SizedBox(
                    width: 360,
                    height: 140,
                    child: Directionality(
                      textDirection: direction,
                      child: MediaQuery(
                        data: MediaQueryData(textScaler: TextScaler.linear(scale)),
                        child: MateoTextScope(
                          fontSize: 20,
                          color: theme.colorScheme.text.primary,
                          child: Align(
                            alignment: .bottomCenter,
                            child: _inView(
                              MateoViewFooter(
                                principal: MateoText(
                                  name == 'Large text' ? 'Your selection' : '3 selected',
                                  presentation: const .interface(
                                    textAlign: .center,
                                  ),
                                ),
                                leading: name == 'Principal only'
                                    ? null
                                    : const SizedBox(
                                        width: 32,
                                        height: 40,
                                        child: Center(child: MateoIcon(.arrowLeft)),
                                      ),
                                trailing: name == 'Principal only'
                                    ? null
                                    : const SizedBox(
                                        width: 64,
                                        height: 40,
                                        child: Center(
                                          child: MateoText(
                                            'Done',
                                            presentation: .interface(),
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ),
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
}

Widget _inView(MateoViewFooter footer) => MateoView(
  padding: EdgeInsets.zero,
  footer: footer,
  surface: const MateoViewSurface(color: Color(0x00000000), child: SizedBox.shrink()),
);
