import 'package:flutter/material.dart';
import 'package:mateo_mobile/src/theme/mateo_theme_context.dart';
import 'package:mateo_mobile/src/widgets/mateo_button/mateo_button.dart';

/// A floating surface that groups Mateo buttons into a vertical stack.
///
/// The panel preserves each button's sizing behavior, centers the buttons
/// horizontally, and separates adjacent buttons with consistent spacing.
/// Provide at least one button.
///
/// See the
/// [Button Panel design specification](https://github.com/Ventairy/mateo/blob/main/design-system/mobile/components/button-panel.md)
/// for usage and behavior guidance.
///
/// ```dart
/// MateoButtonPanel(
///   buttons: [
///     MateoButton(
///       label: 'Continue',
///       variant: MateoButtonVariant.primary,
///       onPressed: () {},
///     ),
///   ],
/// )
/// ```
class MateoButtonPanel extends StatelessWidget {
  /// Creates a floating panel containing [buttons].
  const MateoButtonPanel({
    required this.buttons,
    super.key,
  }) : assert(
         buttons.length > 0,
         'MateoButtonPanel requires at least one button.',
       );

  /// Buttons displayed from top to bottom in the panel.
  final List<MateoButton> buttons;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.mateo.colorScheme.buttonPanel;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.background,
        border: Border.all(
          color: colorScheme.border,
          width: 1,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(36)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow,
            blurRadius: 41,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            for (var index = 0; index < buttons.length; index++) ...[
              if (index > 0) const SizedBox(height: 8),

              buttons[index],
            ],
          ],
        ),
      ),
    );
  }
}
