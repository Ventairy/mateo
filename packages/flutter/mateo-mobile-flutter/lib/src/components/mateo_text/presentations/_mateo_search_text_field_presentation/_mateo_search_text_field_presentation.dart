part of '../../mateo_text_field.dart';

@immutable
final class _MateoSearchTextFieldPresentation extends MateoTextFieldPresentation {
  const _MateoSearchTextFieldPresentation({required this.variant}) : super._();

  @override
  final MateoTextFieldVariant variant;

  static const _textStyle = TextStyle(
    fontFamily: MateoTypography.fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.25,
    letterSpacing: MateoTypography.letterSpacing,
  );
  static const _verticalSpace = 24.0;
  static const _placeholderRevealDuration = Duration(milliseconds: 400);
  static const _placeholderRevealScale = 0.95;
  static const _clearButtonScale = 0.8;
  static const Curve _enterCurve = Curves.easeOutCubic;
  static const Curve _exitCurve = Curves.easeInCubic;
  static const _engagementDuration = Duration(milliseconds: 320);
  static const _minimumHeight = 55.0;
  static const _borderRadius = BorderRadius.all(Radius.circular(34));
  static const _horizontalInset = 18.0;
  static const _leadingIconSize = 18.0;
  static const _iconTextGap = 12.0;
  static const double _textStart = _horizontalInset + _leadingIconSize + _iconTextGap;
  static const double _leadingFadeStart = _horizontalInset + _leadingIconSize;
  static const _leadingFadeExtension = 12.0;
  static const _trailingSpace = 60.0;
  static const _clearButtonSize = 34.0;
  static const _clearIconSize = 14.0;
  static const _clearButtonDuration = Duration(milliseconds: 180);
  static const _counterGap = 8.0;
  static const _trailingFadeOpacities = [0.90, 0.50, 0.10, 0.0];
  static const _trailingFadeStops = [0.25, 0.5, 0.75];
  static const _inputDecoration = InputDecoration(
    border: InputBorder.none,
    enabledBorder: InputBorder.none,
    focusedBorder: InputBorder.none,
    disabledBorder: InputBorder.none,
    errorBorder: InputBorder.none,
    focusedErrorBorder: InputBorder.none,
    filled: false,
    isDense: true,
  );

  @override
  State<_MateoSearchTextFieldPresentation> createState() => _MateoSearchTextFieldPresentationState();
}

final class _MateoSearchTextFieldPresentationState extends State<_MateoSearchTextFieldPresentation>
    with TickerProviderStateMixin {
  late final AnimationController _engagementController;
  late final CurvedAnimation _engagement;
  late final AnimationController _placeholderRevealController;
  late final CurvedAnimation _placeholderReveal;
  MateoTextController? _textController;
  bool _initialized = false;
  bool _hasText = false;
  bool _hasFocus = false;
  bool _disableAnimations = false;

  @override
  void initState() {
    super.initState();
    _engagementController = AnimationController(
      vsync: this,
      duration: _MateoSearchTextFieldPresentation._engagementDuration,
    );
    _engagement = CurvedAnimation(
      parent: _engagementController,
      curve: _MateoSearchTextFieldPresentation._enterCurve,
      reverseCurve: _MateoSearchTextFieldPresentation._exitCurve,
    );
    _placeholderRevealController = AnimationController(
      vsync: this,
      duration: _MateoSearchTextFieldPresentation._placeholderRevealDuration,
      value: 1,
    );
    _placeholderReveal = CurvedAnimation(
      parent: _placeholderRevealController,
      curve: _MateoSearchTextFieldPresentation._enterCurve,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final owner = _MateoTextFieldScope.ownerOf(context);
    final controllerChanged = !identical(_textController, owner.textController);
    final hasText = owner.hasText;
    final hasFocus = owner.hasFocus;
    final disableAnimations = MediaQuery.disableAnimationsOf(context);

    if (!_initialized || controllerChanged) {
      _initialized = true;
      _textController = owner.textController;
      _hasText = hasText;
      _hasFocus = hasFocus;
      _disableAnimations = disableAnimations;
      _engagementController.value = hasText || hasFocus ? 1 : 0;
      _placeholderRevealController.value = 1;
      return;
    }

    final wasCleared = _hasText && !hasText;
    final engagementChanged = (_hasText || _hasFocus) != (hasText || hasFocus);
    _hasText = hasText;
    _hasFocus = hasFocus;
    _disableAnimations = disableAnimations;

    if (disableAnimations) {
      _engagementController.value = hasText || hasFocus ? 1 : 0;
      _placeholderRevealController.value = 1;
      return;
    }
    if (engagementChanged) {
      if (hasText || hasFocus) {
        _engagementController.forward();
      } else {
        _engagementController.reverse();
      }
    }
    if (wasCleared) {
      _placeholderRevealController.forward(from: 0);
    } else if (hasText) {
      _placeholderRevealController.value = 1;
    }
  }

  @override
  void dispose() {
    _engagement.dispose();
    _engagementController.dispose();
    _placeholderReveal.dispose();
    _placeholderRevealController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _MateoSearchTextFieldSurface(
    owner: _MateoTextFieldScope.ownerOf(context),
    presentation: widget,
    engagement: _engagement,
    placeholderReveal: _placeholderReveal,
    disableAnimations: _disableAnimations,
  );
}
