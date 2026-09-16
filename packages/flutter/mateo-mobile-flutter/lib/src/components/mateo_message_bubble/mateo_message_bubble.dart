import 'dart:math' as math;

import 'package:flutter/foundation.dart' show precisionErrorTolerance;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mateo_mobile_old/src/components/mateo_dots_loading_indicator/mateo_dots_loading_indicator.dart';
import 'package:mateo_mobile_old/src/theme/mateo_theme_context.dart';
import 'package:mateo_mobile_old/src/theme/mateo_typography.dart';

part '_mateo_message_bubble_shape.dart';
part '_mateo_message_bubble_surface.dart';

/// The direction represented by a Mateo message bubble.
enum MateoMessageDirection {
  /// A message received from another person or participant.
  incoming,

  /// A message sent by the current person or participant.
  outgoing,
}

/// A rounded surface that presents one message widget or typing state.
///
/// The bubble sizes itself to [message] within the constraints supplied by its
/// parent. Its [direction] selects the semantic surface and foreground colors;
/// it also places the bubble's sculpted tail on the lower-left for incoming
/// messages and lower-right for outgoing messages. Alignment, conversation
/// grouping, and sender identity remain the responsibility of the surrounding
/// message layout. Use [constraints] to add minimum or maximum dimensions when
/// that layout does not already supply suitable constraints.
///
/// A [Text] message inherits Mateo's message typography and foreground color.
/// Other widgets may use that inherited styling or provide their own. When
/// [isTyping] is true, the message is replaced by a compact typing indicator
/// and may be null. Changes between the typing and message states morph the
/// bubble's width and height from its bottom-left corner while crossfading the
/// complete content. If the message or constraints change again during that
/// motion, the surface retargets from its currently visible size instead of
/// jumping to the new dimensions.
///
/// ```dart
/// const MateoMessageBubble(
///   message: Text('I can help with that 👋'),
///   direction: MateoMessageDirection.incoming,
/// )
/// ```
class MateoMessageBubble extends StatefulWidget {
  /// Creates a Mateo message bubble for a [message] widget or typing state.
  const MateoMessageBubble({
    required this.direction,
    super.key,
    this.message,
    this.constraints,
    this.isTyping = false,
    this.typingSemanticsLabel,
  });

  /// Message content displayed when [isTyping] is false.
  ///
  /// This value may be null while [isTyping] is true. Otherwise it must be a
  /// non-null widget. Descendant [Text] and [Icon] widgets inherit the bubble's
  /// foreground styling unless they provide their own.
  final Widget? message;

  /// Semantic message direction that selects the bubble colors.
  final MateoMessageDirection direction;

  /// Additional constraints for the complete bubble and its sculpted tail.
  ///
  /// When null, the bubble uses only the constraints supplied by its parent.
  /// Otherwise these constraints are enforced within the parent's constraints,
  /// so a tighter parent still wins. Loose constraints preserve natural
  /// shrink-wrapping, while minimum or tight dimensions may expand the bubble.
  final BoxConstraints? constraints;

  /// Whether the bubble presents an in-progress typing state.
  ///
  /// When true, [message] is hidden and a [MateoDotsLoadingIndicator] is shown.
  /// Changing this value morphs the surface and crossfades its complete
  /// content unless animations are disabled.
  final bool isTyping;

  /// Optional localized accessibility label for the typing state.
  ///
  /// The typing state retains a platform loading-spinner role when this value
  /// is omitted.
  final String? typingSemanticsLabel;

  /// The mutable state that coordinates typing and message motion.
  @override
  State<MateoMessageBubble> createState() => _MateoMessageBubbleState();
}

class _MateoMessageBubbleState extends State<MateoMessageBubble> with SingleTickerProviderStateMixin {
  static const _transitionDuration = Duration(milliseconds: 300);

  AnimationController? _transitionController;
  Widget? _previousMessage;
  bool _showPreviousContent = false;
  bool _animationsDisabled = false;
  int _transitionGeneration = 0;
  double? _scaledFontSize;
  late final _MateoMessageBubbleTransitionValues _transitionValues;

  @override
  void initState() {
    super.initState();
    _transitionValues = _MateoMessageBubbleTransitionValues(
      targetIsTyping: widget.isTyping,
    );
  }

  AnimationController _ensureTransitionController() {
    return _transitionController ??= AnimationController(
      vsync: this,
      duration: _transitionDuration,
      value: 1,
    )..addStatusListener(_handleTransitionStatus);
  }

  void _handleTransitionStatus(AnimationStatus status) {
    if (status != AnimationStatus.completed || !_showPreviousContent || !mounted) {
      return;
    }
    setState(() => _showPreviousContent = false);
  }

  @override
  void didUpdateWidget(MateoMessageBubble oldWidget) {
    super.didUpdateWidget(oldWidget);
    final typingChanged = oldWidget.isTyping != widget.isTyping;
    final geometryMayChange =
        typingChanged || oldWidget.message != widget.message || oldWidget.constraints != widget.constraints;
    if (geometryMayChange && !_animationsDisabled) {
      _ensureTransitionController();
    }
    if (!typingChanged) return;
    _previousMessage = oldWidget.message;
    _showPreviousContent = !_animationsDisabled;
    _transitionGeneration += 1;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final animationsDisabled = MediaQuery.disableAnimationsOf(context);
    final scaledFontSize = MediaQuery.textScalerOf(context).scale(16.5);
    if (_scaledFontSize != null && _scaledFontSize != scaledFontSize && !animationsDisabled) {
      _ensureTransitionController();
    }
    _scaledFontSize = scaledFontSize;
    _animationsDisabled = animationsDisabled;
    if (animationsDisabled) {
      _transitionController?.stop();
      _showPreviousContent = false;
    }
  }

  @override
  void dispose() {
    _transitionController
      ?..removeStatusListener(_handleTransitionStatus)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    assert(
      widget.isTyping || widget.message != null,
      'message must not be null when isTyping is false',
    );
    final colors = context.mateo.colorScheme.messageBubble;
    final variant = switch (widget.direction) {
      MateoMessageDirection.incoming => colors.incoming,
      MateoMessageDirection.outgoing => colors.outgoing,
    };
    final messageStyle = TextStyle(
      color: variant.onSolid,
      fontFamily: MateoTypography.fontFamily,
      fontSize: 16.5,
      fontWeight: FontWeight.w500,
      height: 1.25,
      letterSpacing: MateoTypography.letterSpacing,
    );
    final fadeEnabled = _showPreviousContent && !_animationsDisabled;
    final visibleMessage = widget.isTyping ? _previousMessage : widget.message;
    final useSurfaceMessageFade = variant.solid.a == 1 && visibleMessage is Text;
    Widget messageContent(Widget message) => _MateoMessageBubbleFadedContent(
      controller: _transitionController,
      transitionValues: _transitionValues,
      kind: _MateoMessageBubbleContentKind.message,
      enabled: fadeEnabled && !useSurfaceMessageFade,
      child: _MateoMessageBubbleCachedContent(
        enabled: fadeEnabled && useSurfaceMessageFade,
        child: IconTheme.merge(
          key: const ValueKey('mateo_message_bubble_message'),
          data: IconThemeData(color: variant.onSolid),
          child: DefaultTextStyle.merge(
            style: messageStyle,
            child: message,
          ),
        ),
      ),
    );
    Widget typingContent() => _MateoMessageBubbleFadedContent(
      controller: _transitionController,
      transitionValues: _transitionValues,
      kind: _MateoMessageBubbleContentKind.typing,
      enabled: fadeEnabled,
      child: MateoDotsLoadingIndicator(
        key: const ValueKey('mateo_message_bubble_typing'),
        color: colors.typingIndicator,
        dotRadius: 4,
      ),
    );
    final children = <Widget>[
      if (widget.isTyping)
        _MateoMessageBubbleContent(
          key: const ValueKey('mateo_message_bubble_typing_slot'),
          kind: _MateoMessageBubbleContentKind.typing,
          child: typingContent(),
        )
      else
        _MateoMessageBubbleContent(
          key: const ValueKey('mateo_message_bubble_message_slot'),
          kind: _MateoMessageBubbleContentKind.message,
          child: messageContent(widget.message!),
        ),
      if (_showPreviousContent && !_animationsDisabled && widget.isTyping)
        _MateoMessageBubbleContent(
          key: const ValueKey('mateo_message_bubble_message_slot'),
          kind: _MateoMessageBubbleContentKind.message,
          child: messageContent(_previousMessage!),
        ),
      if (_showPreviousContent && !_animationsDisabled && !widget.isTyping)
        _MateoMessageBubbleContent(
          key: const ValueKey('mateo_message_bubble_typing_slot'),
          kind: _MateoMessageBubbleContentKind.typing,
          child: typingContent(),
        ),
    ];

    final surface = _MateoMessageBubbleSurface(
      key: const ValueKey('mateo_message_bubble_surface'),
      controller: _animationsDisabled ? null : _transitionController,
      transitionValues: _transitionValues,
      transitionGeneration: _transitionGeneration,
      targetIsTyping: widget.isTyping,
      direction: widget.direction,
      backgroundColor: variant.solid,
      constraints: widget.constraints,
      useSurfaceMessageFade: useSurfaceMessageFade,
      children: children,
    );
    return Semantics(
      liveRegion: widget.isTyping,
      label: widget.isTyping ? widget.typingSemanticsLabel : null,
      role: widget.isTyping ? SemanticsRole.loadingSpinner : null,
      excludeSemantics: widget.isTyping,
      child: surface,
    );
  }
}
