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
            MateoText(
              'Uma oportunidade perto de você',
              presentation: .interface(fontSize: .custom(20), fontWeight: .w600),
            ),
            MateoText('Olá, coração!', presentation: .decorative(variant: .rounded, fontSize: 40)),
            MateoText('Feito com carinho', presentation: .decorative(variant: .cursive, fontSize: 40)),
          ],
        ),
      ),
    ),
  );
}

/// Tap any row to update its text. Tap it again during motion to reverse it.
@Preview(name: 'Mateo text updates', size: Size(400, 460))
Widget mateoTextUpdatesPreview() => const _MateoTextUpdatesPreview();

class _MateoTextUpdatesPreview extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final theme = MateoThemeData.light(accentColor: const Color(0xFF4A5CFF), onAccent: MateoPalette().white);
    return MateoTheme(
      data: theme,
      child: Localizations.override(
        context: context,
        locale: const Locale('pt', 'BR'),
        child: ColoredBox(
          color: theme.colorScheme.background,
          child: const Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 12,
              children: [
                _MateoTextUpdateExample('Contagem regressiva', '10 segundos', '1 segundo'),
                _MateoTextUpdateExample('Valor', 'Total R\$\u00a01.234,56', 'Total R\$\u00a09.876,50'),
                _MateoTextUpdateExample('Reordenar palavras', 'Nome · Data', 'Data · Nome'),
                _MateoTextUpdateExample('Alterar linhas', 'Pronto\nPara enviar', 'Para enviar\nToque aqui\nPronto'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MateoTextUpdateExample extends StatefulWidget {
  const new(this.action, this.before, this.after);

  final String action;
  final String before;
  final String after;

  @override
  State<_MateoTextUpdateExample> createState() => _MateoTextUpdateExampleState();
}

class _MateoTextUpdateExampleState extends State<_MateoTextUpdateExample> {
  bool _updated = false;

  @override
  Widget build(BuildContext context) => MateoPress(
    animation: .none,
    fireHapticFeedback: false,
    onPressed: (_) => setState(() => _updated = !_updated),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4,
        children: [
          MateoText(widget.action, presentation: const .interface(fontSize: .custom(14))),
          MateoText(
            _updated ? widget.after : widget.before,
            presentation: const .interface(fontSize: .custom(24), fontWeight: .w600),
          ),
        ],
      ),
    ),
  );
}
