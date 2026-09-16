part of '../../mateo_menu_button.dart';

class _MateoActionMenuContent extends StatelessWidget {
  const _MateoActionMenuContent({required this.session, required this.colors});

  final _MateoMenuSession session;
  final MateoMenuColorScheme colors;

  @override
  Widget build(BuildContext context) {
    final padding = _MateoActionMenuPresentation._padding.resolve(session.textDirection);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final (index, item) in session.items.indexed)
          _MateoActionMenuItem(
            padding: EdgeInsets.fromLTRB(
              padding.left,
              index == 0 ? padding.top : _MateoActionMenuPresentation._spacing / 2,
              padding.right,
              index == session.items.length - 1 ? padding.bottom : _MateoActionMenuPresentation._spacing / 2,
            ),
            item: item,
            colors: colors,
            onSelected: session.onSelected,
          ),
      ],
    );
  }
}
