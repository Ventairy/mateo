part of '../../mateo_select.dart';

final class _MateoNeutralSelectOptionContent<T> extends StatelessWidget {
  const _MateoNeutralSelectOptionContent({
    required this.option,
    required this.colorScheme,
    this.menuColorScheme,
    this.padding = const EdgeInsets.symmetric(
      horizontal: _MateoNeutralSelectPresentation._contentHorizontalPadding,
    ),
    this.menuProgress = 1,
    this.triggerHeight,
    super.key,
  });

  final MateoSelectOption<T> option;
  final MateoSelectVariantColorScheme colorScheme;
  final MateoMenuColorScheme? menuColorScheme;
  final EdgeInsetsGeometry padding;
  final double menuProgress;
  final double? triggerHeight;

  bool get _isInMenu => menuColorScheme != null;

  Widget _buildTitle(BuildContext context) {
    final title = Text(
      option.title,
      style: _MateoNeutralSelectPresentation._titleStyle.copyWith(
        color: menuColorScheme?.title ?? colorScheme.title,
      ),
      maxLines: _MateoNeutralSelectPresentation._titleMaxLines,
      overflow: TextOverflow.ellipsis,
    );
    final resolvedClosedHeight = triggerHeight;
    if (resolvedClosedHeight == null) return title;

    final titleHeight =
        MediaQuery.textScalerOf(context).scale(_MateoNeutralSelectPresentation._titleStyle.fontSize!) *
        _MateoNeutralSelectPresentation._titleStyle.height!;
    final closedOffset = math.max<double>(0, (resolvedClosedHeight - titleHeight) / 2);
    return Transform.translate(
      offset: Offset(0, closedOffset * (1 - menuProgress)),
      child: title,
    );
  }

  Widget _buildDescription(String value) {
    final description = Text(
      value,
      style: _MateoNeutralSelectPresentation._descriptionStyle.copyWith(
        color: menuColorScheme!.description,
      ),
      maxLines: _MateoNeutralSelectPresentation._descriptionMaxLines,
      overflow: TextOverflow.ellipsis,
    );
    if (triggerHeight == null) return description;
    return Opacity(
      opacity: _MateoNeutralSelectPresentation._descriptionCurve.transform(menuProgress),
      child: description,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget icon = SizedBox.square(
      key: ValueKey<Object>(('mateo_select_icon', option.value)),
      dimension: _MateoNeutralSelectPresentation._iconSlotSize,
      child: Center(
        child: option.iconBuilder(
          MateoSelectState(
            iconSize: _MateoNeutralSelectPresentation._iconSize,
            recommendedIconColor: menuColorScheme?.icon ?? colorScheme.icon,
          ),
        ),
      ),
    );
    if (triggerHeight case final height?) {
      icon = Transform.translate(
        offset: Offset(
          0,
          (height - _MateoNeutralSelectPresentation._iconSlotSize) / 2 * (1 - menuProgress),
        ),
        child: icon,
      );
    }

    return Padding(
      padding: padding,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: _isInMenu ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          icon,
          const SizedBox(width: _MateoNeutralSelectPresentation._iconSpacing),
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitle(context),
                if (option.description case final value? when _isInMenu) ...[
                  const SizedBox(height: _MateoNeutralSelectPresentation._descriptionSpacing),
                  _buildDescription(value),
                ],
              ],
            ),
          ),
          if (!_isInMenu) ...[
            const SizedBox(width: _MateoNeutralSelectPresentation._chevronSpacing),
            MateoIcon.chevronDown(
              key: ValueKey<Object>(('mateo_select_source_chevron', option.value)),
              width: _MateoNeutralSelectPresentation._chevronSize,
              height: _MateoNeutralSelectPresentation._chevronSize,
              color: colorScheme.chevron,
            ),
          ],
        ],
      ),
    );
  }
}
