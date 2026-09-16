part of '../mateo_button.dart';

@immutable
final class _MateoIconButtonPresentation extends MateoButtonPresentation {
  const _MateoIconButtonPresentation({
    required this.iconBuilder,
    required this.variant,
    this.elevation = 0,
    this.semanticLabel,
    this.colorScheme,
    this.buttonSize = 53,
    double? hitAreaSize,
    this.iconSize = 22,
  }) : assert(buttonSize > 0 && buttonSize < double.infinity, 'buttonSize must be finite and positive.'),
       assert(iconSize > 0 && iconSize < double.infinity, 'iconSize must be finite and positive.'),
       assert(
         hitAreaSize == null || (hitAreaSize >= buttonSize && hitAreaSize < double.infinity),
         'hitAreaSize must be finite and at least buttonSize.',
       ),
       _requestedHitAreaSize = hitAreaSize,
       super._();

  final MateoIconButtonIconBuilder iconBuilder;
  @override
  final MateoButtonVariant variant;
  @override
  final double elevation;
  final String? semanticLabel;
  @override
  final MateoButtonColorScheme? colorScheme;
  final double buttonSize;
  final double? _requestedHitAreaSize;
  final double iconSize;

  @override
  double get _buttonSize => buttonSize;

  @override
  Duration get _contentTransitionDuration => const Duration(milliseconds: 300);

  BorderRadius get _borderRadius => BorderRadius.circular(buttonSize / 2);

  @override
  State<_MateoIconButtonPresentation> createState() => _MateoIconButtonPresentationState();
}

final class _MateoIconButtonPresentationState extends State<_MateoIconButtonPresentation> {
  late _MateoButtonOwner _owner;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _owner = _MateoButtonPresentationScope.ownerOf(context);
  }

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
      borderRadius: widget._borderRadius,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = _buttonState(context);
    final content = _owner.showLoadingIndicator
        ? _buildLoading(state)
        : _owner.showTransitionOverlay
        ? Stack(alignment: Alignment.center, children: [_buildIcon(state), _buildLoading(state)])
        : _buildIcon(state);
    final laidOutContent = SizedBox.square(
      key: const Key('mateo_button_container'),
      dimension: widget.buttonSize,
      child: Center(child: content),
    );
    final shadows = MateoElevation.toShadows(elevation: state.elevation, palette: context.mateo.palette);
    final defaultSurface = DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: shadows.isEmpty ? null : shadows,
        color: state.backgroundColor,
        borderRadius: state.borderRadius,
      ),
      child: laidOutContent,
    );
    final backgroundBuilder = MateoButtonScope.maybeOf(context)?.backgroundBuilder;
    final surface = backgroundBuilder?.call(state, laidOutContent) ?? defaultSurface;
    final hitAreaSize = widget._requestedHitAreaSize ?? widget.buttonSize;
    return MateoTap(
      semanticLabel: widget.semanticLabel,
      onPressed: state.isInteractive ? (_) => _owner.handlePressed() : null,
      onPressChanged: state.isInteractive ? (pressed) => _owner.updatePressed(pressed: pressed) : null,
      animation: widget.variant == MateoButtonVariant.tertiary
          ? MateoTapAnimationType.scaleFade
          : MateoTapAnimationType.scale,
      child: SizedBox.square(
        key: const Key('mateo_button_tap_target'),
        dimension: hitAreaSize,
        child: Center(child: surface),
      ),
    );
  }

  Widget _buildIcon(MateoButtonState state) => FadeTransition(
    opacity: _owner.contentOpacity,
    child: SizedBox.square(
      key: const Key('mateo_button_icon_box'),
      dimension: widget.iconSize,
      child: FittedBox(
        fit: BoxFit.contain,
        child: widget.iconBuilder(
          MateoIconButtonIconState(
            isEnabled: state.isEnabled,
            isInteractive: state.isInteractive,
            isPressed: state.isPressed,
            isLoading: state.isLoading,
            backgroundColor: state.backgroundColor,
            foregroundColor: state.foregroundColor,
            borderRadius: state.borderRadius,
            elevation: state.elevation,
            iconSize: widget.iconSize,
          ),
        ),
      ),
    ),
  );

  Widget _buildLoading(MateoButtonState state) => MateoCircularLoadingIndicator(
    key: _owner.loadingIndicatorKey,
    size: math.max(0, math.min(widget.iconSize + 8, widget.buttonSize - 12)),
    color: state.foregroundColor,
    trackColor: state.foregroundColor.withValues(alpha: 0.24),
  );
}
