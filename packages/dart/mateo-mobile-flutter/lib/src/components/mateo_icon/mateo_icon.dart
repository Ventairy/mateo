import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../gen/icons.g.dart';
import '../../gen/three_d_icons.g.dart';
import '../../theme/mateo_theme.dart';
import '../mateo_text/mateo_text.dart';
import 'mateo_icon_scope.dart';
import 'mateo_icon_style.dart';
import 'three_d_icon_cache/three_d_icon_metadata_native.dart';
import 'three_d_icon_cache/three_d_icon_usage.dart';

part 'mateo_icon_data.dart';
part 'three_d_icon_cache/mateo_three_d_icon_cache_host.dart';
part 'three_d_icon_cache/mateo_three_d_icon_cache_scope.dart';
part 'three_d_icon_cache/mateo_three_d_icon_image_cache.dart';

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
@RecordUse()
final class MateoIcon extends StatelessWidget {
  /// Creates a catalog icon with optional size, foreground, background, and label.
  const MateoIcon(
    this.icon, {
    super.key,
    this.style = .svg,
    this.size,
    this.color,
    this.backgroundColor,
    this.semanticLabel,
  }) : assert(size == null || (size >= 0 && size < double.infinity), 'size must be finite and nonnegative.');

  static const _defaultSize = 20.0;

  /// The catalog artwork to display.
  final MateoIconData icon;

  /// The visual treatment. Icons without the style throw when built
  final MateoIconStyle style;

  /// The requested square size, including the background when present.
  ///
  /// Overrides the inherited size when supplied, otherwise uses [MateoIconScope]
  /// or the catalog's natural size. Parent constraints take precedence. Must be
  /// finite and nonnegative; zero renders empty.
  final double? size;

  /// The SVG foreground color, overriding inherited colors when supplied.
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

  ({double icon, double artwork}) _resolvedSizes(BuildContext context) {
    var iconSize = size;
    if (iconSize == null) {
      final defaults = MateoIconScope.of(context);
      iconSize = (backgroundColor != null ? defaults.sizeWithBackground : null) ?? defaults.size ?? _defaultSize;
    }
    return (
      icon: iconSize,
      artwork: backgroundColor == null ? iconSize : iconSize * ThreeDIconUsage.backgroundArtworkScale,
    );
  }

  /// Builds the constrained artwork with resolved defaults and image semantics.
  @override
  Widget build(BuildContext context) {
    final resolvedSizes = _resolvedSizes(context);
    if (resolvedSizes.icon == 0) return const SizedBox.shrink();
    final background = backgroundColor;
    var artwork = switch (style) {
      .svg => icon._buildSvg(
        color:
            color ??
            MateoIconScope.of(context).color ??
            MateoTextScope.of(context).color ??
            MateoTheme.maybeOf(context)?.colorScheme.text.primary,
      ),
      .threeD => icon._buildThreeD(size: resolvedSizes.artwork, imageCache: MateoThreeDIconCacheHost.cacheOf(context)),
    };
    if (background != null) {
      artwork = SizedBox.square(
        dimension: _defaultSize,
        child: DecoratedBox(
          decoration: BoxDecoration(color: background, shape: .circle),
          child: FractionallySizedBox(
            widthFactor: ThreeDIconUsage.backgroundArtworkScale,
            heightFactor: ThreeDIconUsage.backgroundArtworkScale,
            child: FittedBox(child: artwork),
          ),
        ),
      );
    }
    artwork = SizedBox.square(
      dimension: resolvedSizes.icon,
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
