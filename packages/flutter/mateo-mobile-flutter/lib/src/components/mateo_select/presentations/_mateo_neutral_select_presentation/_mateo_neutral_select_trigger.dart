part of '../../mateo_select.dart';

final class _MateoNeutralSelectTrigger<T> extends StatelessWidget {
  const _MateoNeutralSelectTrigger({
    required this.option,
    required this.colors,
    required this.focusNode,
    required this.triggerKey,
    required this.isOpen,
    required this.isVisible,
    required this.onPressed,
  });

  final MateoSelectOption<T> option;
  final MateoSelectVariantColorScheme colors;
  final FocusNode focusNode;
  final GlobalKey triggerKey;
  final bool isOpen;
  final bool isVisible;
  final Future<void> Function(Future<void>) onPressed;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return IgnorePointer(
      ignoring: isOpen,
      child: ExcludeSemantics(
        excluding: isOpen,
        child: Focus(
          focusNode: focusNode,
          child: Semantics(
            key: const Key('mateo_select_source_semantics'),
            button: true,
            enabled: true,
            expanded: isOpen,
            label: option.title,
            hint: option.description,
            onTap: () => unawaited(onPressed(Future<void>.value())),
            child: ExcludeSemantics(
              child: MateoTap(
                onPressed: onPressed,
                animation: _MateoNeutralSelectPresentation._sourcePressAnimation,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: math.max<double>(
                      0,
                      mediaQuery.size.width -
                          mediaQuery.padding.horizontal -
                          _MateoNeutralSelectPresentation._horizontalSafeAreaGutter * 2,
                    ),
                  ),
                  child: Visibility(
                    visible: isVisible,
                    maintainState: true,
                    maintainAnimation: true,
                    maintainSize: true,
                    child: SizedBox(
                      key: triggerKey,
                      child: Container(
                        key: const Key('mateo_select_source'),
                        decoration: BoxDecoration(
                          color: colors.background,
                          borderRadius: _MateoNeutralSelectPresentation._borderRadius,
                        ),
                        clipBehavior: Clip.antiAlias,
                        padding: const EdgeInsets.symmetric(
                          vertical: _MateoNeutralSelectPresentation._triggerVerticalPadding,
                        ),
                        child: _MateoNeutralSelectOptionContent(
                          key: ValueKey<Object>(('mateo_select_source_option', option.value)),
                          option: option,
                          colorScheme: colors,
                          padding: const EdgeInsetsDirectional.only(
                            start: _MateoNeutralSelectPresentation._triggerLeadingPadding,
                            end: _MateoNeutralSelectPresentation._contentHorizontalPadding,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
