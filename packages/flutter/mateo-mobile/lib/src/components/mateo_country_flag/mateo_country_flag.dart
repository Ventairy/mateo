import 'package:flutter/widgets.dart';
import 'package:oh_my_flutter/oh_my_flutter.dart' show Country;

import '../../gen/flags.g.dart';

/// Displays a circular country flag using bundled artwork.
///
/// Use alongside a country name or in a control that identifies the country.
/// Provide [semanticLabel] when the flag conveys information on its own.
///
/// ```dart
/// const MateoCountryFlag(country: .brazil, size: 32);
/// ```
class MateoCountryFlag extends StatelessWidget {
  /// Creates a flag for [country] at the requested [size].
  const MateoCountryFlag({
    required this.country,
    required this.size,
    this.semanticLabel,
    super.key,
  }) : assert(size >= 0 && size < double.infinity, 'size must be finite and nonnegative.');

  /// The country or territory whose flag is displayed.
  final Country country;

  /// The requested square dimension in logical pixels.
  ///
  /// Must be finite and nonnegative. Zero renders empty; parent constraints
  /// can limit the rendered size.
  final double size;

  /// The localized image label, or null for a decorative flag.
  ///
  /// Leave null when surrounding text or a parent control identifies the country.
  final String? semanticLabel;

  /// Builds the flag without mirroring its artwork in right-to-left layouts.
  @override
  Widget build(BuildContext context) {
    if (size == 0) return const SizedBox.shrink();

    final flag = $Flags.findByName(
      '${country.iso3.toLowerCase()}.svg',
      width: size,
      height: size,
    );

    assert(flag != null, 'A bundled flag does not exist for ${country.iso3}.');

    return Semantics(
      label: semanticLabel,
      image: semanticLabel != null,
      excludeSemantics: true,
      child: ClipOval(
        child: SizedBox.square(dimension: size, child: flag),
      ),
    );
  }
}
