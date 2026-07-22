/// Metadata embedded in a MapLibre GL Style JSON document.
///
/// These fields are informational and do not affect rendering. They follow
/// MapLibre GL's metadata convention, which allows arbitrary key-value pairs.
/// This DTO models the specific keys used by Mateo Mobile map styles.
///
/// The `mapbox:*` keys are inherited from the Mapbox Style Specification and
/// remain stable in MapLibre. The `mateo:*` key is specific to Mateo.
///
/// ## MapLibre JSON mapping
/// {@template mateo_metadata_json}
/// ```json
/// {
///   "mapbox:autocomposite": false,
///   "mapbox:type": "template",
///   "mateo:style": "light"
/// }
/// ```
/// {@endtemplate}
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'mateo_map_style_metadata.freezed.dart';
part 'mateo_map_style_metadata.g.dart';

@Freezed(toJson: true, fromJson: false)
abstract class MateoMapLibreStyleMetadata with _$MateoMapLibreStyleMetadata {
  const factory MateoMapLibreStyleMetadata({
    /// Whether Mapbox GL can auto-composite raster tiles.
    ///
    /// Mapped to the `mapbox:autocomposite` JSON key. Set to `false` for
    /// vector tile sources where compositing is handled by the renderer.
    @JsonKey(name: 'mapbox:autocomposite') required bool mapboxAutocomposite,

    /// The style type identifier.
    ///
    /// Mapped to the `mapbox:type` JSON key. `"template"` indicates this is a
    /// base style designed to be extended or modified at consumption time.
    @JsonKey(name: 'mapbox:type') required String mapboxType,

    /// Mateo-specific style variant.
    ///
    /// Mapped to the `mateo:style` JSON key. Identifies the theme variant for
    /// debugging and asset auditing (e.g. `"light"`, `"dark"`).
    @JsonKey(name: 'mateo:style') required String mateoStyle,
  }) = _MateoMapLibreStyleMetadata;
}
