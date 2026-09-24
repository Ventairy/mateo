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
    .standard => 40,
  };

  double _itemGap(int index) {
    final hasSupporting = items[index].supporting != null || items[index + 1].supporting != null;
    return switch (density) {
      .compact => hasSupporting ? 12 : 8,
      .standard => hasSupporting ? 18 : 18,
    };
  }

  Widget _sizeContent(Widget child) => switch (width) {
    .fit => IntrinsicWidth(child: child),
    .fill => SizedBox(width: double.infinity, child: child),
  };

  double? _singleLineHeight(BuildContext context, TextStyle principalStyle) {
    if (!items.any((item) => item.leading != null && item.principal != null && item.supporting == null)) {
      return null;
    }

    final painter = TextPainter(
      text: TextSpan(text: ' ', style: principalStyle),
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
      textHeightBehavior: const TextHeightBehavior(applyHeightToFirstAscent: false),
    );
    try {
      painter.layout();
      return painter.height;
    } finally {
      painter.dispose();
    }
  }

  double get _minimumPanelHeight {
    final minimumRowHeight = switch (density) {
      .compact => 48.0,
      .standard => 56.0,
    };
    var height = items.length * minimumRowHeight + 2 * density.verticalPadding;
    for (var index = 0; index < items.length - 1; index++) {
      height += _itemGap(index);
    }
    return height;
  }

  Widget _maybeCullOffscreenRow({required bool isPopOverlay, required bool enabled, required Widget child}) =>
      isPopOverlay ? _MateoMenuViewportPaintCull(enabled: enabled, child: child) : child;

  @override
  Widget build(BuildContext context) {
    final scope = _MateoMenuPresentationScope.of(context);
    final viewportSize = MediaQuery.sizeOf(context);
    final isPopOverlay = MateoMenuPopOverlayScope.exists(context);
    final cullOffscreenRows = isPopOverlay && _minimumPanelHeight > viewportSize.height;
    final maximumWidth = (viewportSize.width - density.screenEdgeInset * 2).clamp(0.0, double.infinity);
    final colors = MateoTheme.of(context).colorScheme.menus.options;
    final textStyles = (
      principal: TextStyle(
        fontFamily: MateoTypography.fontFamily,
        letterSpacing: MateoTypography.letterSpacing,
        fontSize: switch (density) {
          .compact => 15.0,
          .standard => 16.0,
        },
        height: 1.4,
        fontWeight: .w600,
        color: colors.principal,
      ),
      supporting: TextStyle(
        fontFamily: MateoTypography.fontFamily,
        letterSpacing: MateoTypography.letterSpacing,
        fontSize: 14,
        height: 1.4,
        fontWeight: .w500,
        color: colors.supporting,
      ),
    );
    final singleLineHeight = _singleLineHeight(context, textStyles.principal);

    return MateoSurface(
      color: colors.background,
      shape: .rounded(radius: _radius),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maximumWidth),
        child: _sizeContent(
          Column(
            mainAxisSize: .min,
            crossAxisAlignment: .stretch,
            children: [
              for (var index = 0; index < items.length; index++)
                _maybeCullOffscreenRow(
                  isPopOverlay: isPopOverlay,
                  enabled: cullOffscreenRows,
                  child: _MateoMenuOptionsPresentationRow(
                    item: items[index],
                    density: density,
                    topInset: index == 0 ? density.verticalPadding : _itemGap(index - 1) / 2,
                    bottomInset: index == items.length - 1 ? density.verticalPadding : _itemGap(index) / 2,
                    textStyles: textStyles,
                    leadingColor: colors.leading,
                    singleLineHeight: singleLineHeight,
                    onPressed: scope.onItemPressed == null ? null : () => scope.onItemPressed!(items[index]),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
