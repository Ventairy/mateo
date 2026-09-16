part of '../../mateo_select.dart';

final class _MateoGhostSelectTrigger<T> extends StatelessWidget {
  const _MateoGhostSelectTrigger({
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
                animation: _MateoGhostSelectPresentation._sourcePressAnimation,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: math.max<double>(
                      0,
                      mediaQuery.size.width -
                          mediaQuery.padding.horizontal -
                          _MateoGhostSelectPresentation._horizontalSafeAreaGutter * 2,
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
                          borderRadius: _MateoGhostSelectPresentation._borderRadius,
                        ),
                        clipBehavior: Clip.antiAlias,
                        padding: const EdgeInsets.symmetric(
                          vertical: _MateoGhostSelectPresentation._triggerVerticalPadding,
                        ),
                        child: _MateoGhostSelectOptionContent(
                          key: ValueKey<Object>(('mateo_select_source_option', option.value)),
                          option: option,
                          colorScheme: colors,
                          padding: const EdgeInsetsDirectional.only(
                            start: _MateoGhostSelectPresentation._triggerLeadingPadding,
                            end: _MateoGhostSelectPresentation._contentHorizontalPadding,
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
