import 'package:alchemist/alchemist.dart';
import 'package:flutter/widgets.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

Future<void> main() async {
  await goldenTest(
    'when arranging header slots, it should keep principal content centered',
    fileName: 'mateo_view_header_slots',
    builder: () {
      final theme = MateoThemeData.light(accentColor: const Color(0xFF4A5CFF), onAccent: MateoPalette().white);
      return MateoTheme(
        data: theme,
        child: ColoredBox(
          color: theme.colorScheme.background,
          child: GoldenTestGroup(
            columns: 1,
            children: [
              for (final (name, title, direction, scale, button) in [
                ('Principal only', 'Messages', TextDirection.ltr, 1.0, false),
                ('Asymmetric controls', 'Messages', TextDirection.ltr, 1.0, false),
                ('Header action', 'Messages', TextDirection.ltr, 1.0, true),
                ('Long principal', 'Messages from your neighborhood', TextDirection.ltr, 1.0, false),
                ('RTL', 'Messages', TextDirection.rtl, 1.0, false),
                ('Large text', 'Your messages', TextDirection.ltr, 2.0, false),
              ])
                GoldenTestScenario(
                  name: name,
                  child: SizedBox(
                    width: 360,
                    height: 150,
                    child: Align(
                      alignment: .topCenter,
                      child: Directionality(
                        textDirection: direction,
                        child: MediaQuery(
                          data: MediaQueryData(textScaler: TextScaler.linear(scale)),
                          child: _inView(
                            MateoViewHeader(
                              principal: Text(title, textAlign: .center),
                              leading: name == 'Principal only'
                                  ? null
                                  : const SizedBox(
                                      width: 32,
                                      height: 40,
                                      child: Center(child: MateoIcon(.arrowLeft)),
                                    ),
                              trailing: button
                                  ? const MateoButton(
                                      presentation: .icon(icon: MateoIcon(.cross), semanticLabel: 'Close'),
                                    )
                                  : name == 'Principal only'
                                  ? null
                                  : const SizedBox(width: 64, height: 40, child: Center(child: Text('Edit'))),
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

Widget _inView(MateoViewHeader header) => MateoView(
  padding: EdgeInsets.zero,
  header: header,
  surface: const MateoViewSurface(color: Color(0x00000000), child: SizedBox.shrink()),
);
