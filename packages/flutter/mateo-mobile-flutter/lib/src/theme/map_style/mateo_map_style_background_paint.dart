library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'mateo_map_style_background_paint.freezed.dart';
part 'mateo_map_style_background_paint.g.dart';

/// Paint properties for a MapLibre GL background layer.
///
/// Models the background layer paint properties. The background layer fills
/// the entire map canvas before any other layers are rendered.
///
/// ## MapLibre JSON mapping
/// {@template mateo_background_paint_json}
/// ```json
/// {
///   "background-color": "#ebedef"
/// }
/// ```
/// {@endtemplate}
@Freezed(toJson: true, fromJson: false)
abstract class MateoMapLibreStyleBackgroundPaint
    with _$MateoMapLibreStyleBackgroundPaint {
  const factory MateoMapLibreStyleBackgroundPaint({
    /// The background fill color as a hex string (e.g. `"#ebedef"`).
    ///
    /// Mapped to the `background-color` JSON key. Accepts any CSS-compatible
    /// hex color. Transparency can be set independently on the fill.
    @JsonKey(name: 'background-color') required String backgroundColor,
  }) = _MateoMapLibreStyleBackgroundPaint;
}
