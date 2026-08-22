part of 'mateo_bottom_sheet.dart';

class _MateoBottomSheetSurface<T> extends StatelessWidget {
  const _MateoBottomSheetSurface({
    required this.route,
    required this.animation,
    required this.child,
  });

  static const double _maximumEstimatedBottomCornerRadius = 50;
  static const double _contentPadding = 20;
  static const double _outerMargin = 12;

  static BorderRadius _resolveBorderRadius(
    MediaQueryData mediaQuery,
    TargetPlatform platform,
  ) {
    const double _defaultBorderRadius = 36;
    final displayCornerRadii = mediaQuery.displayCornerRadii;

    if (displayCornerRadii != null) {
      return BorderRadius.only(
        topLeft: const Radius.circular(_defaultBorderRadius),
        topRight: const Radius.circular(_defaultBorderRadius),
        bottomLeft: Radius.circular(
          math.max(
            _defaultBorderRadius,
            displayCornerRadii.bottomLeft.x - _outerMargin,
          ),
        ),
        bottomRight: Radius.circular(
          math.max(
            _defaultBorderRadius,
            displayCornerRadii.bottomRight.x - _outerMargin,
          ),
        ),
      );
    }

    if (platform != TargetPlatform.iOS || mediaQuery.size.shortestSide >= 600) {
      return const BorderRadius.all(Radius.circular(_defaultBorderRadius));
    }

    final estimatedDisplayCornerRadius = math.max(
      mediaQuery.viewPadding.top,
      math.max(mediaQuery.viewPadding.left, mediaQuery.viewPadding.right),
    );

    final bottomCornerRadius = math.min(
      _maximumEstimatedBottomCornerRadius,
      math.max(
        _defaultBorderRadius,
        estimatedDisplayCornerRadius - _outerMargin,
      ),
    );

    return BorderRadius.only(
      topLeft: const Radius.circular(_defaultBorderRadius),
      topRight: const Radius.circular(_defaultBorderRadius),
      bottomLeft: Radius.circular(bottomCornerRadius),
      bottomRight: Radius.circular(bottomCornerRadius),
    );
  }

  final _MateoBottomSheetRoute<T> route;
  final Animation<double> animation;
  final Widget child;

  void _dismiss(MateoBottomSheetDismissSource source) {
    unawaited(route.requestDismiss(source));
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bottomSafeAreaInset = Theme.of(context).platform == TargetPlatform.android ? mediaQuery.padding.bottom : 0.0;
    final availableHeight = math.max(
      0,
      mediaQuery.size.height - mediaQuery.viewInsets.bottom - bottomSafeAreaInset,
    );

    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        key: const Key('mateo_bottom_sheet_outer_padding'),
        padding: EdgeInsets.fromLTRB(
          _outerMargin,
          0,
          _outerMargin,
          mediaQuery.viewInsets.bottom + bottomSafeAreaInset + _outerMargin,
        ),
        child: MediaQuery.removePadding(
          context: context,
          removeBottom: bottomSafeAreaInset > 0,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: availableHeight * _MateoBottomSheetRoute._maximumHeightFraction,
            ),
            child: route.scrollable ? _buildScrollableSheet(context) : _buildIntrinsicSheet(context),
          ),
        ),
      ),
    );
  }

  Widget _buildScrollableSheet(BuildContext context) {
    return DraggableScrollableSheet(
      controller: route._scrollableController,
      initialChildSize: route._initialScrollableExtent,
      minChildSize: route._initialScrollableExtent,
      maxChildSize: 1,
      expand: false,
      shouldCloseOnMinExtent: false,
      builder: (context, scrollController) => route.buildSheetTransition(
        animation: animation,
        child: _buildSheet(
          context,
          expandContent: true,
          content: CustomScrollView(
            key: const Key('mateo_bottom_sheet_scroll_view'),
            controller: scrollController,
            physics: route.draggable ? null : const NeverScrollableScrollPhysics(),
            slivers: [
              SliverSafeArea(
                top: false,
                minimum: const EdgeInsets.all(_contentPadding),
                sliver: SliverToBoxAdapter(child: child),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIntrinsicSheet(BuildContext context) {
    return route.buildSheetTransition(
      animation: animation,
      child: _buildSheet(
        context,
        content: SafeArea(
          top: false,
          minimum: const EdgeInsets.all(_contentPadding),
          child: child,
        ),
      ),
    );
  }

  Widget _buildSheet(
    BuildContext context, {
    required Widget content,
    bool expandContent = false,
  }) {
    final colorScheme = context.mateo.colorScheme.bottomSheet;

    return SizedBox(
      key: route._sheetMeasurementKey,
      width: double.infinity,
      child: _MateoBottomSheetDragSurface(
        route: route,
        child: Semantics(
          onDismiss: () => _dismiss(
            MateoBottomSheetDismissSource.accessibilityAction,
          ),
          child: ClipRSuperellipse(
            borderRadius: _resolveBorderRadius(
              MediaQuery.of(context),
              Theme.of(context).platform,
            ),
            clipBehavior: Clip.antiAlias,
            child: Material(
              key: const Key('mateo_bottom_sheet_surface'),
              color: colorScheme.background,
              child: Stack(
                fit: expandContent ? StackFit.expand : StackFit.loose,
                children: [
                  content,
                  Positioned(
                    top: _contentPadding,
                    right: _contentPadding,
                    child: MateoFloatingActionButton(
                      key: const Key('mateo_bottom_sheet_close_button'),
                      size: 44,
                      tapTargetSize: 44,
                      iconSize: 16,
                      semanticLabel: MaterialLocalizations.of(
                        context,
                      ).closeButtonLabel,
                      iconBuilder: (state) => MateoIcon.cross(
                        key: const Key('mateo_bottom_sheet_close_icon'),
                        width: state.iconSize,
                        height: state.iconSize,
                        color: state.foregroundColor,
                      ),
                      onPressed: () => _dismiss(
                        MateoBottomSheetDismissSource.closeButton,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
