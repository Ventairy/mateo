part of '../../mateo_text_input.dart';

final class _MateoPhoneTextInputPresentation extends MateoTextInputPresentation {
  const _MateoPhoneTextInputPresentation({
    required this.initialCountry,
    this.size = .standard,
  }) : super._();

  final Country initialCountry;

  @override
  final MateoTextInputSize size;

  @override
  double get elevation => 0;

  @override
  MateoTextInputVariant get variant => MateoTextInputVariant.plain;

  @override
  State<_MateoPhoneTextInputPresentation> createState() => _MateoPhoneTextInputPresentationState();
}

class _MateoPhoneTextInputPresentationState extends State<_MateoPhoneTextInputPresentation> {
  late PhoneNumberTextInputFormatter _phoneNumberFormatter;
  late final TextInputFormatter _textInputFormatter;
  late PhoneNumberTextInputFormatterResult _latestFormattingResult;
  TextEditingController? _initializedController;

  static const _callingCodeTrailingPadding = 4.0;

  @override
  void initState() {
    super.initState();
    _phoneNumberFormatter = PhoneNumberTextInputFormatter(
      country: widget.initialCountry,
    );
    _textInputFormatter = TextInputFormatter.withFunction(
      _formatPhoneNumberEdit,
    );
  }

  @override
  void didUpdateWidget(_MateoPhoneTextInputPresentation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialCountry == widget.initialCountry) return;
    _phoneNumberFormatter = PhoneNumberTextInputFormatter(
      country: widget.initialCountry,
    );
    _initializedController = null;
  }

  void _initializeController(_MateoTextInputPresentationScope scope) {
    if (identical(_initializedController, scope.controller)) return;
    final result = _phoneNumberFormatter.formatEditUpdateWithResult(
      TextEditingValue.empty,
      scope.controller.value,
    );
    _applyFormattingResult(result);
    if (result.textEditingValue != scope.controller.value) {
      scope.controller.value = result.textEditingValue;
    }
    _initializedController = scope.controller;
  }

  TextEditingValue _formatPhoneNumberEdit(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final result = _phoneNumberFormatter.formatEditUpdateWithResult(
      oldValue,
      newValue,
    );
    _applyFormattingResult(result);
    return result.textEditingValue;
  }

  void _applyFormattingResult(PhoneNumberTextInputFormatterResult result) {
    _latestFormattingResult = result;
    if (_phoneNumberFormatter.country == result.country) return;
    _phoneNumberFormatter = PhoneNumberTextInputFormatter(
      country: result.country,
    );
  }

  void _handleChanged(_MateoTextInputPresentationScope scope) {
    setState(() {});
    scope.onChanged?.call(_latestFormattingResult.internationalValue);
  }

  void _handleCountryChanged(Country selectedCountry) {
    final scope = _MateoTextInputPresentationScope.of(context);
    _phoneNumberFormatter = PhoneNumberTextInputFormatter(
      country: selectedCountry,
    );
    final result = _phoneNumberFormatter.formatNationalValue(
      scope.controller.value,
    );
    _applyFormattingResult(result);
    scope.controller.value = result.textEditingValue;
    setState(() {});
    scope.onChanged?.call(result.internationalValue);
  }

  @override
  Widget build(BuildContext context) {
    final scope = _MateoTextInputPresentationScope.of(context);
    _initializeController(scope);
    final theme = MateoTheme.of(context);
    final plainColors = theme.colorScheme.textInputs.plain;
    final typography = widget.variant.resolveTypography(widget.size);
    final style = TextStyle(
      fontFamily: MateoTypography.fontFamily,
      letterSpacing: MateoTypography.letterSpacing,
      fontSize: typography.fontSize,
      height: typography.lineHeight / typography.fontSize,
      leadingDistribution: .even,
      fontWeight: .w500,
      color: scope.enabled ? plainColors.text : plainColors.textDisabled,
    );
    return Localizations.override(
      context: context,
      delegates: const [GlobalCupertinoLocalizations.delegate],
      child: Directionality(
        textDirection: .ltr,
        child: CupertinoTheme(
          data: CupertinoThemeData(
            brightness: .light,
            primaryColor: theme.colorScheme.accent,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: widget.size.height),
            child: Row(
              children: [
                _MateoPhoneTextInputCountrySelector(
                  country: _phoneNumberFormatter.country,
                  size: widget.size,
                  textStyle: style.copyWith(fontWeight: .w600),
                  onChanged: scope.enabled ? _handleCountryChanged : null,
                ),
                Expanded(
                  child: _MateoTextInputSelectionOverflow(
                    repaint: Listenable.merge([
                      scope.controller,
                      scope.focusNode,
                    ]),
                    child: CupertinoTextField(
                      controller: scope.controller,
                      focusNode: scope.focusNode,
                      autofocus: scope.autofocus && scope.enabled,
                      enabled: scope.enabled,
                      inputFormatters: [_textInputFormatter],
                      keyboardType: .phone,
                      textInputAction: .done,
                      textDirection: .ltr,
                      onChanged: (_) => _handleChanged(scope),
                      onSubmitted: scope.onSubmitted == null
                          ? null
                          : (_) => scope.onSubmitted!(
                              _latestFormattingResult.internationalValue,
                            ),
                      selectionControls: _MateoTextInputEditingControls.selectionControls,
                      contextMenuBuilder: _MateoTextInputEditingControls.buildContextMenu,
                      placeholder: scope.placeholder,
                      style: style,
                      placeholderStyle: style.copyWith(
                        color: scope.enabled ? plainColors.placeholder : plainColors.placeholderDisabled,
                        overflow: .visible,
                      ),
                      cursorColor: theme.colorScheme.accent,
                      decoration: const BoxDecoration(),
                      clipBehavior: .none,
                      padding: EdgeInsets.symmetric(
                        horizontal: _callingCodeTrailingPadding,
                        vertical: (widget.size.height - typography.lineHeight) / 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
