part of '../mateo_button.dart';

final class _MateoLabelButtonPresentation extends MateoButtonPresentation {
  const _MateoLabelButtonPresentation({
    required this.label,
    this.variant,
    this.colorScheme,
    this.size = .standard,
    this.width = .fill,
    this.alignment = .center,
    this.elevation = 0,
    this.leadingIcon,
    this.trailingIcon,
  }) : super._();

  final String label;
  @override
  final MateoButtonVariant? variant;
  @override
  final MateoButtonColorScheme? colorScheme;
  @override
  final MateoButtonSize size;
  final MateoButtonWidth width;
  final MateoButtonAlignment alignment;
  @override
  final double elevation;
  final Widget? leadingIcon;
  final Widget? trailingIcon;

  @override
  State<_MateoLabelButtonPresentation> createState() => _MateoLabelButtonPresentationState();
}

class _MateoLabelButtonPresentationState extends State<_MateoLabelButtonPresentation> with TickerProviderStateMixin {
  ({
    double fontSize,
    double lineHeight,
    double iconSize,
    double horizontalPadding,
    double verticalPadding,
    double loadingIndicatorHeight,
  })
  get _dimensions => switch (widget.size) {
    .mini => (
      fontSize: 14,
      lineHeight: 20,
      iconSize: 16,
      horizontalPadding: 16,
      verticalPadding: 10,
      loadingIndicatorHeight: 12,
    ),
    .small => (
      fontSize: 15,
      lineHeight: 20,
      iconSize: 20,
      horizontalPadding: 20,
      verticalPadding: 14,
      loadingIndicatorHeight: 14,
    ),
    .standard => (
      fontSize: 16,
      lineHeight: 24,
      iconSize: 24,
      horizontalPadding: 24,
      verticalPadding: 16,
      loadingIndicatorHeight: 16,
    ),
  };

  static const _widthSpring = SpringDescription(mass: 1, stiffness: 400, damping: 40);
  static const _widthTolerance = Tolerance(distance: 0.0001, velocity: 0.001);

  late final AnimationController _widthTransition = AnimationController.unbounded(vsync: this);

  void _synchronizeWidth() {
    final target = _loading ? 1.0 : 0.0;
    if (!_initialized || _immediate || widget.width == .fill) {
      _widthTransition.value = target;
    } else {
      _widthTransition.animateWith(
        SpringSimulation(
          _widthSpring,
          _widthTransition.value,
          target,
          _widthTransition.velocity,
          tolerance: _widthTolerance,
          snapToEnd: true,
        ),
      );
    }
  }

  @override
  void didUpdateWidget(_MateoLabelButtonPresentation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.width != widget.width) _widthTransition.value = _loading ? 1 : 0;
  }

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
  late final Animation<double> _loadingIndicatorScale = Tween<double>(
    begin: _hiddenScale,
    end: 1,
  ).animate(_loadingTransition);

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
    _synchronizeWidth();
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
    _widthTransition.dispose();
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
    final contentAlignment = switch (widget.alignment) {
      .left => Alignment.centerLeft,
      .center => Alignment.center,
      .right => Alignment.centerRight,
    };
    final content = FadeTransition(
      opacity: _contentOpacity,
      alwaysIncludeSemantics: true,
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: 32, minHeight: dimensions.lineHeight),
        child: Align(
          alignment: contentAlignment,
          widthFactor: 1,
          heightFactor: 1,
          child: ScaleTransition(
            alignment: contentAlignment,
            scale: _immediate ? const AlwaysStoppedAnimation(1) : _contentScale,
            child: MateoIconScope(
              color: foreground,
              size: dimensions.iconSize,
              child: Row(
                mainAxisSize: .min,
                children: [
                  if (widget.leadingIcon != null) ...[
                    widget.leadingIcon!,
                    const SizedBox(width: 4),
                  ],
                  Flexible(
                    child: FittedBox(
                      fit: .scaleDown,
                      alignment: contentAlignment,
                      child: Text(
                        widget.label,
                        maxLines: 1,
                        softWrap: false,
                        textAlign: switch (widget.alignment) {
                          .left => .left,
                          .center => .center,
                          .right => .right,
                        },
                        style: TextStyle(
                          inherit: false,
                          fontFamily: MateoTypography.fontFamily,
                          fontSize: dimensions.fontSize,
                          height: dimensions.lineHeight / dimensions.fontSize,
                          fontWeight: .w600,
                          letterSpacing: MateoTypography.letterSpacing,
                          color: foreground,
                        ),
                      ),
                    ),
                  ),
                  if (widget.trailingIcon != null) ...[
                    const SizedBox(width: 4),
                    widget.trailingIcon!,
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
    final showLoadingIndicator = _loading || !_loadingTransition.isDismissed;
    final loadingIndicator = ExcludeSemantics(
      child: IgnorePointer(
        child: Align(
          alignment: contentAlignment,
          widthFactor: 1,
          heightFactor: 1,
          child: FadeTransition(
            opacity: _loadingTransition,
            child: ScaleTransition(
              alignment: contentAlignment,
              scale: _immediate ? const AlwaysStoppedAnimation(1) : _loadingIndicatorScale,
              child: MateoLoadingIndicator(
                presentation: .dots(height: dimensions.loadingIndicatorHeight, color: foreground),
              ),
            ),
          ),
        ),
      ),
    );
    return MateoPress(
      semanticLabel: widget.label,
      onPressed: scope.interactive ? (_) => scope.onPressed() : null,
      animation: variant.pressAnimation,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: math.max(0, (48 - widget.size.height) / 2)),
        child: MateoSurface(
          color: scope.enabled ? colors.background : colors.backgroundDisabled,
          shape: const .capsule(),
          elevation: MateoElevation(level: widget.elevation),
          child: SizedBox(
            width: widget.width == .fill ? double.infinity : null,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: 48, minHeight: widget.size.height),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: dimensions.horizontalPadding,
                  vertical: dimensions.verticalPadding,
                ),
                child: widget.width == .fit
                    ? _MateoFittedLabelButtonContent(
                        progress: _widthTransition,
                        alignment: contentAlignment,
                        content: content,
                        loadingIndicator: TickerMode(enabled: showLoadingIndicator, child: loadingIndicator),
                      )
                    : Stack(
                        alignment: contentAlignment,
                        children: [
                          content,
                          if (showLoadingIndicator) Positioned.fill(child: loadingIndicator),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
