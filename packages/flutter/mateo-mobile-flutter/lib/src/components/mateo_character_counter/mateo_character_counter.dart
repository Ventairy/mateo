library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mateo_mobile_old/src/foundation/mateo_elevation.dart';
import 'package:mateo_mobile_old/src/foundation/mateo_text_controller.dart';
import 'package:mateo_mobile_old/src/theme/mateo_color_scheme/mateo_color_scheme.dart';
import 'package:mateo_mobile_old/src/theme/mateo_theme_context.dart';
import 'package:mateo_mobile_old/src/theme/mateo_typography.dart';
import 'package:oh_my_flutter/oh_my_flutter.dart';

part 'mateo_character_counter_variant.dart';

/// A character counter that follows a [MateoTextController].
///
/// The counter derives its displayed length from [textController], enforces
/// [limit], and animates feedback when an edit exceeds that limit. [padding]
/// and [fontSize] override the geometry owned by [variant] when a composition
/// needs a different footprint. The counter owns its limit enforcement, so the
/// observed field does not need a separate length-limiting formatter.
///
/// ```dart
/// final controller = MateoTextController();
///
/// MateoCharacterCounter(
///   textController: controller,
///   limit: 50,
///   variant: MateoCharacterCounterVariant.floating,
/// )
/// ```
class MateoCharacterCounter extends StatefulWidget {
  /// Creates a character counter that observes [textController].
  const MateoCharacterCounter({
    required this.textController,
    required this.limit,
    required this.variant,
    this.padding,
    this.fontSize,
    super.key,
  }) : assert(limit > 0, 'limit must be greater than zero.');

  /// Controller whose text and limit-feedback events drive this counter.
  final MateoTextController textController;

  /// Maximum number of characters represented by this counter.
  final int limit;

  /// Visual treatment applied to this counter.
  final MateoCharacterCounterVariant variant;

  /// Optional padding that replaces the selected variant's default padding.
  final EdgeInsetsGeometry? padding;

  /// Optional font size that replaces the selected variant's default size.
  final double? fontSize;

  @override
  State<MateoCharacterCounter> createState() => _MateoCharacterCounterState();
}

class _MateoCharacterCounterState extends State<MateoCharacterCounter> {
  static const _feedbackDuration = Duration(milliseconds: 1700);
  static const _styleTransitionDuration = Duration(milliseconds: 150);

  final MotionController _motionController = MotionController();
  Timer? _feedbackTimer;
  late final ShakeMotionEffect _shakeEffect;
  late TextEditingValue _acceptedValue;
  bool _isCorrectingController = false;
  bool _isLimitFeedbackActive = false;

  void _completeLimitFeedback() {
    if (!_isLimitFeedbackActive || !mounted) return;
    setState(() => _isLimitFeedbackActive = false);
  }

  void _showLimitFeedback() {
    _feedbackTimer?.cancel();
    if (!_isLimitFeedbackActive) setState(() => _isLimitFeedbackActive = true);

    if (MediaQuery.disableAnimationsOf(context)) {
      _feedbackTimer = Timer(_feedbackDuration, _completeLimitFeedback);
      return;
    }

    _motionController.play();
  }

  bool _synchronizeController({required bool showFeedback}) {
    final value = widget.textController.value;
    if (value.text.characters.length <= widget.limit) {
      _acceptedValue = value;
      return false;
    }
    if (value.composing.isValid) return false;

    final correctedValue = LengthLimitingTextInputFormatter(
      widget.limit,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
    ).formatEditUpdate(_acceptedValue, value);
    _isCorrectingController = true;
    try {
      widget.textController.value = correctedValue;
    } finally {
      _isCorrectingController = false;
    }
    _acceptedValue = widget.textController.value;
    if (showFeedback) _showLimitFeedback();
    return showFeedback;
  }

  void _handleControllerChanged() {
    if (_isCorrectingController) return;
    if (_synchronizeController(showFeedback: true)) return;

    if (mounted) setState(() {});
  }

  void _startListening() {
    _acceptedValue = widget.textController.value;
    widget.textController.addListener(_handleControllerChanged);
    _synchronizeController(showFeedback: false);
  }

  void _stopListening() {
    widget.textController.removeListener(_handleControllerChanged);
  }

  void _resetFeedback() {
    _feedbackTimer?.cancel();
    _isLimitFeedbackActive = false;
  }

  @override
  void initState() {
    super.initState();
    _shakeEffect = ShakeMotionEffect(
      offset: const Offset(2, 0),
      count: 4,
      damping: 1,
      duration: _feedbackDuration,
      curve: Curves.easeOutBack,
      onEnd: _completeLimitFeedback,
    );
    _startListening();
  }

  @override
  void didUpdateWidget(covariant MateoCharacterCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.textController != widget.textController) {
      _resetFeedback();
      oldWidget.textController.removeListener(_handleControllerChanged);
      _startListening();
      return;
    }
    if (oldWidget.limit != widget.limit) {
      _resetFeedback();
      _synchronizeController(showFeedback: false);
    }
  }

  @override
  void dispose() {
    _stopListening();
    _feedbackTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = widget.variant._colors(context.mateo.colorScheme.characterCounter);
    final transitionDuration = MediaQuery.disableAnimationsOf(context) ? Duration.zero : _styleTransitionDuration;
    final textStyle = TextStyle(
      color: _isLimitFeedbackActive ? colors.foregroundReject : colors.foreground,
      fontFamily: MateoTypography.fontFamily,
      fontSize: widget.fontSize ?? 12,
      fontWeight: FontWeight.w500,
      height: 1.25,
      letterSpacing: MateoTypography.letterSpacing,
      fontFeatures: const [FontFeature.tabularFigures()],
    );
    final currentLength = widget.textController.text.characters.length;
    final digitPainter = TextPainter(
      text: TextSpan(text: '0', style: textStyle),
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
    )..layout();
    final currentValueWidth = digitPainter.width * '$currentLength'.length;

    return Semantics(
      liveRegion: _isLimitFeedbackActive,
      label: _isLimitFeedbackActive
          ? 'Character limit reached: $currentLength of ${widget.limit}.'
          : '$currentLength of ${widget.limit} characters.',
      child: ExcludeSemantics(
        child: Motion(
          key: const ValueKey('mateo_character_counter_motion'),
          controller: _motionController,
          startup: MotionStartup.hold,
          effect: _shakeEffect,
          child: DecoratedBox(
            key: const ValueKey('mateo_character_counter'),
            decoration: BoxDecoration(
              color: colors.background,
              borderRadius: const BorderRadius.all(Radius.circular(999)),
              boxShadow: widget.variant == MateoCharacterCounterVariant.floating
                  ? MateoElevation.toShadows(elevation: 1, palette: context.mateo.palette)
                  : null,
            ),
            child: Padding(
              padding: widget.padding ?? widget.variant._defaultPadding,
              child: AnimatedDefaultTextStyle(
                key: const ValueKey('mateo_character_counter_text'),
                duration: transitionDuration,
                curve: Curves.easeOut,
                style: textStyle,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    TweenAnimationBuilder<double>(
                      key: const ValueKey('mateo_character_counter_value_slot'),
                      tween: Tween(end: currentValueWidth),
                      duration: transitionDuration,
                      curve: Curves.easeOutCubic,
                      builder: (context, width, child) => Align(
                        alignment: AlignmentDirectional.centerEnd,
                        widthFactor: width / currentValueWidth,
                        child: child,
                      ),
                      child: Text(
                        '$currentLength',
                        key: const ValueKey('mateo_character_counter_value'),
                        maxLines: 1,
                        softWrap: false,
                      ),
                    ),
                    Text('/${widget.limit}', key: const ValueKey('mateo_character_counter_suffix')),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
