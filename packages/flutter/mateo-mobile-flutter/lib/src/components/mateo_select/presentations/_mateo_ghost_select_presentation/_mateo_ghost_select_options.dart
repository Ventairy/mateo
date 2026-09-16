part of '../../mateo_select.dart';

final class _MateoGhostSelectOptions<T> extends StatelessWidget {
  const _MateoGhostSelectOptions({
    required this.options,
    required this.selectedValue,
    required this.movingValue,
    required this.triggerOffset,
    required this.triggerSize,
    required this.movement,
    required this.optionsOpacity,
    required this.colorScheme,
    required this.menuColorScheme,
    required this.optionKeyFor,
    required this.onPressed,
    super.key,
  });

  final List<MateoSelectOption<T>> options;
  final T selectedValue;
  final T movingValue;
  final Offset triggerOffset;
  final Size triggerSize;
  final Animation<double> movement;
  final Animation<double> optionsOpacity;
  final MateoSelectVariantColorScheme colorScheme;
  final MateoMenuColorScheme menuColorScheme;
  final GlobalKey Function(T value) optionKeyFor;
  final void Function(MateoSelectOption<T> option, Future<void> pressAnimation) onPressed;

  static EdgeInsetsDirectional optionPadding(int index, int count) => EdgeInsetsDirectional.only(
    start: _MateoGhostSelectPresentation._menuLeadingPadding,
    end: _MateoGhostSelectPresentation._menuTrailingPadding,
    top: index == 0
        ? _MateoGhostSelectPresentation._menuVerticalPadding
        : _MateoGhostSelectPresentation._optionSpacing / 2,
    bottom: index == count - 1
        ? _MateoGhostSelectPresentation._menuVerticalPadding
        : _MateoGhostSelectPresentation._optionSpacing / 2,
  );

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: SingleChildScrollView(
        clipBehavior: Clip.none,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final (index, option) in options.indexed)
              Semantics(
                key: ValueKey<Object>(('mateo_select_option_semantics', option.value)),
                button: true,
                enabled: true,
                selected: option.value == selectedValue,
                inMutuallyExclusiveGroup: true,
                label: option.title,
                hint: option.description,
                onTap: () => onPressed(option, Future<void>.value()),
                child: ExcludeSemantics(
                  child: MateoTap(
                    key: optionKeyFor(option.value),
                    onPressed: (animation) {
                      onPressed(option, animation);
                      return Future<void>.value();
                    },
                    animation: _MateoGhostSelectPresentation._optionPressAnimation,
                    child: Padding(
                      // Keep the visual insets inside the stable tap box so
                      // every point on the panel belongs to an option.
                      padding: optionPadding(index, options.length),
                      child: _buildOption(context, option),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(
    MateoSelectOption<T> option,
    MateoMenuColorScheme colors, {
    double menuProgress = 1,
    double? triggerHeight,
  }) => _MateoGhostSelectOptionContent(
    key: ValueKey<Object>(('mateo_select_option', option.value)),
    option: option,
    menuColorScheme: colors,
    colorScheme: colorScheme,
    padding: const EdgeInsetsDirectional.only(
      end: _MateoGhostSelectPresentation._contentHorizontalPadding,
    ),
    menuProgress: menuProgress,
    triggerHeight: triggerHeight,
  );

  Widget _buildOption(BuildContext context, MateoSelectOption<T> option) {
    if (option.value != movingValue) {
      return FadeTransition(
        opacity: optionsOpacity,
        child: _buildContent(option, menuColorScheme),
      );
    }

    return AnimatedBuilder(
      animation: movement,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: _MateoGhostSelectPresentation._contentHorizontalPadding,
        ),
        child: Align(
          alignment: Alignment.centerRight,
          child: MateoIcon.chevronDown(
            key: ValueKey<Object>(('mateo_select_closed_flight_option', option.value)),
            width: _MateoGhostSelectPresentation._chevronSize,
            height: _MateoGhostSelectPresentation._chevronSize,
            color: colorScheme.chevron,
          ),
        ),
      ),
      builder: (context, chevron) {
        final progress = movement.value;
        final leadingInset = Directionality.of(context) == TextDirection.ltr
            ? _MateoGhostSelectPresentation._triggerLeadingPadding
            : -_MateoGhostSelectPresentation._triggerLeadingPadding;

        return Transform.translate(
          offset: triggerOffset * (1 - progress),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Transform.translate(
                offset: Offset(leadingInset * (1 - progress), 0),
                child: _buildContent(
                  option,
                  menuColorScheme.copyWith(
                    title: Color.lerp(colorScheme.title, menuColorScheme.title, progress),
                    icon: Color.lerp(colorScheme.icon, menuColorScheme.icon, progress),
                  ),
                  menuProgress: progress,
                  triggerHeight: triggerSize.height,
                ),
              ),
              Positioned(
                left: 0,
                top: 0,
                width: triggerSize.width,
                height: triggerSize.height,
                child: IgnorePointer(
                  child: Opacity(
                    opacity: 1 - _MateoGhostSelectPresentation._chevronCurve.transform(progress),
                    child: chevron,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
