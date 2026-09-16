part of '../mateo_button.dart';

final class _MateoIconButtonPresentation extends MateoButtonPresentation {
  const _MateoIconButtonPresentation({
    required this.icon,
    this.variant,
    this.colorScheme,
    this.size = .standard,
    this.elevation = 0,
    this.semanticLabel,
  }) : super._();

  final Widget icon;
  @override
  final MateoButtonVariant? variant;
  @override
  final MateoButtonColorScheme? colorScheme;
  @override
  final MateoButtonSize size;
  @override
  final double elevation;
  final String? semanticLabel;

  @override
  State<_MateoIconButtonPresentation> createState() => _MateoIconButtonPresentationState();
}

class _MateoIconButtonPresentationState extends State<_MateoIconButtonPresentation>
    with SingleTickerProviderStateMixin {
  ({double iconSize, double loadingIndicatorSize}) get _dimensions => switch (widget.size) {
    .mini => (iconSize: 22, loadingIndicatorSize: 18),
    .small => (iconSize: 26, loadingIndicatorSize: 22),
    .standard => (iconSize: 30, loadingIndicatorSize: 24),
  };

  bool _loading = false;
  bool _immediate = false;
  bool _initialized = false;

  late final AnimationController _loadingTransition = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 160),
    value: _loading ? 1 : 0,
  )..addStatusListener(_transitionChanged);

  late final Animation<double> _contentOpacity = ReverseAnimation(_loadingTransition);
  static const double _hiddenScale = 0.8;
  late final Animation<double> _contentScale = Tween<double>(begin: 1, end: _hiddenScale).animate(_loadingTransition);
  late final Animation<double> _activityScale = Tween<double>(begin: _hiddenScale, end: 1).animate(_loadingTransition);

  void _transitionChanged(AnimationStatus status) {
    if (status == .dismissed) setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final loading = _MateoButtonPresentationScope.of(context).loading;
    final immediate = (MediaQuery.maybeDisableAnimationsOf(context) ?? false) || !TickerMode.valuesOf(context).enabled;
    if (_initialized && loading == _loading && immediate == _immediate) return;
    _loading = loading;
    _immediate = immediate;
    if (!_initialized || immediate) {
      _loadingTransition.value = loading ? 1 : 0;
    } else if (loading) {
      _loadingTransition.animateTo(1, curve: Curves.easeOutCubic);
    } else {
      _loadingTransition.animateBack(0, curve: Curves.easeOutCubic);
    }
    _initialized = true;
  }

  @override
  void dispose() {
    _loadingTransition.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dimensions = _dimensions;
    final scope = _MateoButtonPresentationScope.of(context);
    final theme = MateoTheme.of(context);
    final variant = widget.variant ?? MateoButtonVariant.primary;
    final colors = widget.colorScheme ?? variant.resolveColorScheme(theme.colorScheme.buttons);
    final foreground = scope.enabled ? colors.foreground : colors.foregroundDisabled;

    return MateoPress(
      semanticLabel: widget.semanticLabel,
      onPressed: scope.interactive ? (_) => scope.onPressed() : null,
      animation: variant.pressAnimation,
      child: SizedBox.square(
        dimension: math.max(48, widget.size.height),
        child: Center(
          child: MateoSurface(
            color: scope.enabled ? colors.background : colors.backgroundDisabled,
            shape: const .capsule(),
            elevation: MateoElevation(level: widget.elevation),
            child: SizedBox.square(
              dimension: widget.size.height,
              child: Center(
                child: SizedBox.square(
                  dimension: math.max(dimensions.iconSize, dimensions.loadingIndicatorSize),
                  child: Stack(
                    alignment: .center,
                    children: [
                      // Retain content layout and its accessible name while activity is shown.
                      FadeTransition(
                        opacity: _contentOpacity,
                        alwaysIncludeSemantics: true,
                        child: ScaleTransition(
                          scale: _immediate ? const AlwaysStoppedAnimation(1) : _contentScale,
                          child: MateoIconScope(
                            size: dimensions.iconSize,
                            color: foreground,
                            child: widget.icon,
                          ),
                        ),
                      ),
                      if (_loading || !_loadingTransition.isDismissed)
                        Positioned.fill(
                          child: ExcludeSemantics(
                            child: IgnorePointer(
                              child: Align(
                                alignment: .center,
                                child: FadeTransition(
                                  opacity: _loadingTransition,
                                  child: ScaleTransition(
                                    scale: _immediate ? const AlwaysStoppedAnimation(1) : _activityScale,
                                    child: SizedBox(
                                      width: dimensions.loadingIndicatorSize,
                                      height: dimensions.loadingIndicatorSize,
                                      child: MateoLoadingIndicator(
                                        presentation: .circular(
                                          size: dimensions.loadingIndicatorSize,
                                          color: foreground,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
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
