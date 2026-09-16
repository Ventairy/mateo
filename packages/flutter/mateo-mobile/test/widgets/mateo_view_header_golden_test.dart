import 'package:alchemist/alchemist.dart';
import 'package:flutter/widgets.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

Future<void> main() async {
  for (final inset in [false, true]) {
    await goldenTest(
      'when ${inset ? 'already inset' : 'at the screen edge'}, it should protect the view header conditionally',
      fileName: inset ? 'mateo_view_header_inset' : 'mateo_view_header_edge',
      builder: () {
        final theme = MateoThemeData.light(accentColor: const Color(0xFF4A5CFF), onAccent: MateoPalette().white);
        return Directionality(
          textDirection: .ltr,
          child: MediaQuery(
            data: const MediaQueryData(size: Size(360, 400), padding: EdgeInsets.only(top: 32)),
            child: MateoTheme(
              data: theme,
              child: SizedBox(
                width: 360,
                height: 400,
                child: ColoredBox(
                  color: theme.colorScheme.background,
                  child: Padding(
                    padding: EdgeInsets.only(top: inset ? 60 : 0),
                    child: MateoView(
                      header: const MateoViewHeader(principal: Text('Messages'), leading: MateoIcon(.arrowLeft)),
                      surface: MateoViewSurface(
                        color: theme.colorScheme.accent.withValues(alpha: 0.1),
                        child: const Center(child: Text('Surface content')),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
