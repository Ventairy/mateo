part of '../../mateo_text_input.dart';

final class _MateoGeneralTextInputPresentation extends MateoTextInputPresentation {
  const _MateoGeneralTextInputPresentation({
    required this.variant,
    this.size = .standard,
    this.purpose = .text,
  }) : assert(
         variant == MateoTextInputVariant.plain || variant == MateoTextInputVariant.filled,
         'Base is not supported by general',
       ),
       super._();

  @override
  final MateoTextInputVariant variant;

  @override
  final MateoTextInputSize size;

  final MateoTextInputPurpose purpose;

  @override
  double get elevation => 0;

  @override
  State<_MateoGeneralTextInputPresentation> createState() => _MateoGeneralTextInputPresentationState();
}

class _MateoGeneralTextInputPresentationState extends State<_MateoGeneralTextInputPresentation> {
  final _scrollController = ScrollController();
  final _metricsChanged = ValueNotifier<ScrollMetrics?>(null);
  late final _fadeRepaint = Listenable.merge([_scrollController, _metricsChanged]);

  Drag? _scrollDrag;

  void _startScrollDrag(DragStartDetails details) {
    _cancelScrollDrag();
    if (!_scrollController.hasClients) return;
    _scrollDrag = _scrollController.positions.last.drag(details, () => _scrollDrag = null);
  }

  void _updateScrollDrag(DragUpdateDetails details) => _scrollDrag?.update(details);
  void _endScrollDrag(DragEndDetails details) => _scrollDrag?.end(details);
  void _cancelScrollDrag() => _scrollDrag?.cancel();

  Widget _buildDragRegion({required Widget child, required bool enabled}) => Stack(
    children: [
      child,
      Positioned.fill(
        child: GestureDetector(
          behavior: .translucent,
          excludeFromSemantics: true,
          supportedDevices: const {PointerDeviceKind.touch},
          onHorizontalDragStart: enabled ? _startScrollDrag : null,
          onHorizontalDragUpdate: enabled ? _updateScrollDrag : null,
          onHorizontalDragEnd: enabled ? _endScrollDrag : null,
          onHorizontalDragCancel: enabled ? _cancelScrollDrag : null,
        ),
      ),
    ],
  );

  bool get _isFilled => widget.variant == MateoTextInputVariant.filled.neutral;

  List<MateoEdgeFadeBand> _resolveFadeBands(Size bounds, TextDirection direction) {
    final position = _scrollController.hasClients ? _scrollController.positions.last : null;
    return _MateoGeneralTextInputFadeProfile.resolve(
      bounds: bounds,
      textInsets: EdgeInsetsDirectional.only(start: widget.size.leadingPadding, end: widget.size.trailingPadding),
      direction: direction,
      metrics: position != null && position.hasContentDimensions ? position : _metricsChanged.value,
    );
  }

  Widget _buildTreatment({required Widget child, required Color background, required TextDirection direction}) {
    if (!_isFilled) return child;

    return MateoSurface(
      color: background,
      shape: const .capsule(),
      child: NotificationListener<ScrollMetricsNotification>(
        onNotification: (notification) {
          _metricsChanged.value = notification.metrics;
          return false;
        },
        child: RepaintBoundary(
          child: BaseMateoEdgeFade.overlay(
            color: background,
            repaint: _fadeRepaint,
            resolveBands: (bounds) => _resolveFadeBands(bounds, direction),
            child: child,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cancelScrollDrag();
    _scrollController.dispose();
    _metricsChanged.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(_MateoGeneralTextInputPresentation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.purpose == widget.purpose && oldWidget.variant == widget.variant) return;
    _cancelScrollDrag();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final scope = _MateoTextInputPresentationScope.of(context);
      if (!scope.enabled || !scope.focusNode.hasFocus) return;
      scope.focusNode.context?.findAncestorStateOfType<EditableTextState>()?.requestKeyboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.variant == MateoTextInputVariant.filled.base) {
      throw UnsupportedError('Base is not supported by general');
    }

    final scope = _MateoTextInputPresentationScope.of(context);
    final theme = MateoTheme.of(context);
    final colors = widget.variant.resolveColorScheme(theme.colorScheme.textInputs);
    final typography = widget.variant.resolveTypography(widget.size);
    final style = TextStyle(
      fontFamily: MateoTypography.interfaceFontFamily,
      letterSpacing: (MediaQuery.maybeTextScalerOf(context) ?? TextScaler.noScaling).scale(typography.fontSize) * -0.02,
      fontSize: typography.fontSize,
      height: typography.lineHeight / typography.fontSize,
      fontWeight: .w500,
      color: scope.enabled ? colors.text : colors.textDisabled,
      leadingDistribution: .even,
    );

    return Localizations.override(
      context: context,
      delegates: const [GlobalCupertinoLocalizations.delegate],
      child: Directionality(
        textDirection: Directionality.of(context),
        child: CupertinoTheme(
          data: CupertinoThemeData(brightness: .light, primaryColor: theme.colorScheme.accent),
          child: _buildTreatment(
            background: scope.enabled ? colors.background : colors.backgroundDisabled,
            direction: Directionality.of(context),
            child: _buildDragRegion(
              enabled: scope.enabled,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: widget.size.height),
                child: _MateoTextInputSelectionOverflow(
                  repaint: Listenable.merge([scope.controller, scope.focusNode, _fadeRepaint]),
                  child: CupertinoTextField(
                    // Flutter does not refresh same-keyboard typing settings in place.
                    // A new editor applies those settings when the purpose changes.
                    key: ValueKey(widget.purpose),
                    controller: scope.controller,
                    scrollController: _scrollController,
                    scrollPhysics: const BouncingScrollPhysics(),
                    focusNode: scope.focusNode,
                    autofocus: scope.autofocus && scope.enabled,
                    enabled: scope.enabled,
                    keyboardType: widget.purpose.keyboardType,
                    textCapitalization: widget.purpose.textCapitalization,
                    autocorrect: widget.purpose.autocorrect,
                    enableSuggestions: widget.purpose.enableSuggestions,
                    smartDashesType: widget.purpose.smartDashesType,
                    smartQuotesType: widget.purpose.smartQuotesType,
                    autofillHints: widget.purpose.autofillHints,
                    inputFormatters: widget.purpose.inputFormatters,
                    textInputAction: .done,
                    onChanged: scope.onChanged,
                    onSubmitted: scope.onSubmitted,
                    selectionControls: _MateoTextInputEditingControls.selectionControls,
                    contextMenuBuilder: _MateoTextInputEditingControls.buildContextMenu,
                    placeholder: scope.placeholder,
                    style: style,
                    placeholderStyle: style.copyWith(
                      color: scope.enabled ? colors.placeholder : colors.placeholderDisabled,
                      overflow: .visible,
                    ),
                    cursorColor: theme.colorScheme.accent,
                    decoration: const BoxDecoration(),
                    clipBehavior: _isFilled ? Clip.none : Clip.hardEdge,
                    padding: EdgeInsetsDirectional.only(
                      start: _isFilled ? widget.size.leadingPadding : 0,
                      end: widget.size.trailingPadding,
                      top: (widget.size.height - typography.lineHeight) / 2,
                      bottom: (widget.size.height - typography.lineHeight) / 2,
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
