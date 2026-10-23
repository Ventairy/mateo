part of '../../mateo_text_input.dart';

final class _MateoGeneralTextInputPresentation extends MateoTextInputPresentation {
  const _MateoGeneralTextInputPresentation({
    required this.variant,
    this.size = .standard,
    this.purpose = .text,
  }) : assert(variant == MateoTextInputVariant.plain, 'Only plain is supported by general'),
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
  @override
  void didUpdateWidget(_MateoGeneralTextInputPresentation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.purpose == widget.purpose) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final scope = _MateoTextInputPresentationScope.of(context);
      if (!scope.enabled || !scope.focusNode.hasFocus) return;
      scope.focusNode.context?.findAncestorStateOfType<EditableTextState>()?.requestKeyboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.variant != MateoTextInputVariant.plain) {
      throw UnsupportedError('Only plain is supported by general');
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
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: widget.size.height),
            child: _MateoTextInputSelectionOverflow(
              repaint: Listenable.merge([scope.controller, scope.focusNode]),
              child: CupertinoTextField(
                // Flutter does not refresh same-keyboard typing settings in place.
                // A new editor applies those settings when the purpose changes.
                key: ValueKey(widget.purpose),
                controller: scope.controller,
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
                padding: EdgeInsetsDirectional.only(
                  end: widget.size.trailingPadding,
                  top: (widget.size.height - typography.lineHeight) / 2,
                  bottom: (widget.size.height - typography.lineHeight) / 2,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
