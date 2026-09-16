part of '../../mateo_select.dart';

@immutable
final class _MateoGhostSelectPresentation extends MateoSelectPresentation {
  const _MateoGhostSelectPresentation({this.colorScheme}) : super._();

  @override
  final MateoSelectVariantColorScheme? colorScheme;

  static const _borderRadius = BorderRadius.all(Radius.circular(36));
  static const _triggerVerticalPadding = 4.0;
  static const _triggerLeadingPadding = 10.0;
  static const _contentHorizontalPadding = 20.0;
  static const _iconSize = 22.0;
  static const _iconSlotSize = 40.0;
  static const _iconSpacing = 10.0;
  static const _chevronSize = 17.0;
  static const _chevronSpacing = 14.0;
  static const _optionSpacing = 32.0;
  static const _menuLeadingPadding = 24.0;
  static const _menuTrailingPadding = 8.0;
  static const _menuVerticalPadding = 28.0;
  static const _descriptionSpacing = 1.0;
  static const _horizontalSafeAreaGutter = 12.0;
  static const _menuHeightFraction = 0.85;
  static const _titleMaxLines = 1;
  static const _descriptionMaxLines = 2;
  static const _titleStyle = TextStyle(
    decoration: TextDecoration.none,
    fontFamily: MateoTypography.fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: MateoTypography.letterSpacing,
    height: 1.25,
  );
  static const _descriptionStyle = TextStyle(
    decoration: TextDecoration.none,
    fontFamily: MateoTypography.fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: MateoTypography.letterSpacing,
    height: 1.3,
  );
  static const _animationDuration = Duration(milliseconds: 200);
  static const Curve _openCurve = Curves.easeOutCubic;
  static const Curve _closeCurve = Interval(0, 0.8, curve: Curves.easeInCubic);
  static const Curve _optionsOpenCurve = Interval(0.15, 0.75, curve: Curves.easeOutCubic);
  static const Curve _optionsCloseCurve = Interval(0.45, 1, curve: Curves.easeInCubic);
  static const Curve _descriptionCurve = Interval(0.65, 1, curve: Curves.easeOutCubic);
  static const Curve _chevronCurve = Interval(0, 0.3, curve: Curves.easeOutCubic);
  static const MateoTapAnimationType _optionPressAnimation = MateoTapAnimationType.scaleFade;
  static const MateoTapAnimationType _sourcePressAnimation = MateoTapAnimationType.none;

  MateoSelectVariantColorScheme _resolveColors(MateoSelectColorScheme scheme) => colorScheme ?? scheme.ghost;

  @override
  State<_MateoGhostSelectPresentation> createState() => _MateoGhostSelectPresentationState();
}

final class _MateoGhostSelectPresentationState extends State<_MateoGhostSelectPresentation>
    with SingleTickerProviderStateMixin {
  final _menuController = MenuController();
  final _triggerFocus = FocusNode(debugLabel: 'MateoSelect ghost source');
  final _menuFocus = FocusNode(debugLabel: 'MateoSelect ghost menu');
  final GlobalKey _triggerKey = GlobalKey();
  final GlobalKey _menuKey = GlobalKey();
  final List<(Object?, GlobalKey)> _optionKeys = [];

  late final AnimationController _animation;
  late final CurvedAnimation _movement;
  late final CurvedAnimation _optionsOpacity;
  late _MateoSelectOwner _owner;
  bool _hasOwner = false;
  Object? _movingValue;
  List<MateoSelectOption<dynamic>> _menuOptions = const [];
  LocalHistoryEntry? _historyEntry;
  Completer<void>? _menuClosed;
  Completer<void>? _closeOperation;
  ({MateoSelectOption<dynamic> option, Future<void> feedback})? _pendingSelection;
  ({Rect triggerRect, Offset optionOffset})? _transitionOrigin;

  bool get _hasMenu => _menuClosed != null;
  bool get _isClosing => _closeOperation != null;
  bool get _reduceMotion => MediaQuery.disableAnimationsOf(context);

  @override
  void initState() {
    super.initState();
    _animation = AnimationController(
      duration: _MateoGhostSelectPresentation._animationDuration,
      vsync: this,
    );
    _movement = CurvedAnimation(
      parent: _animation,
      curve: _MateoGhostSelectPresentation._openCurve,
      reverseCurve: _MateoGhostSelectPresentation._closeCurve,
    );
    _optionsOpacity = CurvedAnimation(
      parent: _animation,
      curve: _MateoGhostSelectPresentation._optionsOpenCurve,
      reverseCurve: _MateoGhostSelectPresentation._optionsCloseCurve,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final owner = _MateoSelectScope.ownerOf(context);
    if (!_hasOwner || !identical(_owner, owner)) {
      _owner = owner;
      _hasOwner = true;
    }
    if (!_isClosing) {
      _movingValue = _owner.selectedValue;
      if (_hasMenu) _menuOptions = _owner.presentationOptions;
    }
    if (_hasMenu && _reduceMotion) {
      _animation.value = _isClosing ? 0 : 1;
      _stopWaitingForFeedback();
    }
  }

  @override
  void dispose() {
    _stopWaitingForFeedback();
    _menuClosed?.complete();
    _menuClosed = null;
    _historyEntry?.remove();
    _movement.dispose();
    _optionsOpacity.dispose();
    _animation.dispose();
    _triggerFocus.dispose();
    _menuFocus.dispose();
    super.dispose();
  }

  void _addBackHandler() {
    final route = ModalRoute.of(context);
    if (route == null) throw FlutterError('MateoSelect requires a ModalRoute ancestor.');
    _historyEntry = LocalHistoryEntry(
      impliesAppBarDismissal: false,
      onRemove: () {
        _historyEntry = null;
        if (_hasMenu && !_isClosing) _menuController.close();
      },
    );
    route.addLocalHistoryEntry(_historyEntry!);
  }

  Future<void> _open(Future<void> _) {
    if (_hasMenu) return Future<void>.value();
    _addBackHandler();
    setState(() {
      _menuClosed = Completer<void>();
      _menuOptions = _owner.presentationOptions;
      _movingValue = _owner.selectedValue;
    });
    _animation.value = _reduceMotion ? 1 : 0;
    _menuController.open();
    return Future<void>.value();
  }

  void _showMenu(Offset? _, VoidCallback showOverlay) {
    showOverlay();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_hasMenu || _isClosing) return;
      _menuFocus.requestFocus();
      final measured = _measureOrigin();
      setState(() {});
      if (_reduceMotion || !measured) {
        _animation.value = 1;
      } else {
        _animation.forward(from: 0);
      }
    });
  }

  void _dismiss() {
    if (!_hasMenu || _isClosing) return;
    _historyEntry?.remove();
  }

  void _select(MateoSelectOption<dynamic> option, Future<void> feedback) {
    if (_isClosing) return;
    _pendingSelection = (option: option, feedback: feedback);
    _dismiss();
  }

  void _reopen() {
    if (!_isClosing) return;
    _addBackHandler();
    _stopWaitingForFeedback();
    setState(() {
      _closeOperation = null;
      _menuOptions = _owner.presentationOptions;
      _movingValue = _owner.selectedValue;
    });
    _menuFocus.requestFocus();
    if (_reduceMotion) {
      _animation.value = 1;
    } else {
      _animation.forward();
    }
  }

  void _stopWaitingForFeedback() {
    final operation = _closeOperation;
    if (operation != null && !operation.isCompleted) operation.complete();
  }

  bool _stillClosing(Completer<void> operation) => mounted && _closeOperation == operation;

  Future<void> _closeMenu(VoidCallback hideOverlay) async {
    if (!_hasMenu || _isClosing) return;
    final operation = Completer<void>();
    final selection = _pendingSelection;
    final closed = _menuClosed!;
    final changesValue = selection != null && selection.option.value != _owner.selectedValue;
    final notifySelection = selection == null ? null : _owner.commitSelection(selection.option);
    _pendingSelection = null;
    _triggerFocus.requestFocus();
    setState(() {
      _closeOperation = operation;
      _movingValue = _owner.selectedValue;
    });

    void notify() => notifySelection?.call(closed.future);

    // A new label can resize and recenter the trigger. Measure after its layout,
    // before the consumer can rebuild or remove the selected option.
    if (changesValue && !_reduceMotion && _animation.value > 0) {
      await WidgetsBinding.instance.endOfFrame;
      if (!_stillClosing(operation)) {
        notify();
        return;
      }
    }
    final measured = _measureOrigin();
    setState(() {});
    final motion = _reduceMotion || !measured ? null : _animation.reverse().orCancel;
    if (motion == null) _animation.value = 0;
    notify();

    try {
      if (motion != null) await motion;
    } on TickerCanceled {
      // Reopening or disposal cancels this close. Reduced motion may instead
      // finish the same close by snapping the controller to zero.
      if (!_stillClosing(operation) || !_reduceMotion) return;
    }
    if (!_stillClosing(operation)) return;
    if (!_reduceMotion && selection != null) await Future.any([selection.feedback, operation.future]);
    if (!_stillClosing(operation)) return;
    if (!_reduceMotion) await WidgetsBinding.instance.endOfFrame;
    if (!_stillClosing(operation)) return;

    hideOverlay();
    _historyEntry?.remove();
    setState(() {
      _menuClosed = null;
      _closeOperation = null;
      _menuOptions = const [];
      _transitionOrigin = null;
      _optionKeys.clear();
    });
    // Overlay removal is applied on the following frame. Awaiters see the
    // restored trigger and no menu subtree when their future completes.
    await WidgetsBinding.instance.endOfFrame;
    closed.complete();
  }

  GlobalKey _optionKey(Object? value) {
    final index = _optionKeys.indexWhere((entry) => entry.$1 == value);
    if (index >= 0) return _optionKeys[index].$2;
    final key = GlobalKey();
    _optionKeys.add((value, key));
    return key;
  }

  bool _measureOrigin() {
    final source = _triggerKey.currentContext?.findRenderObject();
    final menu = _menuKey.currentContext?.findRenderObject();
    final option = _optionKey(_movingValue).currentContext?.findRenderObject();
    if (source is! RenderBox || menu is! RenderBox || option is! RenderBox) {
      _transitionOrigin = (triggerRect: Rect.zero, optionOffset: Offset.zero);
      return false;
    }
    final index = _menuOptions.indexWhere((option) => option.value == _movingValue);
    final padding = _MateoGhostSelectOptions.optionPadding(index, _menuOptions.length).resolve(
      Directionality.of(context),
    );
    final sourceRect = source.localToGlobal(Offset.zero) & source.size;
    _transitionOrigin = (
      triggerRect: sourceRect.shift(-menu.localToGlobal(Offset.zero)),
      optionOffset: sourceRect.topLeft - option.localToGlobal(Offset(padding.left, padding.top)),
    );
    return true;
  }

  Widget _buildMenu(BuildContext context, RawMenuOverlayInfo info) {
    final colors = widget._resolveColors(context.mateo.colorScheme.select);
    return _MateoGhostSelectMenu(
      info: info,
      mediaQuery: MediaQueryData.fromView(View.of(context), platformData: MediaQuery.of(context)),
      focusNode: _menuFocus,
      isClosing: _isClosing,
      onDismiss: _dismiss,
      onReopen: _reopen,
      animation: _movement,
      child: Visibility(
        visible: _transitionOrigin != null,
        maintainState: true,
        maintainAnimation: true,
        maintainSize: true,
        child: KeyedSubtree(
          key: _menuKey,
          child: _MateoGhostSelectSurface(
            animation: _movement,
            triggerRect: _transitionOrigin?.triggerRect ?? Rect.zero,
            colorScheme: colors,
            menuColorScheme: context.mateo.colorScheme.menu.action,
            child: _MateoGhostSelectOptions(
              key: const Key('mateo_select_panel'),
              options: _menuOptions,
              selectedValue: _owner.selectedValue,
              movingValue: _movingValue,
              triggerOffset: _transitionOrigin?.optionOffset ?? Offset.zero,
              triggerSize: _transitionOrigin?.triggerRect.size ?? Size.zero,
              movement: _movement,
              optionsOpacity: _optionsOpacity,
              colorScheme: colors,
              menuColorScheme: context.mateo.colorScheme.menu.action,
              optionKeyFor: _optionKey,
              onPressed: _select,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _owner = _MateoSelectScope.ownerOf(context);
    _hasOwner = true;
    final colors = widget._resolveColors(context.mateo.colorScheme.select);
    return RawMenuAnchor(
      controller: _menuController,
      onOpenRequested: _showMenu,
      onCloseRequested: _closeMenu,
      overlayBuilder: _buildMenu,
      child: _MateoGhostSelectTrigger(
        option: _owner.selectedOption,
        colors: colors,
        focusNode: _triggerFocus,
        triggerKey: _triggerKey,
        isOpen: _hasMenu,
        isVisible: _transitionOrigin == null,
        onPressed: _open,
      ),
    );
  }
}
