part of '../../mateo_select.dart';

final class _MateoGhostSelectMenu extends StatelessWidget {
  const _MateoGhostSelectMenu({
    required this.info,
    required this.mediaQuery,
    required this.focusNode,
    required this.isClosing,
    required this.onDismiss,
    required this.onReopen,
    required this.animation,
    required this.child,
  });

  final RawMenuOverlayInfo info;
  final MediaQueryData mediaQuery;
  final FocusNode focusNode;
  final bool isClosing;
  final VoidCallback onDismiss;
  final VoidCallback onReopen;
  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final geometry = _MateoGhostSelectMenuPlacement.resolve(
      overlaySize: info.overlaySize,
      sourceRect: info.anchorRect,
      mediaQuery: mediaQuery,
      horizontalSafeAreaGutter: _MateoGhostSelectPresentation._horizontalSafeAreaGutter,
    );
    return Focus(
      focusNode: focusNode,
      canRequestFocus: !isClosing,
      descendantsAreFocusable: !isClosing,
      onKeyEvent: (_, event) {
        if (event is! KeyDownEvent || event.logicalKey != LogicalKeyboardKey.escape) {
          return KeyEventResult.ignored;
        }
        onDismiss();
        return KeyEventResult.handled;
      },
      child: BlockSemantics(
        child: ExcludeSemantics(
          excluding: isClosing,
          child: Semantics(
            key: const Key('mateo_select_overlay_semantics'),
            scopesRoute: true,
            explicitChildNodes: true,
            expanded: true,
            child: Stack(
              children: [
                IgnorePointer(
                  ignoring: isClosing,
                  child: SizedBox.fromSize(
                    size: info.overlaySize,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned.fill(
                          child: AnimatedModalBarrier(
                            key: const Key('mateo_select_barrier'),
                            color: animation.drive(
                              ColorTween(
                                begin: Colors.transparent,
                                end: context.mateo.colorScheme.menu.action.scrim,
                              ),
                            ),
                            semanticsLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
                            onDismiss: onDismiss,
                          ),
                        ),
                        Positioned(
                          key: const Key('mateo_select_panel_position'),
                          left: geometry.left,
                          right: geometry.right,
                          top: geometry.top,
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: geometry.maxWidth,
                                maxHeight: geometry.maxHeight,
                              ),
                              child: MediaQuery(data: mediaQuery, child: child),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (isClosing)
                  Positioned.fromRect(
                    rect: info.anchorRect,
                    child: GestureDetector(
                      key: const Key('mateo_select_reopen_target'),
                      behavior: HitTestBehavior.opaque,
                      onTap: onReopen,
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
