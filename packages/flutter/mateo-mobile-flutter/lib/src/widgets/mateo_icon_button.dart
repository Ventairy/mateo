import 'package:flutter/material.dart';
import 'package:mateo_mobile/src/theme/mateo_theme_context.dart';
import 'package:mateo_mobile/src/theme/mateo_typography.dart';
import 'package:mateo_mobile/src/widgets/mateo_tap/mateo_tap.dart';
import 'package:oh_my_flutter/oh_my_flutter.dart';

part 'mateo_icon_button_types.dart';

/// A circular Mateo icon button with an optional bottom label.
class MateoIconButton extends StatelessWidget {
  /// Creates a circular Mateo icon button.
  const MateoIconButton({
    required this.iconBuilder,
    super.key,
    this.onPressed,
    this.label,
    this.labelStyle,
    this.backgroundColor,
    this.disabledBackgroundColor,
    this.buttonSize = 55,
    this.iconSize = 27,
  });

  /// Builds the icon from the current button state.
  final MateoIconButtonIconBuilder iconBuilder;

  /// Called when the button is pressed.
  ///
  /// When null, the button renders disabled and ignores pointer input.
  final VoidCallback? onPressed;

  /// Optional label rendered below the circular icon button.
  final String? label;

  /// Optional style merged on top of the default label style.
  final TextStyle? labelStyle;

  /// Enabled circle background color.
  ///
  /// Defaults to Mateo's active primary step 9.
  final Color? backgroundColor;

  /// Disabled circle background color.
  ///
  /// Defaults to `context.mateo.colors.disabledButtonBackground`.
  final Color? disabledBackgroundColor;

  /// Diameter of the circular button.
  final double buttonSize;

  /// Recommended icon size passed to [iconBuilder].
  final double iconSize;

  bool get _isEnabled => onPressed != null;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.mateo.colorScheme;
    final isEnabled = _isEnabled;
    final resolvedLabel = label;
    final resolvedBackgroundColor = isEnabled
        ? backgroundColor ?? context.mateo.palette.primary[9]
        : disabledBackgroundColor ??
              colorScheme.buttons.primary.backgroundDisabled;
    final recommendedIconColor = isEnabled
        ? Colors.white
        : resolvedBackgroundColor.darken(0.28);
    final iconState = MateoIconButtonIconState(
      isEnabled: isEnabled,
      recommendedIconColor: recommendedIconColor,
      iconSize: iconSize,
    );

    final button = Semantics(
      key: const Key('mateo_icon_button_semantics'),
      button: true,
      enabled: isEnabled,
      label: resolvedLabel,
      onTap: isEnabled ? onPressed : null,
      child: MateoTap(
        onPressed: onPressed != null
            ? (animation) async {
                onPressed!();
              }
            : null,
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
                child: iconBuilder(iconState),
              ),
            ),
          ),
        ),
      ),
    );

    if (resolvedLabel == null) return button;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        button,
        const SizedBox(height: 6),
        Text(
          resolvedLabel,
          style: const TextStyle(
            fontFamily: MateoTypography.fontFamily,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: MateoTypography.letterSpacing,
            height: 1.33,
          ).copyWith(color: colorScheme.text.primary).merge(labelStyle),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
