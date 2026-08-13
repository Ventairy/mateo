import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mateo_mobile/src/theme/mateo_theme_context.dart';
import 'package:mateo_mobile/src/widgets/mateo_action_bloom/mateo_action_bloom.dart';
import 'package:mateo_mobile/src/widgets/mateo_circular_loading_indicator/mateo_circular_loading_indicator.dart';
import 'package:mateo_mobile/src/widgets/mateo_tap/mateo_tap.dart';

part 'mateo_floating_action_button_types.dart';

const _defaultFloatingActionButtonSize = 53.0;
const _defaultFloatingActionButtonIconSize = 22.0;
const _floatingActionButtonShadowBlur = 24.0;
const _loadingIndicatorIconSizeOffset = 8.0;
const _loadingIndicatorButtonInset = 12.0;
const _loadingDelay = Duration(milliseconds: 50);
const _loadingIndicatorTrackOpacity = 0.24;
const _contentSwitchDuration = Duration(milliseconds: 350);
const _contentSwitchMinimumScale = 0.72;

/// A circular floating Mateo button for view-level actions.
///
/// The standard constructor performs one immediate action. The
/// [MateoFloatingActionButton.actionBloom] constructor instead transforms the
/// button into a modal panel containing several related actions.
///
/// When [onPressed] returns a [Future], the button replaces its icon with a
/// circular loading indicator while that future is pending. Synchronous callbacks remain immediate. Set [isLoading]
/// to `true` when loading is owned by external state instead.
///
/// ```dart
/// MateoFloatingActionButton(
///   semanticLabel: 'Go back',
///   onPressed: () => Navigator.of(context).pop(),
///   iconBuilder: (state) => MateoIcon.arrowLeft(
///     width: state.iconSize,
///     height: state.iconSize,
///     color: state.foregroundColor,
///   ),
/// )
/// ```
///
/// See also:
///  * [MateoFloatingActionButton.actionBloom], the multi-action presentation.
///  * [MateoActionBloomAction], an action displayed in the expanded panel.
class MateoFloatingActionButton extends StatefulWidget {
  /// Creates a floating button that performs one immediate action.
  ///
  /// The [semanticLabel] describes the icon for assistive technologies. The
  /// [size] and [iconSize] default to Mateo's standard floating-button
  /// dimensions.
  const MateoFloatingActionButton({
    required this.iconBuilder,
    required this.onPressed,
    required this.semanticLabel,
    super.key,
    this.backgroundColor,
    this.foregroundColor,
    this.borderSide,
    this.size = _defaultFloatingActionButtonSize,
    this.tapTargetSize,
    this.iconSize = _defaultFloatingActionButtonIconSize,
    this.isLoading = false,
  }) : _actionBloomActions = null,
       assert(
         size > 0 && size < double.infinity,
         'MateoFloatingActionButton size must be finite and greater than zero.',
       ),
       assert(
         iconSize > 0 && iconSize < double.infinity,
         'MateoFloatingActionButton iconSize must be finite and greater than '
         'zero.',
       ),
       assert(
         tapTargetSize == null ||
             (tapTargetSize >= size && tapTargetSize < double.infinity),
         'MateoFloatingActionButton tapTargetSize must be finite and greater '
         'than or equal to size.',
       );

  /// Creates a floating button that opens an action-bloom panel.
  ///
  /// The [actions] list must contain at least two actions. Use [semanticLabel]
  /// to describe the icon for assistive technologies. Use [tapTargetSize] to
  /// provide a larger interactive area without enlarging the visible circle.
  const MateoFloatingActionButton.actionBloom({
    required this.iconBuilder,
    required List<MateoActionBloomAction> actions,
    super.key,
    this.semanticLabel,
    this.backgroundColor,
    this.foregroundColor,
    this.borderSide,
    this.size = _defaultFloatingActionButtonSize,
    this.tapTargetSize,
    this.iconSize = _defaultFloatingActionButtonIconSize,
  }) : onPressed = null,
       isLoading = false,
       _actionBloomActions = actions,
       assert(
         actions.length >= 2,
         'MateoFloatingActionButton.actionBloom requires at least two actions.',
       ),
       assert(
         size > 0 && size < double.infinity,
         'MateoFloatingActionButton size must be finite and greater than zero.',
       ),
       assert(
         iconSize > 0 && iconSize < double.infinity,
         'MateoFloatingActionButton iconSize must be finite and greater than '
         'zero.',
       ),
       assert(
         tapTargetSize == null ||
             (tapTargetSize >= size && tapTargetSize < double.infinity),
         'MateoFloatingActionButton tapTargetSize must be finite and greater '
         'than or equal to size.',
       );

  /// Builds the icon from the button's current presentation state.
  final MateoFloatingActionButtonIconBuilder iconBuilder;

  /// Called when the standard floating button is pressed.
  ///
  /// If the callback returns a [Future], the icon is replaced by a circular
  /// loading indicator and restored when the future
  /// completes. A synchronous callback does not enter the loading state.
  ///
  /// When null, the standard button renders disabled and ignores pointer
  /// input.
  final FutureOr<void> Function()? onPressed;

  /// The optional accessibility label announced for the button.
  ///
  /// This value is required by the standard constructor and optional for
  /// [MateoFloatingActionButton.actionBloom].
  final String? semanticLabel;

  /// The optional background color of the floating button.
  ///
  /// Defaults to Mateo's semantic floating-button background. For
  /// [MateoFloatingActionButton.actionBloom], this color is also the starting
  /// surface color and the default background of action icons.
  final Color? backgroundColor;

  /// The optional foreground color of the floating button icon.
  ///
  /// Defaults to Mateo's semantic primary text color. For
  /// [MateoFloatingActionButton.actionBloom], this color is also recommended
  /// to action icon builders.
  final Color? foregroundColor;

  /// The optional border drawn around the floating button.
  ///
  /// Defaults to a one-pixel solid border using Mateo's semantic floating
  /// border color. For [MateoFloatingActionButton.actionBloom], the resolved
  /// side fades with the expanding source surface.
  final BorderSide? borderSide;

  /// The diameter of the circular floating button.
  final double size;

  /// The optional diameter of the button's interactive touch target.
  ///
  /// When omitted, the touch target matches [size]. When supplied, it must be
  /// at least as large as [size]. The visible circular button remains centered
  /// within this area.
  final double? tapTargetSize;

  /// The recommended icon size passed to [iconBuilder].
  final double iconSize;

  /// Whether the button shows its loading indicator.
  ///
  /// While `true`, the button ignores pointer input. This state can overlap
  /// with a pending [onPressed] future without restoring the icon until both
  /// loading sources have finished.
  final bool isLoading;

  final List<MateoActionBloomAction>? _actionBloomActions;

  @override
  State<MateoFloatingActionButton> createState() =>
      _MateoFloatingActionButtonState();
}

class _MateoFloatingActionButtonState extends State<MateoFloatingActionButton> {
  bool _isPendingPress = false;
  bool _showFutureLoadingIndicator = false;
  int _loadingGeneration = 0;

  Future<void> _handlePressed(FutureOr<void> Function() onPressed) async {
    final result = onPressed();

    if (result is! Future<void> || !mounted) return;

    final generation = _loadingGeneration + 1;
    _loadingGeneration = generation;
    setState(() => _isPendingPress = true);

    unawaited(_showLoadingIndicatorAfterDelay(generation));

    try {
      await result;
    } finally {
      if (mounted && _loadingGeneration == generation) {
        setState(() {
          _isPendingPress = false;
          _showFutureLoadingIndicator = false;
        });
      }
    }
  }

  Future<void> _showLoadingIndicatorAfterDelay(int generation) async {
    await Future<void>.delayed(_loadingDelay);

    if (!mounted ||
        _loadingGeneration != generation ||
        !_isPendingPress ||
        _showFutureLoadingIndicator) {
      return;
    }

    setState(() => _showFutureLoadingIndicator = true);
  }

  @override
  Widget build(BuildContext context) {
    final floatingColors = context.mateo.colorScheme.buttons.floating;
    final actionBloomActions = widget._actionBloomActions;
    final isEnabled = widget.onPressed != null || actionBloomActions != null;
    final resolvedBackgroundColor = isEnabled
        ? widget.backgroundColor ?? floatingColors.background
        : floatingColors.backgroundDisabled;
    final resolvedForegroundColor = isEnabled
        ? widget.foregroundColor ?? floatingColors.foreground
        : floatingColors.foregroundDisabled;
    final resolvedBorderSide =
        widget.borderSide ?? BorderSide(color: floatingColors.border);
    final resolvedTapTargetSize = widget.tapTargetSize ?? widget.size;
    final isLoading = widget.isLoading || _showFutureLoadingIndicator;

    Widget buildButton({
      required FutureOr<void> Function()? onPressed,
      String? semanticLabel,
    }) {
      final isInteractive =
          onPressed != null && !_isPendingPress && !widget.isLoading;

      return Semantics(
        key: const Key('mateo_floating_action_button_semantics'),
        button: true,
        enabled: isInteractive,
        label: semanticLabel,
        onTap: isInteractive
            ? () => unawaited(_handlePressed(onPressed))
            : null,
        child: ExcludeSemantics(
          child: MateoTap(
            onPressed: isInteractive
                ? (animation) => _handlePressed(onPressed)
                : null,
            animation: MateoTapAnimationType.none,
            child: SizedBox.square(
              key: const Key('mateo_floating_action_button_tap_target'),
              dimension: resolvedTapTargetSize,
              child: Center(
                child: DecoratedBox(
                  key: const Key('mateo_floating_action_button_visual'),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: floatingColors.shadow,
                        blurRadius: _floatingActionButtonShadowBlur,
                      ),
                    ],
                  ),
                  child: Material(
                    color: resolvedBackgroundColor,
                    shape: CircleBorder(side: resolvedBorderSide),
                    clipBehavior: Clip.antiAlias,
                    child: SizedBox.square(
                      dimension: widget.size,
                      child: Center(
                        child: _buildSwitchingContent(
                          context: context,
                          content: isLoading
                              ? MateoCircularLoadingIndicator(
                                  key: const Key(
                                    'mateo_floating_action_button_loading_indicator',
                                  ),
                                  size: math.max(
                                    0,
                                    math.min(
                                      widget.iconSize +
                                          _loadingIndicatorIconSizeOffset,
                                      widget.size -
                                          _loadingIndicatorButtonInset,
                                    ),
                                  ),
                                  color: resolvedForegroundColor,
                                  trackColor: resolvedForegroundColor
                                      .withValues(
                                        alpha: _loadingIndicatorTrackOpacity,
                                      ),
                                )
                              : SizedBox.square(
                                  key: const Key(
                                    'mateo_floating_action_button_icon_box',
                                  ),
                                  dimension: widget.iconSize,
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: widget.iconBuilder(
                                      MateoFloatingActionButtonIconState(
                                        foregroundColor:
                                            resolvedForegroundColor,
                                        iconSize: widget.iconSize,
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    if (actionBloomActions == null) {
      return buildButton(
        onPressed: widget.onPressed,
        semanticLabel: widget.semanticLabel,
      );
    }

    return MateoActionBloomSurface(
      backgroundColor: resolvedBackgroundColor,
      borderRadius: BorderRadius.circular(widget.size / 2),
      borderSide: resolvedBorderSide,
      builder: (context) => buildButton(
        onPressed: () => unawaited(
          MateoActionBloom.open(
            context: context,
            actions: actionBloomActions,
            actionIconForegroundColor: resolvedForegroundColor,
          ),
        ),
        semanticLabel: widget.semanticLabel,
      ),
    );
  }

  Widget _buildSwitchingContent({
    required BuildContext context,
    required Widget content,
  }) {
    if (MediaQuery.disableAnimationsOf(context)) return content;

    return AnimatedSwitcher(
      duration: _contentSwitchDuration,
      reverseDuration: _contentSwitchDuration,
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: Tween<double>(
            begin: _contentSwitchMinimumScale,
            end: 1,
          ).animate(animation),
          child: child,
        ),
      ),
      child: content,
    );
  }
}
