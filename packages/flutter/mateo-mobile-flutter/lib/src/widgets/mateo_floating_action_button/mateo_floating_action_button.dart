import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mateo_mobile/src/theme/mateo_theme_context.dart';
import 'package:mateo_mobile/src/widgets/mateo_action_bloom/mateo_action_bloom.dart';
import 'package:mateo_mobile/src/widgets/mateo_tap/mateo_tap.dart';

part 'mateo_floating_action_button_types.dart';

const _defaultFloatingActionButtonSize = 53.0;
const _defaultFloatingActionButtonIconSize = 22.0;
const _floatingActionButtonShadowBlur = 24.0;

/// A circular floating Mateo button for view-level actions.
///
/// The standard constructor performs one immediate action. The
/// [MateoFloatingActionButton.actionBloom] constructor instead transforms the
/// button into a modal panel containing several related actions.
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
class MateoFloatingActionButton extends StatelessWidget {
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
    this.iconSize = _defaultFloatingActionButtonIconSize,
  }) : _actionBloomActions = null,
       assert(
         size > 0 && size < double.infinity,
         'MateoFloatingActionButton size must be finite and greater than zero.',
       ),
       assert(
         iconSize > 0 && iconSize < double.infinity,
         'MateoFloatingActionButton iconSize must be finite and greater than '
         'zero.',
       );

  /// Creates a floating button that opens an action-bloom panel.
  ///
  /// The [actions] list must contain at least two actions. Use [semanticLabel]
  /// to describe the icon for assistive technologies.
  const MateoFloatingActionButton.actionBloom({
    required this.iconBuilder,
    required List<MateoActionBloomAction> actions,
    super.key,
    this.semanticLabel,
    this.backgroundColor,
    this.foregroundColor,
    this.borderSide,
    this.size = _defaultFloatingActionButtonSize,
    this.iconSize = _defaultFloatingActionButtonIconSize,
  }) : onPressed = null,
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
       );

  /// Builds the icon from the button's current presentation state.
  final MateoFloatingActionButtonIconBuilder iconBuilder;

  /// Called when the standard floating button is pressed.
  ///
  /// This value is null only for [MateoFloatingActionButton.actionBloom],
  /// whose press interaction opens the action panel.
  final VoidCallback? onPressed;

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

  /// The recommended icon size passed to [iconBuilder].
  final double iconSize;

  final List<MateoActionBloomAction>? _actionBloomActions;

  @override
  Widget build(BuildContext context) {
    final floatingColors = context.mateo.colorScheme.buttons.floating;
    final resolvedBackgroundColor =
        backgroundColor ?? floatingColors.background;
    final resolvedForegroundColor =
        foregroundColor ?? context.mateo.colorScheme.text.primary;
    final resolvedBorderSide =
        borderSide ?? BorderSide(color: floatingColors.border);
    final actionBloomActions = _actionBloomActions;

    Widget buildButton({
      required VoidCallback onPressed,
      String? semanticLabel,
    }) {
      return Semantics(
        key: const Key('mateo_floating_action_button_semantics'),
        button: true,
        enabled: true,
        label: semanticLabel,
        onTap: onPressed,
        child: ExcludeSemantics(
          child: DecoratedBox(
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
              child: MateoTap(
                onPressed: (animation) async => onPressed(),
                animation: MateoTapAnimationType.none,
                child: SizedBox.square(
                  key: const Key('mateo_floating_action_button_tap_target'),
                  dimension: size,
                  child: Center(
                    child: SizedBox.square(
                      key: const Key(
                        'mateo_floating_action_button_icon_box',
                      ),
                      dimension: iconSize,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: iconBuilder(
                          MateoFloatingActionButtonIconState(
                            foregroundColor: resolvedForegroundColor,
                            iconSize: iconSize,
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
        onPressed: onPressed!,
        semanticLabel: semanticLabel,
      );
    }

    return MateoActionBloomSurface(
      backgroundColor: resolvedBackgroundColor,
      borderRadius: BorderRadius.circular(size / 2),
      borderSide: resolvedBorderSide,
      builder: (context) => buildButton(
        onPressed: () => unawaited(
          MateoActionBloom.open(
            context: context,
            actions: actionBloomActions,
            actionIconForegroundColor: resolvedForegroundColor,
          ),
        ),
        semanticLabel: semanticLabel,
      ),
    );
  }
}
