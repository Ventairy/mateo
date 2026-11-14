part of '../../mateo_text_input.dart';

final class _MateoHandleTextInputPresentation extends MateoTextInputPresentation {
  const new({this.size = .standard}) : super._();

  @override
  final MateoTextInputSize size;

  @override
  MateoTextInputVariant get variant => .plain;

  @override
  double get elevation => 0;

  @override
  State<_MateoHandleTextInputPresentation> createState() => _MateoHandleTextInputPresentationState();
}

class _MateoHandleTextInputPresentationState extends State<_MateoHandleTextInputPresentation> {
  static const _iconTextGap = 4.0;

  void _focusEditor() {
    final scope = _MateoTextInputPresentationScope.of(context);
    scope.focusNode.requestFocus();
    scope.focusNode.context?.findAncestorStateOfType<EditableTextState>()?.requestKeyboard();
  }

  @override
  Widget build(BuildContext context) {
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
        textDirection: .ltr,
        child: CupertinoTheme(
          data: CupertinoThemeData(brightness: .light, primaryColor: theme.colorScheme.accent),
          child: Row(
            children: [
              TextFieldTapRegion(
                child: GestureDetector(
                  behavior: .opaque,
                  excludeFromSemantics: true,
                  onTap: scope.enabled ? _focusEditor : null,
                  child: Padding(
                    padding: const EdgeInsets.only(right: _iconTextGap),
                    child: ExcludeSemantics(
                      child: MateoIcon(
                        .at,
                        size: widget.size.leadingIconSize,
                        color: scope.enabled ? colors.icon : colors.iconDisabled,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: _MateoTextInputSelectionOverflow(
                  repaint: Listenable.merge([scope.controller, scope.focusNode]),
                  child: CupertinoTextField(
                    controller: scope.controller,
                    focusNode: scope.focusNode,
                    autofocus: scope.autofocus && scope.enabled,
                    enabled: scope.enabled,
                    textDirection: .ltr,
                    keyboardType: .text,
                    textInputAction: .done,
                    textCapitalization: .none,
                    autocorrect: false,
                    enableSuggestions: false,
                    enableInlinePrediction: false,
                    smartDashesType: .disabled,
                    smartQuotesType: .disabled,
                    inputFormatters: const [HandleTextInputFormatter()],
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
                    scrollPhysics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
