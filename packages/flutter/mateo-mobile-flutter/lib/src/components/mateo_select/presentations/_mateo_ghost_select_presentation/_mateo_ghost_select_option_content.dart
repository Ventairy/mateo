part of '../../mateo_select.dart';

final class _MateoGhostSelectOptionContent<T> extends StatelessWidget {
  const _MateoGhostSelectOptionContent({
    required this.option,
    required this.colorScheme,
    this.menuColorScheme,
    this.padding = const EdgeInsets.symmetric(
      horizontal: _MateoGhostSelectPresentation._contentHorizontalPadding,
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
      style: _MateoGhostSelectPresentation._titleStyle.copyWith(
        color: menuColorScheme?.title ?? colorScheme.title,
      ),
      maxLines: _MateoGhostSelectPresentation._titleMaxLines,
      overflow: TextOverflow.ellipsis,
    );
    final resolvedClosedHeight = triggerHeight;
    if (resolvedClosedHeight == null) return title;

    final titleHeight =
        MediaQuery.textScalerOf(context).scale(_MateoGhostSelectPresentation._titleStyle.fontSize!) *
        _MateoGhostSelectPresentation._titleStyle.height!;
    final closedOffset = math.max<double>(0, (resolvedClosedHeight - titleHeight) / 2);
    return Transform.translate(
      offset: Offset(0, closedOffset * (1 - menuProgress)),
      child: title,
    );
  }

  Widget _buildDescription(String value) {
    final description = Text(
      value,
      style: _MateoGhostSelectPresentation._descriptionStyle.copyWith(
        color: menuColorScheme!.description,
      ),
      maxLines: _MateoGhostSelectPresentation._descriptionMaxLines,
      overflow: TextOverflow.ellipsis,
    );
    if (triggerHeight == null) return description;
    return Opacity(
      opacity: _MateoGhostSelectPresentation._descriptionCurve.transform(menuProgress),
      child: description,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget icon = SizedBox.square(
      key: ValueKey<Object>(('mateo_select_icon', option.value)),
      dimension: _MateoGhostSelectPresentation._iconSlotSize,
      child: Center(
        child: option.iconBuilder(
          MateoSelectState(
            iconSize: _MateoGhostSelectPresentation._iconSize,
            recommendedIconColor: menuColorScheme?.icon ?? colorScheme.icon,
          ),
        ),
      ),
    );
    if (triggerHeight case final height?) {
      icon = Transform.translate(
        offset: Offset(
          0,
          (height - _MateoGhostSelectPresentation._iconSlotSize) / 2 * (1 - menuProgress),
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
          const SizedBox(width: _MateoGhostSelectPresentation._iconSpacing),
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitle(context),
                if (option.description case final value? when _isInMenu) ...[
                  const SizedBox(height: _MateoGhostSelectPresentation._descriptionSpacing),
                  _buildDescription(value),
                ],
              ],
            ),
          ),
          if (!_isInMenu) ...[
            const SizedBox(width: _MateoGhostSelectPresentation._chevronSpacing),
            MateoIcon.chevronDown(
              key: ValueKey<Object>(('mateo_select_source_chevron', option.value)),
              width: _MateoGhostSelectPresentation._chevronSize,
              height: _MateoGhostSelectPresentation._chevronSize,
              color: colorScheme.chevron,
            ),
          ],
        ],
      ),
    );
  }
}
