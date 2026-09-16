part of '../../mateo_menu_button.dart';

class _MateoContextMenuContent extends StatelessWidget {
  const _MateoContextMenuContent({required this.session, required this.colors});

  final _MateoMenuSession session;
  final MateoMenuColorScheme colors;

  @override
  Widget build(BuildContext context) {
    final padding = _MateoContextMenuPresentation._padding.resolve(session.textDirection);
    return _MateoContextMenuContentLayout(
      textDirection: session.textDirection,
      children: [
        for (final (index, item) in session.items.indexed)
          _MateoContextMenuItem(
            padding: EdgeInsets.fromLTRB(
              padding.left,
              index == 0 ? padding.top : _MateoContextMenuPresentation._spacing / 2,
              padding.right,
              index == session.items.length - 1 ? padding.bottom : _MateoContextMenuPresentation._spacing / 2,
            ),
            item: item,
            colors: colors,
            onSelected: session.onSelected,
          ),
      ],
    );
  }
}
