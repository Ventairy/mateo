part of '../mateo_button.dart';

@immutable
final class _MateoLabelButtonPresentation extends MateoButtonPresentation {
  const _MateoLabelButtonPresentation({
    required this.label,
    required this.variant,
    this.elevation = 0,
    this.leadingIconBuilder,
    this.trailingIconBuilder,
    MateoButtonAlignment alignment = MateoButtonAlignment.center,
    this.fit = MateoButtonFit.fit,
    EdgeInsetsGeometry? padding,
    this.colorScheme,
  }) : _labelAlignment = alignment,
       _requestedPadding = padding,
       super._();

  final String label;
  @override
  final MateoButtonVariant variant;
  @override
  final double elevation;
  final MateoButtonIconBuilder? leadingIconBuilder;
  final MateoButtonIconBuilder? trailingIconBuilder;
  final MateoButtonAlignment _labelAlignment;
  final MateoButtonFit fit;
  final EdgeInsetsGeometry? _requestedPadding;
  @override
  final MateoButtonColorScheme? colorScheme;

  static const _borderRadius = BorderRadius.all(Radius.circular(34));

  @override
  double? get _buttonSize => null;

  @override
  Duration get _contentTransitionDuration => const Duration(milliseconds: 300);

  @override
  State<_MateoLabelButtonPresentation> createState() => _MateoLabelButtonPresentationState();
}

final class _MateoLabelButtonPresentationState extends State<_MateoLabelButtonPresentation> {
  late _MateoButtonOwner _owner;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _owner = _MateoButtonPresentationScope.ownerOf(context);
  }

  bool get _isTertiary => widget.variant == MateoButtonVariant.tertiary;
  bool get _expand => widget.fit == MateoButtonFit.expand;
  Alignment get _alignment => switch (widget._labelAlignment) {
    MateoButtonAlignment.left => Alignment.centerLeft,
    MateoButtonAlignment.center => Alignment.center,
    MateoButtonAlignment.right => Alignment.centerRight,
  };

  MateoButtonState _buttonState(BuildContext context) {
    final colors = widget.colorScheme ?? widget.variant.colorScheme(context.mateo.colorScheme);
    final enabled = _owner.isEnabled;
    return MateoButtonState(
      isEnabled: enabled,
      isInteractive: _owner.isInteractive,
      isPressed: _owner.isPressed,
      isLoading: _owner.isLoading,
      backgroundColor: switch ((enabled, _owner.isPressed)) {
        (false, _) => colors.backgroundDisabled,
        (true, true) => colors.backgroundPressed,
        (true, false) => colors.background,
      },
      foregroundColor: enabled ? colors.foreground : colors.foregroundDisabled,
      elevation: widget.elevation,
      borderRadius: _MateoLabelButtonPresentation._borderRadius,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = _buttonState(context);
    final content = _buildContent(state);
    final shadows = MateoElevation.toShadows(elevation: state.elevation, palette: context.mateo.palette);
    final backgroundBuilder = MateoButtonScope.maybeOf(context)?.backgroundBuilder;
    final background =
        backgroundBuilder?.call(state, content) ??
        DecoratedBox(
          decoration: BoxDecoration(
            boxShadow: shadows.isEmpty ? null : shadows,
            color: state.backgroundColor,
            borderRadius: state.borderRadius,
          ),
          child: content,
        );
    final interactive = state.isInteractive;
    return MateoTap(
      semanticLabel: null,
      onPressed: interactive ? (_) => _owner.handlePressed() : null,
      onPressChanged: interactive ? (pressed) => _owner.updatePressed(pressed: pressed) : null,
      animation: _isTertiary ? MateoTapAnimationType.scaleFade : MateoTapAnimationType.scale,
      child: _expand ? SizedBox(width: double.infinity, child: background) : background,
    );
  }

  Widget _buildContent(MateoButtonState state) {
    final content = Text(
      widget.label,
      style: TextStyle(
        fontFamily: MateoTypography.fontFamily,
        fontSize: _isTertiary ? 16 : 15,
        fontWeight: FontWeight.w600,
        letterSpacing: MateoTypography.letterSpacing,
        color: state.foregroundColor,
      ),
    );
    final children = <Widget>[];
    if (widget.leadingIconBuilder case final builder?) {
      children.add(Padding(padding: const EdgeInsets.only(right: 10), child: builder(state)));
    }
    children.add(content);
    if (widget.trailingIconBuilder case final builder?) {
      children.add(Padding(padding: const EdgeInsets.only(left: 10), child: builder(state)));
    }
    final foreground = children.length == 1 ? content : Row(mainAxisSize: MainAxisSize.min, children: children);
    if (_expand) {
      return Padding(
        key: const Key('mateo_button_container'),
        padding:
            widget._requestedPadding ??
            (_isTertiary ? EdgeInsets.zero : const EdgeInsets.symmetric(horizontal: 24, vertical: 20)),
        child: Stack(
          children: [
            Align(
              alignment: _alignment,
              heightFactor: 1,
              child: MediaQuery.disableAnimationsOf(context)
                  ? Opacity(opacity: _owner.showLoadingIndicator ? 0 : 1, child: foreground)
                  : FadeTransition(opacity: _owner.contentOpacity, child: foreground),
            ),
            if (_owner.showLoadingIndicator)
              Positioned.fill(
                child: Align(alignment: _alignment, heightFactor: 1, child: _buildLoading(state)),
              ),
          ],
        ),
      );
    }
    final animated = _owner.showLoadingIndicator
        ? _buildLoading(state)
        : _owner.showTransitionOverlay
        ? Stack(
            alignment: Alignment.center,
            children: [
              FadeTransition(opacity: _owner.contentOpacity, child: foreground),
              _buildLoading(state),
            ],
          )
        : FadeTransition(opacity: _owner.contentOpacity, child: foreground);
    final sized = _isTertiary || _owner.showLoadingIndicator
        ? animated
        : AnimatedSize(
            duration: widget._contentTransitionDuration,
            curve: Curves.easeOutCubic,
            alignment: Alignment.center,
            child: animated,
          );
    return Padding(
      key: const Key('mateo_button_container'),
      padding:
          widget._requestedPadding ??
          (_isTertiary ? EdgeInsets.zero : const EdgeInsets.symmetric(horizontal: 24, vertical: 20)),
      child: sized,
    );
  }

  Widget _buildLoading(MateoButtonState state) => MateoDotsLoadingIndicator(
    key: _owner.loadingIndicatorKey,
    color: state.foregroundColor,
    dotRadius: 4,
  );
}
