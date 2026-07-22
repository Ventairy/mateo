import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mateo_mobile/src/theme/mateo_theme_context.dart';
import 'package:mateo_mobile/src/theme/mateo_typography.dart';

/// A Mateo Mobile loading indicator with shimmering text.
///
/// Displays a [CircularProgressIndicator] alongside a text label with a
/// shimmer sweep animation. Designed for loading states and in-progress
/// affordances.
///
/// ```dart
/// MateoLoadingText(
///   text: 'Carregando oportunidades...',
/// )
/// ```
class MateoLoadingText extends StatelessWidget {
  /// Creates a Mateo Mobile loading indicator.
  const MateoLoadingText({
    required this.text,
    super.key,
    this.progressIndicatorColor,
  });

  /// The text label shown next to the progress indicator.
  final String text;

  /// Color of the [CircularProgressIndicator].
  ///
  /// Defaults to Mateo's active primary step 9.
  final Color? progressIndicatorColor;

  @override
  Widget build(BuildContext context) {
    final indicatorColor =
        progressIndicatorColor ?? context.mateo.palette.primary[9];
    final disableAnimations = MediaQuery.disableAnimationsOf(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildIndicator(context, indicatorColor, disableAnimations),
        const SizedBox(width: 12),
        _buildText(context, disableAnimations),
      ],
    );
  }

  Widget _buildText(BuildContext context, bool disableAnimations) {
    final colorScheme = context.mateo.colorScheme;
    final textWidget = Text(
      text,
      style: TextStyle(
        fontFamily: MateoTypography.fontFamily,
        fontSize: 16.5,
        fontWeight: FontWeight.w500,
        letterSpacing: MateoTypography.letterSpacing,
        color: colorScheme.skeleton.skeletonText,
      ),
    );

    if (disableAnimations) return textWidget;

    return textWidget
        .animate(onPlay: (controller) => controller.repeat())
        .shimmer(
          duration: const Duration(milliseconds: 1500),
          color: colorScheme.skeleton.skeletonTextGlow,
          padding: 0,
        );
  }

  Widget _buildIndicator(
    BuildContext context,
    Color color,
    bool disableAnimations,
  ) {
    return SizedBox(
      height: 15,
      width: 15,
      child: CircularProgressIndicator(strokeWidth: 2, color: color),
    );
  }
}
