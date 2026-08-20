import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mateo_mobile/src/theme/mateo_theme_context.dart';
import 'package:mateo_mobile/src/widgets/mateo_action_bloom/mateo_action_bloom.dart';
import 'package:mateo_mobile/src/widgets/mateo_tap/mateo_tap.dart';
import 'package:oh_my_flutter/oh_my_flutter.dart';

part 'mateo_icon_button_types.dart';

/// A circular Mateo icon button.
class MateoIconButton extends StatelessWidget {
  /// Creates a circular Mateo icon button.
  const MateoIconButton({
    required this.iconBuilder,
    super.key,
    this.onPressed,
    this.semanticLabel,
    this.backgroundColor,
    this.disabledBackgroundColor,
    this.buttonSize = 55,
    this.iconSize = 27,
  }) : _actionBloomActions = null,
       assert(
         buttonSize > 0 && buttonSize < double.infinity,
         'MateoIconButton buttonSize must be finite and greater than zero.',
       ),
       assert(
         iconSize > 0 && iconSize < double.infinity,
         'MateoIconButton iconSize must be finite and greater than zero.',
       );

  /// Creates a circular Mateo icon button that opens an action-bloom panel.
  ///
  /// The [actions] list must contain at least two actions.
  const MateoIconButton.actionBloom({
    required this.iconBuilder,
    required List<MateoActionBloomAction> actions,
    super.key,
    this.semanticLabel,
    this.backgroundColor,
    this.buttonSize = 55,
    this.iconSize = 27,
  }) : onPressed = null,
       disabledBackgroundColor = null,
       _actionBloomActions = actions,
       assert(
         actions.length >= 2,
         'MateoIconButton.actionBloom requires at least two actions.',
       ),
       assert(
         buttonSize > 0 && buttonSize < double.infinity,
         'MateoIconButton buttonSize must be finite and greater than zero.',
       ),
       assert(
         iconSize > 0 && iconSize < double.infinity,
         'MateoIconButton iconSize must be finite and greater than zero.',
       );

  /// Builds the icon from the current button state.
  final MateoIconButtonIconBuilder iconBuilder;

  /// Called when the button is pressed.
  ///
  /// When null, the button renders disabled and ignores pointer input.
  final VoidCallback? onPressed;

  /// The optional accessibility label announced for the button.
  final String? semanticLabel;

  /// Enabled circle background color.
  ///
  /// Defaults to Mateo's active accent step 9.
  final Color? backgroundColor;

  /// Disabled circle background color.
  ///
  /// Defaults to `context.mateo.colors.disabledButtonBackground`.
  final Color? disabledBackgroundColor;

  /// Diameter of the circular button.
  final double buttonSize;

  /// Recommended icon size passed to [iconBuilder].
  final double iconSize;

  final List<MateoActionBloomAction>? _actionBloomActions;

  bool get _isEnabled => onPressed != null || _actionBloomActions != null;

  @override
  Widget build(BuildContext context) {
    final isEnabled = _isEnabled;
    final resolvedBackgroundColor = isEnabled
        ? backgroundColor ?? context.mateo.palette.accent[9]
        : disabledBackgroundColor ?? context.mateo.colorScheme.buttons.accent.primary.backgroundDisabled;

    final recommendedIconColor = isEnabled ? Colors.white : resolvedBackgroundColor.darken(0.28);

    Widget buildButton({
      required VoidCallback? onPressed,
    }) {
      return Semantics(
        key: const Key('mateo_icon_button_semantics'),
        button: true,
        enabled: onPressed != null,
        label: semanticLabel,
        onTap: onPressed,
        child: MateoTap(
          animation: MateoTapAnimationType.scale,
          onPressed: onPressed != null ? (animation) async => onPressed() : null,
          child: Container(
            key: const Key('mateo_icon_button_circle'),
            width: buttonSize,
            height: buttonSize,
            decoration: BoxDecoration(
              color: resolvedBackgroundColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SizedBox.square(
                key: const Key('mateo_icon_button_icon_box'),
                dimension: iconSize,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: iconBuilder(
                    MateoIconButtonIconState(
                      isEnabled: isEnabled,
                      recommendedIconColor: recommendedIconColor,
                      iconSize: iconSize,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    if (_actionBloomActions == null) {
      return buildButton(
        onPressed: onPressed,
      );
    }

    return MateoActionBloomSurface(
      backgroundColor: resolvedBackgroundColor,
      borderRadius: BorderRadius.circular(buttonSize / 2),
      builder: (context) => buildButton(
        onPressed: () => unawaited(
          MateoActionBloom.open(
            context: context,
            actions: _actionBloomActions,
            actionIconForegroundColor: recommendedIconColor,
          ),
        ),
      ),
    );
  }
}
