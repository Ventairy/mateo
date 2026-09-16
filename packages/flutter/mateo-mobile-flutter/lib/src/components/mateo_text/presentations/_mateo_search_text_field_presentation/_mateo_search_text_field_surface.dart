part of '../../mateo_text_field.dart';

class _MateoSearchTextFieldSurface extends StatefulWidget {
  const _MateoSearchTextFieldSurface({
    required this.owner,
    required this.presentation,
    required this.engagement,
    required this.placeholderReveal,
    required this.disableAnimations,
  });

  final _MateoTextFieldOwner owner;
  final _MateoSearchTextFieldPresentation presentation;
  final Animation<double> engagement;
  final Animation<double> placeholderReveal;
  final bool disableAnimations;

  @override
  State<_MateoSearchTextFieldSurface> createState() => _MateoSearchTextFieldSurfaceState();
}

class _MateoSearchTextFieldSurfaceState extends State<_MateoSearchTextFieldSurface> {
  static const _fadeSegmentCount = 32;

  static double _smoothFadeOpacity(double progress) {
    final progressSquared = progress * progress;
    final progressCubed = progressSquared * progress;
    return progressCubed * (progress * (progress * 6 - 15) + 10);
  }

  static LinearGradient _textFadeGradient(
    double width, {
    required double leadingFadeEnd,
    required Color background,
  }) {
    final availableWidth = math.max(width, 1);
    final fadeScale = math.min(
      1,
      availableWidth / (leadingFadeEnd + _MateoSearchTextFieldPresentation._trailingSpace),
    );
    final leadingStart = _MateoSearchTextFieldPresentation._leadingFadeStart * fadeScale / availableWidth;
    final leadingEnd = leadingFadeEnd * fadeScale / availableWidth;
    final trailingStart = 1 - (_MateoSearchTextFieldPresentation._trailingSpace * fadeScale / availableWidth);
    final leadingRange = leadingEnd - leadingStart;
    final trailingRange = 1 - trailingStart;

    return LinearGradient(
      begin: AlignmentDirectional.centerStart,
      end: AlignmentDirectional.centerEnd,
      colors: [
        for (var index = 0; index <= _fadeSegmentCount; index++)
          background.withValues(alpha: _smoothFadeOpacity(index / _fadeSegmentCount)),
        background,
        for (final opacity in _MateoSearchTextFieldPresentation._trailingFadeOpacities)
          background.withValues(alpha: opacity),
      ],
      stops: [
        for (var index = 0; index <= _fadeSegmentCount; index++)
          leadingStart + (leadingRange * (index / _fadeSegmentCount)),
        trailingStart,
        for (final stop in _MateoSearchTextFieldPresentation._trailingFadeStops) trailingStart + (trailingRange * stop),
        1,
      ],
    );
  }

  final GlobalKey _selectionPainterKey = GlobalKey();
  final ScrollController _textScrollController = ScrollController();

  MateoTextField get _input => widget.owner.input;
  MateoTextController get _textController => widget.owner.textController;
  _MateoSearchTextFieldPresentation get _presentation => widget.presentation;
  bool get _hasText => widget.owner.hasText;
  bool get _hasFocus => widget.owner.hasFocus;

  @override
  void dispose() {
    _textScrollController.dispose();
    super.dispose();
  }

  double get _leadingFadeEnd {
    if (!_textScrollController.hasClients) return _MateoSearchTextFieldPresentation._textStart;
    final position = _textScrollController.position;
    final distance = switch (position.axisDirection) {
      AxisDirection.right || AxisDirection.down => position.extentBefore,
      AxisDirection.left || AxisDirection.up => position.extentAfter,
    };
    return _MateoSearchTextFieldPresentation._textStart +
        distance.clamp(0, _MateoSearchTextFieldPresentation._leadingFadeExtension);
  }

  @override
  Widget build(BuildContext context) {
    final colors = switch (_presentation.variant) {
      MateoTextFieldVariant.floating => context.mateo.colorScheme.textField.floating,
      MateoTextFieldVariant.filled => context.mateo.colorScheme.textField.filled,
    };
    final shadows = switch (_presentation.variant) {
      MateoTextFieldVariant.floating => MateoElevation.toShadows(elevation: 1, palette: context.mateo.palette),
      MateoTextFieldVariant.filled => const <BoxShadow>[],
    };
    final isEnabled = _input.onChanged != null;
    final background = isEnabled ? colors.background : colors.backgroundDisabled;
    final textStyle = _MateoSearchTextFieldPresentation._textStyle.copyWith(
      color: isEnabled ? colors.text : colors.textDisabled,
    );
    final placeholderStyle = _MateoSearchTextFieldPresentation._textStyle.copyWith(
      color: isEnabled ? colors.placeholderResting : colors.placeholderDisabled,
    );
    final textHeight = _measureTextHeight('Mateo', textStyle);
    final height = math.max(
      _MateoSearchTextFieldPresentation._minimumHeight,
      math.max(textHeight, _measureTextHeight(_input.placeholder, placeholderStyle)) +
          _MateoSearchTextFieldPresentation._verticalSpace,
    );

    return Column(
      key: const ValueKey('mateo_text_field_search'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DecoratedBox(
          key: const ValueKey('mateo_text_field_search_surface'),
          decoration: BoxDecoration(
            borderRadius: _MateoSearchTextFieldPresentation._borderRadius,
            boxShadow: shadows,
          ),
          child: Material(
            color: background,
            shape: const RoundedRectangleBorder(borderRadius: _MateoSearchTextFieldPresentation._borderRadius),
            clipBehavior: Clip.antiAlias,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: _MateoSearchTextFieldPresentation._minimumHeight),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  _buildEditor(colors, textStyle, placeholderStyle, (height - textHeight) / 2),
                  PositionedDirectional(
                    start: 0,
                    end: 0,
                    top: 0,
                    height: height,
                    child: _buildPrompt(colors, placeholderStyle),
                  ),
                  PositionedDirectional(end: 0, top: 0, child: _buildClearButton(colors, background)),
                ],
              ),
            ),
          ),
        ),
        if (_input.maxLength case final limit? when _hasText) _buildCounter(limit),
      ],
    );
  }

  Widget _buildEditor(
    MateoTextFieldVariantColorScheme colors,
    TextStyle textStyle,
    TextStyle placeholderStyle,
    double verticalPadding,
  ) {
    final background = _input.onChanged != null ? colors.background : colors.backgroundDisabled;
    return Semantics(
      readOnly: _input.editable ? null : true,
      child: AnimatedBuilder(
        animation: _textScrollController,
        builder: (context, child) => ShaderMask(
          key: const ValueKey('mateo_text_field_search_fade_mask'),
          blendMode: BlendMode.dstIn,
          shaderCallback: (bounds) => _textFadeGradient(
            bounds.width,
            leadingFadeEnd: _leadingFadeEnd,
            background: background,
          ).createShader(bounds, textDirection: Directionality.of(context)),
          child: child,
        ),
        child: KeyedSubtree(
          key: const ValueKey('mateo_text_field_search_selection_painter'),
          child: CustomPaint(
            key: _selectionPainterKey,
            painter: _MateoSearchTextSelectionPainter(
              textController: _textController,
              paintRootKey: _selectionPainterKey,
              color: colors.selectionHighlight,
            ),
            child: TextField(
              controller: _textController,
              focusNode: _textController.focusNode,
              autofocus: _input.autofocus,
              enabled: _input.onChanged != null,
              keyboardType: _input.keyboardType,
              textInputAction: _input.textInputAction ?? TextInputAction.search,
              autofillHints: _input.autofillHints,
              inputFormatters: [if (!_input.editable) TextInputFormatter.withFunction((oldValue, _) => oldValue)],
              maxLength: _input.maxLength,
              maxLengthEnforcement: MaxLengthEnforcement.none,
              buildCounter: _input.maxLength == null
                  ? null
                  : (_, {required currentLength, required isFocused, required maxLength}) => null,
              maxLines: 1,
              scrollController: _textScrollController,
              scrollPhysics: const ClampingScrollPhysics(),
              scrollPadding: _input.scrollPadding,
              clipBehavior: Clip.none,
              cursorColor: colors.caret,
              showCursor: _hasFocus,
              style: textStyle,
              decoration: _MateoSearchTextFieldPresentation._inputDecoration.copyWith(
                contentPadding: EdgeInsetsDirectional.fromSTEB(
                  _MateoSearchTextFieldPresentation._textStart,
                  verticalPadding,
                  _MateoSearchTextFieldPresentation._trailingSpace,
                  verticalPadding,
                ),
                hintText: _input.placeholder,
                hintStyle: placeholderStyle.copyWith(color: colors.placeholderResting.withValues(alpha: 0)),
              ),
              onChanged: _input.onChanged,
              onSubmitted: _input.onSubmitted,
              onTapOutside: (_) {
                if (_input.unfocusOnTapOutside) _textController.unfocus();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPrompt(MateoTextFieldVariantColorScheme colors, TextStyle placeholderStyle) => AnimatedBuilder(
    animation: widget.engagement,
    builder: (context, child) => Padding(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: _MateoSearchTextFieldPresentation._horizontalInset,
      ),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IgnorePointer(
              child: MateoIcon.magnifierGlass(
                key: const ValueKey('mateo_text_field_search_icon'),
                width: _MateoSearchTextFieldPresentation._leadingIconSize,
                height: _MateoSearchTextFieldPresentation._leadingIconSize,
                color: Color.lerp(
                  colors.iconResting,
                  _input.onChanged != null ? colors.iconFocused : colors.iconDisabled,
                  widget.engagement.value,
                ),
              ),
            ),
            if (!_hasText) ...[
              const SizedBox(width: _MateoSearchTextFieldPresentation._iconTextGap),
              Flexible(
                child: IgnorePointer(
                  child: ExcludeSemantics(
                    child: FadeTransition(
                      key: const ValueKey('mateo_text_field_search_placeholder_reveal'),
                      opacity: widget.placeholderReveal,
                      child: ScaleTransition(
                        scale: Tween<double>(
                          begin: _MateoSearchTextFieldPresentation._placeholderRevealScale,
                          end: 1,
                        ).animate(widget.placeholderReveal),
                        alignment: AlignmentDirectional.centerStart.resolve(Directionality.of(context)),
                        child: Text(
                          _input.placeholder,
                          key: const ValueKey('mateo_text_field_search_placeholder'),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: placeholderStyle,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    ),
  );

  Widget _buildClearButton(MateoTextFieldVariantColorScheme colors, Color background) => SizedBox.square(
    dimension: _MateoSearchTextFieldPresentation._minimumHeight,
    child: AnimatedSwitcher(
      duration: widget.disableAnimations ? Duration.zero : _MateoSearchTextFieldPresentation._clearButtonDuration,
      reverseDuration: Duration.zero,
      switchInCurve: _MateoSearchTextFieldPresentation._enterCurve,
      switchOutCurve: _MateoSearchTextFieldPresentation._enterCurve,
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: Tween<double>(begin: _MateoSearchTextFieldPresentation._clearButtonScale, end: 1).animate(animation),
          child: child,
        ),
      ),
      child: _input.onChanged != null && _input.editable && _hasText
          ? TextFieldTapRegion(
              key: const ValueKey('mateo_text_field_search_clear_tap_region'),
              child: MateoButton(
                key: const ValueKey('mateo_text_field_search_clear'),
                onPressed: widget.owner.clear,
                presentation: MateoButtonPresentation.icon(
                  variant: MateoButtonVariant.primary.base,
                  elevation: 1,
                  semanticLabel: MaterialLocalizations.of(context).clearButtonTooltip,
                  buttonSize: _MateoSearchTextFieldPresentation._clearButtonSize,
                  hitAreaSize: _MateoSearchTextFieldPresentation._minimumHeight,
                  iconSize: _MateoSearchTextFieldPresentation._clearIconSize,
                  iconBuilder: (state) =>
                      MateoIcon.broom(width: state.iconSize, height: state.iconSize, color: state.foregroundColor),
                  colorScheme: context.mateo.colorScheme.buttons.primary.base.copyWith(
                    background: background,
                    foreground: colors.text,
                  ),
                ),
              ),
            )
          : const SizedBox.shrink(key: ValueKey('mateo_text_field_search_clear_hidden')),
    ),
  );

  Widget _buildCounter(int limit) => Padding(
    padding: const EdgeInsetsDirectional.only(top: _MateoSearchTextFieldPresentation._counterGap),
    child: Align(
      alignment: AlignmentDirectional.centerStart,
      child: MateoCharacterCounter(
        key: const ValueKey('mateo_text_field_search_counter'),
        textController: _textController,
        limit: limit,
        variant: MateoCharacterCounterVariant.floating,
      ),
    ),
  );

  double _measureTextHeight(String text, TextStyle style) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textScaler: MediaQuery.textScalerOf(context),
      textDirection: Directionality.of(context),
    )..layout();
    final height = painter.height;
    painter.dispose();
    return height;
  }
}
