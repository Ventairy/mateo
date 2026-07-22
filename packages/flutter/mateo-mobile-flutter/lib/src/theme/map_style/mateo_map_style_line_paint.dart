/// Paint properties for a MapLibre GL line layer.
///
/// Models the line layer paint properties. Line layers render stroked paths
/// from vector tile data (roads, boundaries, waterway centerlines).
///
/// ## MapLibre JSON mapping
/// {@template mateo_line_paint_json}
/// ```json
/// {
///   "line-color": "#ffffff",
///   "line-width": { "stops": [[11, 0.15], [14, 0.45], [16, 1.4]] },
///   "line-opacity": 0.95
/// }
/// ```
/// {@endtemplate}
library;

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mateo_mobile/src/theme/map_style/mateo_map_style_converters.dart';
import 'package:mateo_mobile/src/theme/map_style/mateo_map_style_value.dart';

part 'mateo_map_style_line_paint.freezed.dart';
part 'mateo_map_style_line_paint.g.dart';

@Freezed(toJson: true, fromJson: false)
abstract class MateoMapLibreStyleLinePaint with _$MateoMapLibreStyleLinePaint {
  const factory MateoMapLibreStyleLinePaint({
    /// The line color as a hex string (e.g. `"#ffffff"`).
    ///
    /// Mapped to the `line-color` JSON key.
    @JsonKey(name: 'line-color') required String lineColor,

    /// The line width, which may be a constant scalar or a zoom-dependent stop
    /// function.
    ///
    /// Mapped to the `line-width` JSON key. Uses [MateoMapLibreStyleValueConverter]
    /// to serialize as either a raw number or a stops object.
    /// See [MateoMapLibreStyleValue] for value representations.
    @JsonKey(name: 'line-width')
    @MateoMapLibreStyleValueConverter()
    required MateoMapLibreStyleValue lineWidth,

    /// The line opacity from 0 (transparent) to 1 (opaque).
    ///
    /// Mapped to the `line-opacity` JSON key.
    @JsonKey(name: 'line-opacity') required double lineOpacity,
  }) = _MateoMapLibreStyleLinePaint;
}
