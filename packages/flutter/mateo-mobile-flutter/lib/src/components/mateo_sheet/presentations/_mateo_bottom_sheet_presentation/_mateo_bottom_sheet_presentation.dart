part of '../../mateo_sheet.dart';

@immutable
final class _MateoBottomSheetPresentation extends MateoSheetPresentation {
  const _MateoBottomSheetPresentation({
    this.draggable = true,
    this.resistance = true,
    this.avoidKeyboardInset = true,
    super.key,
  }) : _route = null,
       super._();

  _MateoBottomSheetPresentation._mounted({
    required _MateoBottomSheetPresentation source,
    required this._route,
  }) : draggable = source.draggable,
       resistance = source.resistance,
       avoidKeyboardInset = source.avoidKeyboardInset,
       super._();

  @override
  final bool draggable;

  @override
  final bool resistance;

  @override
  final bool avoidKeyboardInset;

  final _MateoSheetRoute<dynamic>? _route;

  @override
  Duration get _morphDuration => const Duration(milliseconds: 350);

  @override
  Duration get _entranceDuration => const Duration(milliseconds: 270);

  @override
  Duration get _dismissDuration => const Duration(milliseconds: 230);

  @override
  Curve get _settleCurve => Curves.easeOutCubic;

  @override
  Curve _stackExitCurve(bool interactive) =>
      interactive ? _settleCurve : Curves.linear;

  @override
  Curve get _stackReturnCurve => Curves.linear;

  @override
  Curve get _barrierCurve => Curves.easeOutCubic;

  static const double _maximumHeightFraction = 0.85;
  static const double _defaultBorderRadius = 42;
  static const double _closeButtonInset = 20;
  static const double _contentPadding = 20;
  static const double _outerMargin = 12;
  static const double _initialScale = 0.96;
  static const double _closeButtonSize = 50;
  static const double _closeIconSize = 16;
  static const Curve _morphCurve = Curves.easeOutQuint;
  static const Curve _entranceCurve = Curves.easeOutCubic;
  static const Curve _exitCurve = Curves.easeInOutQuad;
  static const Curve _contentFadeCurve = Curves.easeOutCubic;
  static const Duration _contentFadeDuration = Duration(milliseconds: 400);
  static const double _surfaceWidth = double.infinity;
  static const Alignment _alignment = Alignment.bottomCenter;
  static const Offset _exitDirection = Offset(0, 1);
  static const Clip _clipBehavior = Clip.antiAlias;
  static const SystemUiOverlayStyle _systemUiStyle = SystemUiOverlayStyle(
    systemNavigationBarIconBrightness: Brightness.light,
  );
  Color _background(BuildContext context) =>
      context.mateo.colorScheme.sheet.background;

  @override
  Color _scrim(BuildContext context) => context.mateo.colorScheme.overlay.scrim;

  @override
  Widget _build(_MateoSheetRoute<dynamic> route) =>
      _MateoBottomSheetPresentation._mounted(source: this, route: route);

  @override
  Widget _buildModalBarrier(_MateoSheetRoute<dynamic> route) {
    final scrimColor = identical(route._stack.routes.first, route)
        ? route.barrierColor
        : Colors.transparent;
    final color = (route._stack.dismissalAnimation ?? route.animation!).drive(
      ColorTween(
        begin: scrimColor.withValues(alpha: 0),
        end: scrimColor,
      ).chain(CurveTween(curve: route.barrierCurve)),
    );

    return _MateoBottomSheetDragSurface<dynamic>.scrim(
      route: route,
      presentation: this,
      child: AnimatedModalBarrier(
        color: color,
        dismissible: route.barrierDismissible,
        semanticsLabel: route.barrierLabel,
        barrierSemanticsDismissible: route.semanticsDismissible,
        onDismiss: () =>
            unawaited(route.requestDismiss(MateoSheetDismissSource.tapOutside)),
      ),
    );
  }

  @override
  State<_MateoBottomSheetPresentation> createState() =>
      _MateoBottomSheetPresentationState();
}

final class _MateoBottomSheetPresentationState
    extends State<_MateoBottomSheetPresentation> {
  static const _deviceDisplay = DeviceDisplay();

  late final MorphTarget _surfaceTarget = MorphTarget(
    tag: _route._stack.surfaceTag,
  );
  late final MorphTarget _closeTarget = MorphTarget(
    tag: _route._stack.closeTag,
  );

  BorderRadius? _deviceCorners;
  int _cornerRequest = 0;

  _MateoSheetRoute<dynamic> get _route => widget._route!;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _deviceCorners = MediaQuery.maybeDisplayCornerRadiiOf(context);
    unawaited(_readDeviceCorners(++_cornerRequest));
  }

  Future<void> _readDeviceCorners(int request) async {
    try {
      final corners = await _deviceDisplay.cornerRadii(context);
      if (mounted && request == _cornerRequest && corners != _deviceCorners) {
        setState(() => _deviceCorners = corners);
      }
    } on Object {
      // Platforms without display geometry use this presentation's default shape.
    }
  }

  double _safeAreaInset(BuildContext context) =>
      Theme.of(context).platform == TargetPlatform.android
      ? MediaQuery.paddingOf(context).bottom
      : 0;

  double _keyboardInset(BuildContext context) =>
      widget.avoidKeyboardInset ? MediaQuery.viewInsetsOf(context).bottom : 0;

  EdgeInsets _surfacePadding(BuildContext context) => EdgeInsets.fromLTRB(
    _MateoBottomSheetPresentation._outerMargin,
    0,
    _MateoBottomSheetPresentation._outerMargin,
    _MateoBottomSheetPresentation._outerMargin +
        _safeAreaInset(context) +
        _keyboardInset(context),
  );

  BoxConstraints _constraints(BuildContext context) => BoxConstraints(
    maxHeight:
        math.max(
          0,
          MediaQuery.sizeOf(context).height -
              _keyboardInset(context) -
              _safeAreaInset(context),
        ) *
        _MateoBottomSheetPresentation._maximumHeightFraction,
  );

  Widget _padContent(Widget child) => SafeArea(
    top: false,
    minimum: const EdgeInsets.all(
      _MateoBottomSheetPresentation._contentPadding,
    ),
    child: child,
  );

  Widget _removeOuterSafeArea(BuildContext context, Widget child) =>
      MediaQuery.removePadding(
        context: context,
        removeBottom: _safeAreaInset(context) > 0,
        child: child,
      );

  RoundedSuperellipseBorder _shape(BorderRadius? deviceCorners) =>
      RoundedSuperellipseBorder(
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(
            _MateoBottomSheetPresentation._defaultBorderRadius,
          ),
          topRight: const Radius.circular(
            _MateoBottomSheetPresentation._defaultBorderRadius,
          ),
          bottomLeft: _insetCorner(deviceCorners?.bottomLeft ?? Radius.zero),
          bottomRight: _insetCorner(deviceCorners?.bottomRight ?? Radius.zero),
        ),
      );

  Radius _insetCorner(Radius radius) => Radius.elliptical(
    math.max(
      _MateoBottomSheetPresentation._defaultBorderRadius,
      radius.x - _MateoBottomSheetPresentation._outerMargin,
    ),
    math.max(
      _MateoBottomSheetPresentation._defaultBorderRadius,
      radius.y - _MateoBottomSheetPresentation._outerMargin,
    ),
  );

  MateoButtonPresentation _closeButtonPresentation(BuildContext context) =>
      MateoButtonPresentation.icon(
        variant: MateoButtonVariant.primary.base,
        elevation: 1,
        buttonSize: _MateoBottomSheetPresentation._closeButtonSize,
        hitAreaSize: _MateoBottomSheetPresentation._closeButtonSize,
        iconSize: _MateoBottomSheetPresentation._closeIconSize,
        semanticLabel: MaterialLocalizations.of(context).closeButtonLabel,
        iconBuilder: (state) => MateoIcon.cross(
          key: const Key('mateo_sheet_close_icon'),
          width: state.iconSize,
          height: state.iconSize,
          color: state.foregroundColor,
        ),
      );

  void _dismiss(MateoSheetDismissSource source) =>
      unawaited(_route.requestDismiss(source));

  @override
  Widget build(BuildContext context) {
    if (widget._route == null) return const SizedBox.shrink();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _MateoBottomSheetPresentation._systemUiStyle,
      child: Align(
        alignment: _MateoBottomSheetPresentation._alignment,
        child: Padding(
          key: const Key('mateo_sheet_outer_padding'),
          padding: _surfacePadding(context),
          child: _removeOuterSafeArea(
            context,
            ConstrainedBox(
              constraints: _constraints(context),
              child: _buildSurfaceTransition(_buildSurface()),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSurfaceTransition(Widget child) => AnimatedBuilder(
    animation: _route._stack,
    child: child,
    builder: (context, child) => _route.disableAnimations
        ? child!
        : _MateoBottomSheetTransition(
            key: const Key('mateo_sheet_transition'),
            animation: _route._surfaceAnimation,
            isInteractive: () => _route._dragging,
            child: child,
          ),
  );

  Widget _buildSurface() => SizedBox(
    key: _route._sheetMeasurementKey,
    width: _MateoBottomSheetPresentation._surfaceWidth,
    child: _MateoBottomSheetDragSurface<dynamic>(
      route: _route,
      presentation: widget,
      child: Semantics(
        onDismiss: () => _dismiss(MateoSheetDismissSource.accessibilityAction),
        child: Morph(
          target: _surfaceTarget,
          curve: _MateoBottomSheetPresentation._morphCurve,
          watchDestination: true,
          child: Container(
            key: const Key('mateo_sheet_surface'),
            decoration: ShapeDecoration(
              color: widget._background(context),
              shape: _shape(_deviceCorners),
            ),
            clipBehavior: _MateoBottomSheetPresentation._clipBehavior,
            child: Material(
              type: MaterialType.transparency,
              child: Stack(children: [_buildContent(), _buildCloseButton()]),
            ),
          ),
        ),
      ),
    ),
  );

  Widget _buildContent() {
    final content = _padContent(_route.child);
    return MorphDescendant(
      flightBehavior: MorphDescendantFlightBehavior.snapshot,
      child: _route._openedContextually
          ? content
          : Motion(
              effect: const FadeInMotionEffect(
                curve: _MateoBottomSheetPresentation._contentFadeCurve,
                duration: _MateoBottomSheetPresentation._contentFadeDuration,
              ),
              child: content,
            ),
    );
  }

  Widget _buildCloseButton() => Positioned(
    top: _MateoBottomSheetPresentation._closeButtonInset,
    right: _MateoBottomSheetPresentation._closeButtonInset,
    child: Morph(
      target: _closeTarget,
      watchDestination: true,
      child: MateoButton(
        key: const Key('mateo_sheet_close_button'),
        onPressed: () => _dismiss(MateoSheetDismissSource.closeButton),
        presentation: _closeButtonPresentation(context),
      ),
    ),
  );
}
