import 'package:flutter/widgets.dart';

import '../../gen/logos.g.dart';
import 'mateo_logo_scope.dart';

part 'mateo_logo_data.dart';

/// A Mateo catalog logo in its authored brand colors.
///
/// Use logos to identify a company or service.
///
/// ```dart
/// const MateoLogo(.instagram, size: 24)
/// ```
final class MateoLogo extends StatelessWidget {
  /// Creates a catalog [logo] with optional [size] and [semanticLabel].
  const new(this.logo, {super.key, this.size, this.semanticLabel})
    : assert(size == null || (size >= 0 && size < double.infinity), 'size must be finite and nonnegative.');

  static const _defaultSize = 20.0;

  /// The brand artwork to display.
  final MateoLogoData logo;

  /// The requested square dimension in logical pixels.
  ///
  /// Overrides [MateoLogoScope] when supplied, otherwise uses its inherited
  /// size or the artwork's natural size. Parent constraints take precedence.
  /// Must be finite and nonnegative; zero renders empty.
  final double? size;

  /// The localized image label, or null for a decorative logo.
  ///
  /// Leave null when nearby text or a parent control identifies the brand.
  final String? semanticLabel;

  /// Builds the constrained brand artwork without recoloring or mirroring it.
  @override
  Widget build(BuildContext context) {
    final logoSize = size ?? MateoLogoScope.of(context).size ?? _defaultSize;
    if (logoSize == 0) return const SizedBox.shrink();

    return Semantics(
      label: semanticLabel,
      image: semanticLabel != null,
      excludeSemantics: true,
      child: SizedBox.square(
        dimension: logoSize,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final artworkSize = constraints.biggest.shortestSide;
            if (artworkSize == 0) return const SizedBox.shrink();
            // Supply the display size so embedded patterns decode at its density.
            return FittedBox(child: logo._buildSvg(size: artworkSize));
          },
        ),
      ),
    );
  }
}
