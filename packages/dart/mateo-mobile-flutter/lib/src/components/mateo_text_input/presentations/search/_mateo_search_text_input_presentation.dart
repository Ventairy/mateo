part of '../../mateo_text_input.dart';

final class _MateoSearchTextInputPresentation extends MateoTextInputPresentation {
  const _MateoSearchTextInputPresentation({required this.variant, this.size = .standard, this.elevation = 0})
    : assert(variant != MateoTextInputVariant.plain, 'Plain is not supported by search'),
      super._();

  @override
  final MateoTextInputVariant variant;

  @override
  final MateoTextInputSize size;

  @override
  final double elevation;

  @override
  State<_MateoSearchTextInputPresentation> createState() => _MateoSearchTextInputPresentationState();
}

class _MateoSearchTextInputPresentationState extends State<_MateoSearchTextInputPresentation> {
  static const _iconTextGap = 4.0;

  final _scrollController = ScrollController();
  final _metricsChanged = ValueNotifier<ScrollMetrics?>(null);
  late final _fadeRepaint = Listenable.merge([_scrollController, _metricsChanged]);
  TextEditingController? _textController;
  bool _hasText = false;
  Drag? _scrollDrag;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final controller = _MateoTextInputPresentationScope.of(context).controller;
    if (identical(controller, _textController)) return;
    _textController?.removeListener(_handleTextChanged);
    _textController = controller;
    _hasText = controller.text.isNotEmpty;
    controller.addListener(_handleTextChanged);
  }

  void _handleTextChanged() {
    final hasText = _textController!.text.isNotEmpty;
    if (hasText == _hasText) return;
    setState(() => _hasText = hasText);
  }

  void _startScrollDrag(DragStartDetails details) {
    _scrollDrag?.cancel();
    if (!_scrollController.hasClients) return;
    _scrollDrag = _scrollController.position.drag(details, () => _scrollDrag = null);
  }

  void _updateScrollDrag(DragUpdateDetails details) => _scrollDrag?.update(details);
  void _endScrollDrag(DragEndDetails details) => _scrollDrag?.end(details);
  void _cancelScrollDrag() => _scrollDrag?.cancel();

  @override
  void dispose() {
    _textController?.removeListener(_handleTextChanged);
    _cancelScrollDrag();
    _scrollController.dispose();
    _metricsChanged.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scope = _MateoTextInputPresentationScope.of(context);
    final theme = MateoTheme.of(context);
    final colors = widget.variant.resolveColorScheme(theme.colorScheme.textInputs);
    final typography = widget.variant.resolveTypography(widget.size);
    final style = TextStyle(
      fontFamily: MateoTypography.fontFamily,
      letterSpacing: MateoTypography.letterSpacing,
      fontSize: typography.fontSize,
      height: typography.lineHeight / typography.fontSize,
      fontWeight: .w500,
      color: scope.enabled ? colors.text : colors.textDisabled,
    );

    return Localizations.override(
      context: context,
      delegates: const [GlobalCupertinoLocalizations.delegate],
      child: Directionality(
        textDirection: Directionality.of(context),
        child: CupertinoTheme(
          data: CupertinoThemeData(brightness: .light, primaryColor: theme.colorScheme.accent),
          child: MateoSurface(
            color: scope.enabled ? colors.background : colors.backgroundDisabled,
            shape: const .capsule(),
            elevation: MateoElevation(level: widget.elevation),
            child: Builder(
              builder: (context) {
                final hasText = _hasText;
                final leadingWidth = widget.size.leadingPadding + widget.size.leadingIconSize;
                final trailingWidth = hasText ? widget.size.trailingPadding + widget.size.trailingIconSize : 0.0;
                final textInsets = EdgeInsetsDirectional.only(
                  start: leadingWidth + _iconTextGap,
                  end: trailingWidth + _iconTextGap,
                );
                return NotificationListener<ScrollMetricsNotification>(
                  onNotification: (notification) {
                    _metricsChanged.value = notification.metrics;
                    return false;
                  },
                  child: Stack(
                    children: [
                      RepaintBoundary(
                        child: BaseMateoEdgeFade.overlay(
                          color: scope.enabled ? colors.background : colors.backgroundDisabled,
                          repaint: _fadeRepaint,
                          resolveBands: (bounds) => _MateoSearchTextInputFadeProfile.resolve(
                            bounds: bounds,
                            textInsets: textInsets,
                            direction: Directionality.of(context),
                            metrics: _scrollController.hasClients && _scrollController.position.hasContentDimensions
                                ? _scrollController.position
                                : null,
                          ),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(minHeight: widget.size.height),
                            child: _MateoTextInputSelectionOverflow(
                              repaint: Listenable.merge([scope.controller, scope.focusNode, _fadeRepaint]),
                              child: CupertinoTextField(
                                controller: scope.controller,
                                scrollController: _scrollController,
                                scrollPhysics: const BouncingScrollPhysics(),
                                focusNode: scope.focusNode,
                                autofocus: scope.autofocus && scope.enabled,
                                enabled: scope.enabled,
                                onChanged: scope.onChanged,
                                onSubmitted: scope.onSubmitted,
                                selectionControls: _MateoTextInputEditingControls.selectionControls,
                                contextMenuBuilder: _MateoTextInputEditingControls.buildContextMenu,
                                textInputAction: .search,
                                placeholder: scope.placeholder,
                                style: style,
                                placeholderStyle: style.copyWith(
                                  color: scope.enabled ? colors.placeholder : colors.placeholderDisabled,
                                  overflow: .visible,
                                ),
                                cursorColor: theme.colorScheme.accent,
                                decoration: const BoxDecoration(),
                                clipBehavior: .none,
                                padding: EdgeInsetsDirectional.only(
                                  start: _iconTextGap,
                                  end: _iconTextGap,
                                  top: (widget.size.height - typography.lineHeight) / 2,
                                  bottom: (widget.size.height - typography.lineHeight) / 2,
                                ),
                                prefix: SizedBox(width: leadingWidth),
                                suffix: hasText ? SizedBox(width: trailingWidth) : null,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: GestureDetector(
                          behavior: .translucent,
                          excludeFromSemantics: true,
                          supportedDevices: const {PointerDeviceKind.touch},
                          onHorizontalDragStart: scope.enabled ? _startScrollDrag : null,
                          onHorizontalDragUpdate: scope.enabled ? _updateScrollDrag : null,
                          onHorizontalDragEnd: scope.enabled ? _endScrollDrag : null,
                          onHorizontalDragCancel: scope.enabled ? _cancelScrollDrag : null,
                        ),
                      ),
                      PositionedDirectional(
                        start: widget.size.leadingPadding,
                        top: 0,
                        bottom: 0,
                        child: RepaintBoundary(
                          child: IgnorePointer(
                            child: ExcludeSemantics(
                              child: Center(
                                child: MateoIcon(
                                  .magnifierGlass,
                                  size: widget.size.leadingIconSize,
                                  color: scope.enabled ? colors.icon : colors.iconDisabled,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (hasText)
                        PositionedDirectional(
                          end: 0,
                          top: 0,
                          bottom: 0,
                          child: TextFieldTapRegion(
                            child: MateoPress(
                              semanticLabel: CupertinoLocalizations.of(context).clearButtonLabel,
                              onPressed: scope.enabled ? (_) => scope.onClear() : null,
                              child: Padding(
                                padding: EdgeInsetsDirectional.only(end: widget.size.trailingPadding),
                                child: Center(
                                  child: MateoIcon(
                                    .crossCircle,
                                    size: widget.size.trailingIconSize,
                                    color: scope.enabled ? colors.icon : colors.iconDisabled,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
