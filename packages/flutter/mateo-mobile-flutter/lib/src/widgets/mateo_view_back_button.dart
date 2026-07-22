import 'package:flutter/material.dart';
import 'package:mateo_mobile/src/icons/mateo_icons.dart';
import 'package:mateo_mobile/src/theme/mateo_theme_context.dart';

import 'mateo_tap/mateo_tap.dart';

/// A back button designed specifically for full-view surfaces
/// (screens that occupy the entire viewport).
///
/// Unlike a generic icon button, [MateoViewBackButton] is a purpose-built
/// component with a fixed tap target and an arrow icon.
///
///
/// {@tool snippet}
/// ```dart
/// MateoViewBackButton(
///   onPressed: () => Navigator.of(context).pop(),
/// )
/// ```
/// {@end-tool}
///
class MateoViewBackButton extends StatelessWidget {
  /// Creates a Mateo view back button.
  ///
  /// The [semanticLabel] defaults to `'Go back'`. Consumers should provide a
  /// localized label via their i18n system when the button is used in a
  /// non-English context.
  const MateoViewBackButton({
    required this.onPressed,
    super.key,
    this.semanticLabel = 'Go back',
  });

  /// Called when the button is pressed.
  ///
  /// Typically wired to `Navigator.of(context).pop()` or the equivalent
  /// router-level back action for the current surface.
  final VoidCallback onPressed;

  /// The accessibility label announced by screen readers.
  ///
  /// Defaults to `'Go back'`. Override with a localized string such as
  /// `'Voltar'` for Portuguese or `'Retour'` for French.
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    const shape = CircleBorder();

    return Semantics(
      key: const Key('mateo_view_back_button_semantics'),
      button: true,
      enabled: true,
      label: semanticLabel,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: context.mateo.colorScheme.buttons.floating.shadow,
              blurRadius: 24,
            ),
          ],
        ),
        child: Material(
          color: context.mateo.colorScheme.buttons.floating.background,
          shape: shape.copyWith(
            side: BorderSide(
              color: context.mateo.colorScheme.buttons.floating.border,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: MateoTap(
            onPressed: (animation) async => onPressed(),
            animation: MateoTapAnimationType.none,
            child: SizedBox.square(
              key: const Key('mateo_view_back_button_tap_target'),
              dimension: 53,
              child: Center(
                child: SizedBox.square(
                  key: const Key('mateo_view_back_button_icon_box'),
                  dimension: 22,
                  child: Center(
                    child: MateoIcon.arrowLeft(
                      height: 22,
                      width: 22,
                      color: context.mateo.colorScheme.text.primary,
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
}
