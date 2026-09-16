import 'package:flutter/widgets.dart';

import '../../gen/icons.g.dart';
import '../../theme/mateo_theme.dart';
import 'mateo_icon_scope.dart';

part 'mateo_icon_data.dart';

/// A Mateo catalog icon with inherited size and monochrome color.
///
/// Use icons to support recognizable actions and information. Decorative icons
/// are hidden from assistive technology; use [semanticLabel] for meaningful
/// standalone images. Interactive components own their action labels and states.
///
/// ```dart
/// const MateoIconScope(
///   size: 24,
///   child: MateoIcon(.cross),
/// )
/// ```
///
/// See the [icon guidance](https://github.com/Ventairy/mateo/blob/main/design-system/foundation/icons.md)
/// for sizing, color, and accessibility.
class MateoIcon extends StatelessWidget {
  /// Creates a catalog icon with optional size, foreground, background, and label.
  const MateoIcon(
    this.icon, {
    super.key,
    this.size,
    this.color,
    this.backgroundColor,
    this.semanticLabel,
  }) : assert(size == null || (size >= 0 && size < double.infinity), 'size must be finite and nonnegative.');

  static const _defaultSize = 20.0;
  static const _backgroundArtworkScale = 0.6;

  /// The catalog artwork to display.
  final MateoIconData icon;

  /// The requested square size, including the background when present.
  ///
  /// Overrides the inherited size when supplied, otherwise uses [MateoIconScope]
  /// or the catalog's natural size. Parent constraints take precedence. Must be
  /// finite and nonnegative; zero renders empty.
  final double? size;

  /// The monochrome foreground color, overriding inherited colors when supplied.
  ///
  /// Otherwise follows [MateoIconScope], surrounding text, the Mateo primary
  /// text color, then the asset's authored color.
  final Color? color;

  /// The circular background color, or null to display the artwork alone.
  ///
  /// Adds proportional spacing inside [size]. Choose a [color] or inherited
  /// foreground that contrasts with this background.
  final Color? backgroundColor;

  /// The localized image label, or null for a decorative icon.
  final String? semanticLabel;

  /// Builds the constrained artwork with resolved defaults and image semantics.
  @override
  Widget build(BuildContext context) {
    final defaults = MateoIconScope.of(context);
    final background = backgroundColor;
    final resolvedColor =
        color ??
        defaults.color ??
        context.dependOnInheritedWidgetOfExactType<DefaultTextStyle>()?.style.color ??
        MateoTheme.maybeOf(context)?.colorScheme.text.primary;

    var artwork = icon._build(color: resolvedColor);
    if (background != null) {
      artwork = SizedBox.square(
        dimension: _defaultSize,
        child: DecoratedBox(
          decoration: BoxDecoration(color: background, shape: .circle),
          child: FractionallySizedBox(
            widthFactor: _backgroundArtworkScale,
            heightFactor: _backgroundArtworkScale,
            child: FittedBox(child: artwork),
          ),
        ),
      );
    }
    artwork = SizedBox.square(
      dimension: size ?? (background != null ? defaults.sizeWithBackground : null) ?? defaults.size ?? _defaultSize,
      child: FittedBox(child: artwork),
    );
    if (Directionality.maybeOf(context) == TextDirection.rtl) {
      artwork = Transform.flip(flipX: true, child: artwork);
    }

    return Semantics(
      label: semanticLabel,
      image: semanticLabel != null,
      excludeSemantics: true,
      child: artwork,
    );
  }
}
