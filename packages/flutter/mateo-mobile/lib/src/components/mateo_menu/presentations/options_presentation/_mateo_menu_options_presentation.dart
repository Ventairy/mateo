part of '../../mateo_menu.dart';

final class _MateoMenuOptionsPresentation extends MateoMenuPresentation {
  _MateoMenuOptionsPresentation({
    required List<MateoMenuOptionsPresentationItem> items,
    super.density = .standard,
    super.width = .fit,
  }) : items = List.unmodifiable(items),
       super._() {
    if (this.items.isEmpty) throw ArgumentError.value(items, 'items', 'Menu options must not be empty.');
  }

  final List<MateoMenuOptionsPresentationItem> items;

  double get _radius => switch (density) {
    .compact => 34,
    .standard => 38,
  };

  double _itemGap(int index) {
    final hasSupporting = items[index].supporting != null || items[index + 1].supporting != null;
    return switch (density) {
      .compact => hasSupporting ? 12 : 8,
      .standard => hasSupporting ? 20 : 16,
    };
  }

  Widget _sizeContent(Widget child) => switch (width) {
    .fit => IntrinsicWidth(child: child),
    .fill => SizedBox(width: double.infinity, child: child),
  };

  @override
  Widget build(BuildContext context) {
    final scope = _MateoMenuPresentationScope.of(context);
    final maximumWidth = (MediaQuery.sizeOf(context).width - density.screenEdgeInset * 2).clamp(0.0, double.infinity);

    return MateoSurface(
      color: MateoTheme.of(context).colorScheme.menus.options.background,
      shape: .rounded(radius: _radius),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maximumWidth,
        ),
        child: _sizeContent(
          Column(
            mainAxisSize: .min,
            crossAxisAlignment: .stretch,
            children: [
              for (var index = 0; index < items.length; index++)
                _MateoMenuOptionsPresentationRow(
                  item: items[index],
                  density: density,
                  topInset: index == 0 ? density.verticalPadding : _itemGap(index - 1) / 2,
                  bottomInset: index == items.length - 1 ? density.verticalPadding : _itemGap(index) / 2,
                  onPressed: scope.onItemPressed == null ? null : () => scope.onItemPressed!(items[index]),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
