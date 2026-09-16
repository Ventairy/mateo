part of '../../mateo_menu_button.dart';

@immutable
final class _MateoContextMenuPresentation extends MateoMenuPresentation {
  const _MateoContextMenuPresentation() : _session = null, super._();
  const _MateoContextMenuPresentation._mounted(this._session) : super._();
  final _MateoMenuSession? _session;

  static const _radius = 38.0;
  static const _padding = EdgeInsets.fromLTRB(20, 22, 40, 22);
  static const _spacing = 18.0;
  static const _iconSpacing = 20.0;
  static const _descriptionSpacing = 2.0;
  static const _triggerGap = 12.0;
  static const _viewportGutter = 12.0;
  static const _textMaxLines = 2;
  static const Curve _closeCurve = Curves.easeInOutQuad;
  static const _titleStyle = TextStyle(
    fontFamily: MateoTypography.fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: MateoTypography.letterSpacing,
    height: 1.25,
  );
  static const _descriptionStyle = TextStyle(
    fontFamily: MateoTypography.fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: MateoTypography.letterSpacing,
    height: 1.3,
  );

  @override
  State<_MateoContextMenuPresentation> createState() => _MateoContextMenuPresentationState();
  @override
  Color _barrierColor(BuildContext context) => context.mateo.colorScheme.menu.context.scrim;
  @override
  Duration get _openDuration => const Duration(milliseconds: 280);
  @override
  Duration get _closeDuration => const Duration(milliseconds: 160);
  @override
  Curve get _openCurve => Curves.easeOutBack;
  @override
  Curve get _barrierCurve => Curves.easeInOutBack;
  @override
  Widget _buildMenu(_MateoMenuSession session) => _MateoContextMenuPresentation._mounted(session);
  @override
  Widget _buildModalBarrier(_MateoMenuRoute route) => AnimatedModalBarrier(
    key: const Key('mateo_menu_button_barrier'),
    color: route.animation!.drive(
      ColorTween(begin: Colors.transparent, end: route.barrierColor).chain(CurveTween(curve: _barrierCurve)),
    ),
    dismissible: route.barrierDismissible,
    semanticsLabel: route.barrierLabel,
    barrierSemanticsDismissible: route.semanticsDismissible,
    onDismiss: () => route.navigator?.maybePop(),
  );
}

final class _MateoContextMenuPresentationState extends State<_MateoContextMenuPresentation> {
  final _focus = FocusNode(debugLabel: 'Mateo context menu');
  late final CurvedAnimation _progress;
  Widget? _panel;
  MateoMenuColorScheme? _colors;
  bool _ready = false;

  _MateoMenuSession get _session => widget._session!;

  @override
  void initState() {
    super.initState();
    _session.animation.addStatusListener(_animationChanged);
    _progress = CurvedAnimation(
      parent: _session.animation,
      curve: widget._openCurve,
      reverseCurve: _MateoContextMenuPresentation._closeCurve,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (_session.disableAnimations) _settle();
      _animationChanged(_session.animation.status);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final colors = _colors ??= context.mateo.colorScheme.menu.context;
    _panel ??= SizedBox(
      key: const Key('mateo_menu_button_panel_position'),
      child: Container(
        key: const ValueKey('mateo_menu_button_menu_surface'),
        child: RepaintBoundary(
          child: _MateoContextMenuContent(session: _session, colors: colors),
        ),
      ),
    );
  }

  void _settle() {
    if (!mounted || _ready || !_session.isCurrent()) return;
    setState(() => _ready = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _ready && _session.isCurrent()) _focus.requestFocus();
    });
  }

  void _animationChanged(AnimationStatus status) {
    if (!mounted) return;
    if (status == AnimationStatus.completed) _settle();
    if (status == AnimationStatus.reverse && _ready) setState(() => _ready = false);
  }

  KeyEventResult _handleKey(FocusNode _, KeyEvent event) {
    if (event is! KeyDownEvent || event.logicalKey != LogicalKeyboardKey.escape) return KeyEventResult.ignored;
    _session.onDismiss();
    return KeyEventResult.handled;
  }

  @override
  void dispose() {
    _session.animation.removeStatusListener(_animationChanged);
    _progress.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Focus(
    focusNode: _focus,
    canRequestFocus: _ready,
    descendantsAreFocusable: _ready,
    onKeyEvent: _handleKey,
    child: ExcludeSemantics(
      excluding: !_ready,
      child: Semantics(
        key: const Key('mateo_menu_button_overlay_semantics'),
        scopesRoute: true,
        explicitChildNodes: true,
        expanded: true,
        child: IgnorePointer(
          ignoring: !_ready,
          child: FadeTransition(
            opacity: _progress,
            child: AnimatedBuilder(
              animation: _session.triggerBounds,
              child: _panel,
              builder: (context, child) => _MateoContextMenuLayout(
                triggerBounds: _session.triggerBounds.value,
                mediaQuery: MediaQueryData.fromView(View.of(context), platformData: MediaQuery.of(context)),
                textDirection: _session.textDirection,
                child: _MateoContextMenuRevealTransition(
                  progress: _progress,
                  contentFadeStart: 0.20,
                  backgroundColor: _colors!.background,
                  radius: _MateoContextMenuPresentation._radius,
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
