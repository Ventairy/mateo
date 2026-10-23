import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

/// Interface and decorative text with system text scaling.
@Preview(name: 'Mateo text', size: Size(400, 500))
Widget mateoTextPreview() {
  final theme = MateoThemeData.light(accentColor: const Color(0xFF4A5CFF), onAccent: MateoPalette().white);
  return MateoTheme(
    data: theme,
    child: ColoredBox(
      color: theme.colorScheme.background,
      child: const Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: .start,
          spacing: 24,
          children: [
            MateoText('Uma oportunidade perto de você', presentation: .interface(fontSize: 20, fontWeight: .w600)),
            MateoText('Olá, coração!', presentation: .decorative(variant: .rounded, fontSize: 40)),
            MateoText('Feito com carinho', presentation: .decorative(variant: .cursive, fontSize: 40)),
          ],
        ),
      ),
    ),
  );
}
