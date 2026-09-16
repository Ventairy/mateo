part of '../../mateo_menu_button.dart';

class _MateoContextMenuItem extends StatelessWidget {
  const _MateoContextMenuItem({
    required this.item,
    required this.colors,
    required this.onSelected,
    required this.padding,
  });

  final MateoMenuItem item;
  final MateoMenuColorScheme colors;
  final ValueChanged<MateoMenuItem> onSelected;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final enabled = item.onPressed != null;
    final state = MateoMenuItemState(
      isEnabled: enabled,
      iconColor: enabled ? colors.icon : colors.iconDisabled,
      titleColor: enabled ? colors.title : colors.titleDisabled,
      descriptionColor: enabled ? colors.description : colors.descriptionDisabled,
    );
    return Semantics(
      button: true,
      enabled: enabled,
      label: item.title,
      hint: item.description,
      onTap: enabled ? () => onSelected(item) : null,
      child: ExcludeSemantics(
        child: MateoTap(
          onPressed: enabled ? (_) => onSelected(item) : null,
          animation: MateoTapAnimationType.scaleFade,
          child: Padding(
            padding: padding,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: item.description == null ? CrossAxisAlignment.center : CrossAxisAlignment.start,
              children: [
                if (item.leadingIconBuilder case final builder?) ...[
                  IconTheme.merge(
                    data: IconThemeData(color: state.iconColor),
                    child: builder(state),
                  ),
                  const SizedBox(width: _MateoContextMenuPresentation._iconSpacing),
                ],
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        maxLines: _MateoContextMenuPresentation._textMaxLines,
                        overflow: TextOverflow.ellipsis,
                        style: _MateoContextMenuPresentation._titleStyle.copyWith(color: state.titleColor),
                      ),
                      if (item.description case final description?) ...[
                        const SizedBox(height: _MateoContextMenuPresentation._descriptionSpacing),
                        Text(
                          description,
                          maxLines: _MateoContextMenuPresentation._textMaxLines,
                          overflow: TextOverflow.ellipsis,
                          style: _MateoContextMenuPresentation._descriptionStyle.copyWith(
                            color: state.descriptionColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
