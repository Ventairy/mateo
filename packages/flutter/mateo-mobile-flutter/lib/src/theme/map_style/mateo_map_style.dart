library;

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mateo_mobile/src/theme/map_style/mateo_map_style_background_paint.dart';
import 'package:mateo_mobile/src/theme/map_style/mateo_map_style_converters.dart';
import 'package:mateo_mobile/src/theme/map_style/mateo_map_style_fill_paint.dart';
import 'package:mateo_mobile/src/theme/map_style/mateo_map_style_filter.dart';
import 'package:mateo_mobile/src/theme/map_style/mateo_map_style_layer.dart';
import 'package:mateo_mobile/src/theme/map_style/mateo_map_style_line_paint.dart';
import 'package:mateo_mobile/src/theme/map_style/mateo_map_style_metadata.dart';
import 'package:mateo_mobile/src/theme/map_style/mateo_map_style_source.dart';
import 'package:mateo_mobile/src/theme/map_style/mateo_map_style_symbol_layout.dart';
import 'package:mateo_mobile/src/theme/map_style/mateo_map_style_symbol_paint.dart';
import 'package:mateo_mobile/src/theme/map_style/mateo_map_style_value.dart';
import 'package:mateo_mobile/src/theme/mateo_color_scheme/mateo_color_scheme.dart';
import 'package:oh_my_flutter/oh_my_flutter.dart';

part 'mateo_map_style.freezed.dart';
part 'mateo_map_style.g.dart';

const _openMapTilesSource = 'openmaptiles';
final MateoMapColorScheme _lightMapColorScheme = MateoColorScheme.light().map;

/// A typed representation of a MapLibre GL Style JSON document.
///
/// This is the root DTO for the full MapLibre style document. It models the
/// top-level fields of the [MapLibre Style Specification](https://maplibre.org/maplibre-style-spec/root/):
/// version, id, name, metadata, sources, and layers.
///
/// ## Usage
/// Build the available authored style via [MateoMapLibreStyle.light] and call
/// `toJson()` to produce the MapLibre-compatible JSON map. Pass the
/// serialized JSON string directly to `maplibre_gl`'s `styleString`:
///
/// ```dart
/// final style = MateoMapLibreStyle.light(
///   tileUrlTemplate: 'https://tiles.example.com/{z}/{x}/{y}.pbf',
///   fontConfig: (fontStack: 'Inter Regular', glyphUrlTemplate: 'file://packages/mateo_mobile/assets/glyphs/{fontstack}/{range}.pbf'),
/// );
/// final styleJson = jsonEncode(style.toJson());
/// MapLibreMap(styleString: styleJson);
/// ```
///
/// ## Architecture
/// This DTO hierarchy mirrors the MapLibre style structure:
/// - Root: [MateoMapLibreStyle] with metadata, sources, and layers
/// - Layers: [MateoMapLibreStyleLayer] (background, fill, line, symbol variants)
/// - Paint properties: type-specific paint DTOs
/// - Layout properties: [MateoMapLibreStyleSymbolLayout]
/// - Values: [MateoMapLibreStyleValue] (scalar or zoom-stop function)
/// - Filters: [MateoMapLibreStyleFilter] (equals, gte, lte, any operators)
///
/// ## MapLibre JSON mapping
/// ```json
/// {
///   "version": 8,
///   "id": "mateo-light",
///   "name": "Mateo Light",
///   "metadata": { ... },
///   "sources": { "openmaptiles": { ... } },
///   "layers": [ ... ]
/// }
/// ```
@Freezed(toJson: true, fromJson: false)
abstract class MateoMapLibreStyle with _$MateoMapLibreStyle {
  /// Creates a full MapLibre style document.
  ///
  /// All fields are required. Use a named Mateo factory, such as
  /// [MateoMapLibreStyle.light], to build an authored style.
  const factory MateoMapLibreStyle({
    required int version,
    required String id,
    required String name,
    required String glyphs,
    required MateoMapLibreStyleMetadata metadata,
    required Map<String, MateoMapLibreStyleSource> sources,
    @MateoMapLibreStyleLayerConverter()
    required List<MateoMapLibreStyleLayer> layers,
  }) = _MateoMapLibreStyle;

  /// Builds the Mateo Mobile light map style with runtime-configurable tile and
  /// font sources.
  ///
  /// The resulting style is ready for serialization with `toJson()`, producing
  /// a MapLibre-compatible JSON map that `maplibre_gl`'s native engine can
  /// consume directly via the `styleString` parameter.
  ///
  /// ## Configuration
  /// [tileUrlTemplate] is injected into the `openmaptiles` source's `tiles`
  /// array. [tileMinZoom] and [tileMaxZoom] control the source zoom bounds.
  /// [fontConfig] provides the font stack and glyphs URL template used by
  /// text label layers. [colorScheme] replaces the authored basemap colors when
  /// a consuming app has a custom semantic map scheme.
  ///
  /// ## Layer stack
  /// The returned style contains 26 layers in the standard rendering order:
  /// 1. Background (1 layer)
  /// 2. Base fill layers — landcover, landuse, business, recreation, park, water (6 layers)
  /// 3. Base line layers — waterway, building, boundary (3 layers)
  /// 4. Road layers — tunnel, road_minor, road_tertiary, road_secondary,
  ///    road_primary, road_trunk, road_motorway, bridge (8 layers)
  /// 5. Label layers — place_state_label, place_megacity_label,
  ///    place_city_label, place_town_label, place_region_label,
  ///    road_major_label, road_local_label, poi_label (8 layers)
  factory MateoMapLibreStyle.light({
    required String tileUrlTemplate,
    required ({String fontStack, String glyphUrlTemplate}) fontConfig,
    MateoMapColorScheme? colorScheme,
    int tileMinZoom = 1,
    int tileMaxZoom = 14,
  }) => _buildLightStyle(
    tileUrlTemplate: tileUrlTemplate,
    fontStack: fontConfig.fontStack,
    glyphUrlTemplate: fontConfig.glyphUrlTemplate,
    colorScheme: colorScheme ?? _lightMapColorScheme,
    tileMinZoom: tileMinZoom,
    tileMaxZoom: tileMaxZoom,
  );
}

MateoMapLibreStyle _buildLightStyle({
  required String tileUrlTemplate,
  required String fontStack,
  required String glyphUrlTemplate,
  required MateoMapColorScheme colorScheme,
  required int tileMinZoom,
  required int tileMaxZoom,
}) {
  return MateoMapLibreStyle(
    version: 8,
    id: 'mateo-light',
    name: 'Mateo Light',
    glyphs: glyphUrlTemplate,
    metadata: const MateoMapLibreStyleMetadata(
      mapboxAutocomposite: false,
      mapboxType: 'template',
      mateoStyle: 'light',
    ),
    sources: {
      _openMapTilesSource: MateoMapLibreStyleSource(
        type: 'vector',
        tiles: [tileUrlTemplate],
        minzoom: tileMinZoom,
        maxzoom: tileMaxZoom,
      ),
    },
    layers: _buildLightLayers(fontStack: fontStack, colorScheme: colorScheme),
  );
}

List<MateoMapLibreStyleLayer> _buildLightLayers({
  required String fontStack,
  required MateoMapColorScheme colorScheme,
}) {
  return [
    // ── Background ──────────────────────────────────────────────────────
    MateoMapLibreStyleLayer.background(
      id: 'background',
      paint: MateoMapLibreStyleBackgroundPaint(
        backgroundColor: colorScheme.background.toHex(),
      ),
    ),

    // ── Fill layers ────────────────────────────────────────────────────
    MateoMapLibreStyleLayer.fill(
      id: 'landcover',
      source: _openMapTilesSource,
      sourceLayer: 'landcover',
      paint: MateoMapLibreStyleFillPaint(
        fillColor: colorScheme.landcover.toHex(),
        fillOpacity: 0.8,
      ),
    ),
    MateoMapLibreStyleLayer.fill(
      id: 'landuse',
      source: _openMapTilesSource,
      sourceLayer: 'landuse',
      paint: MateoMapLibreStyleFillPaint(
        fillColor: colorScheme.landuse.toHex(),
        fillOpacity: 0.9,
      ),
    ),
    MateoMapLibreStyleLayer.fill(
      id: 'landuse_business',
      source: _openMapTilesSource,
      sourceLayer: 'landuse',
      filter: const MateoMapLibreStyleFilter.any(
        filters: [
          MateoMapLibreStyleFilter.equals(key: 'class', value: 'commercial'),
          MateoMapLibreStyleFilter.equals(key: 'class', value: 'retail'),
        ],
      ),
      paint: MateoMapLibreStyleFillPaint(
        fillColor: colorScheme.landuseBusiness.toHex(),
        fillOpacity: 0.55,
      ),
    ),
    MateoMapLibreStyleLayer.fill(
      id: 'landuse_recreation',
      source: _openMapTilesSource,
      sourceLayer: 'landuse',
      filter: const MateoMapLibreStyleFilter.any(
        filters: [
          MateoMapLibreStyleFilter.equals(key: 'class', value: 'pitch'),
          MateoMapLibreStyleFilter.equals(key: 'class', value: 'playground'),
          MateoMapLibreStyleFilter.equals(key: 'class', value: 'track'),
          MateoMapLibreStyleFilter.equals(key: 'class', value: 'stadium'),
        ],
      ),
      paint: MateoMapLibreStyleFillPaint(
        fillColor: colorScheme.landuseRecreation.toHex(),
        fillOpacity: 0.8,
      ),
    ),
    MateoMapLibreStyleLayer.fill(
      id: 'park',
      source: _openMapTilesSource,
      sourceLayer: 'park',
      paint: MateoMapLibreStyleFillPaint(
        fillColor: colorScheme.park.toHex(),
        fillOpacity: 0.8,
      ),
    ),
    MateoMapLibreStyleLayer.fill(
      id: 'water',
      source: _openMapTilesSource,
      sourceLayer: 'water',
      paint: MateoMapLibreStyleFillPaint(
        fillColor: colorScheme.water.toHex(),
        fillOpacity: 1,
      ),
    ),

    // ── Line layers ────────────────────────────────────────────────────
    MateoMapLibreStyleLayer.line(
      id: 'waterway',
      source: _openMapTilesSource,
      sourceLayer: 'waterway',
      paint: MateoMapLibreStyleLinePaint(
        lineColor: colorScheme.waterway.toHex(),
        lineWidth: const MateoMapLibreStyleValue.stops([
          MateoMapLibreStyleZoomStop(zoom: 10, value: 0.7),
          MateoMapLibreStyleZoomStop(zoom: 16, value: 2.2),
        ]),
        lineOpacity: 0.9,
      ),
    ),
    MateoMapLibreStyleLayer.fill(
      id: 'building',
      source: _openMapTilesSource,
      sourceLayer: 'building',
      minzoom: 13,
      paint: MateoMapLibreStyleFillPaint(
        fillColor: colorScheme.building.toHex(),
        fillOutlineColor: colorScheme.buildingOutline.toHex(),
        fillOpacity: 1,
      ),
    ),
    MateoMapLibreStyleLayer.line(
      id: 'boundary',
      source: _openMapTilesSource,
      sourceLayer: 'boundary',
      paint: MateoMapLibreStyleLinePaint(
        lineColor: colorScheme.boundary.toHex(),
        lineWidth: const MateoMapLibreStyleValue.scalar(0.7),
        lineOpacity: 0.65,
      ),
    ),
    MateoMapLibreStyleLayer.line(
      id: 'tunnel',
      source: _openMapTilesSource,
      sourceLayer: 'transportation',
      filter: const MateoMapLibreStyleFilter.equals(
        key: 'brunnel',
        value: 'tunnel',
      ),
      paint: MateoMapLibreStyleLinePaint(
        lineColor: colorScheme.tunnel.toHex(),
        lineWidth: const MateoMapLibreStyleValue.stops([
          MateoMapLibreStyleZoomStop(zoom: 10, value: 0.3),
          MateoMapLibreStyleZoomStop(zoom: 14, value: 2),
          MateoMapLibreStyleZoomStop(zoom: 16, value: 6),
        ]),
        lineOpacity: 0.45,
      ),
    ),
    MateoMapLibreStyleLayer.line(
      id: 'road_minor',
      source: _openMapTilesSource,
      sourceLayer: 'transportation',
      filter: const MateoMapLibreStyleFilter.any(
        filters: [
          MateoMapLibreStyleFilter.equals(key: 'class', value: 'minor'),
          MateoMapLibreStyleFilter.equals(key: 'class', value: 'service'),
          MateoMapLibreStyleFilter.equals(key: 'class', value: 'track'),
          MateoMapLibreStyleFilter.equals(key: 'class', value: 'path'),
        ],
      ),
      paint: MateoMapLibreStyleLinePaint(
        lineColor: colorScheme.road.toHex(),
        lineWidth: const MateoMapLibreStyleValue.stops([
          MateoMapLibreStyleZoomStop(zoom: 11, value: 0.15),
          MateoMapLibreStyleZoomStop(zoom: 14, value: 0.45),
          MateoMapLibreStyleZoomStop(zoom: 16, value: 1.4),
        ]),
        lineOpacity: 0.95,
      ),
    ),
    MateoMapLibreStyleLayer.line(
      id: 'road_tertiary',
      source: _openMapTilesSource,
      sourceLayer: 'transportation',
      filter: const MateoMapLibreStyleFilter.equals(
        key: 'class',
        value: 'tertiary',
      ),
      paint: MateoMapLibreStyleLinePaint(
        lineColor: colorScheme.road.toHex(),
        lineWidth: const MateoMapLibreStyleValue.stops([
          MateoMapLibreStyleZoomStop(zoom: 8, value: 0.25),
          MateoMapLibreStyleZoomStop(zoom: 12, value: 0.9),
          MateoMapLibreStyleZoomStop(zoom: 14, value: 2.4),
          MateoMapLibreStyleZoomStop(zoom: 16, value: 5.2),
        ]),
        lineOpacity: 0.82,
      ),
    ),
    MateoMapLibreStyleLayer.line(
      id: 'road_secondary',
      source: _openMapTilesSource,
      sourceLayer: 'transportation',
      filter: const MateoMapLibreStyleFilter.equals(
        key: 'class',
        value: 'secondary',
      ),
      paint: MateoMapLibreStyleLinePaint(
        lineColor: colorScheme.road.toHex(),
        lineWidth: const MateoMapLibreStyleValue.stops([
          MateoMapLibreStyleZoomStop(zoom: 8, value: 0.35),
          MateoMapLibreStyleZoomStop(zoom: 12, value: 1.2),
          MateoMapLibreStyleZoomStop(zoom: 14, value: 3.3),
          MateoMapLibreStyleZoomStop(zoom: 16, value: 7),
        ]),
        lineOpacity: 0.86,
      ),
    ),
    MateoMapLibreStyleLayer.line(
      id: 'road_primary',
      source: _openMapTilesSource,
      sourceLayer: 'transportation',
      filter: const MateoMapLibreStyleFilter.equals(
        key: 'class',
        value: 'primary',
      ),
      paint: MateoMapLibreStyleLinePaint(
        lineColor: colorScheme.road.toHex(),
        lineWidth: const MateoMapLibreStyleValue.stops([
          MateoMapLibreStyleZoomStop(zoom: 8, value: 0.45),
          MateoMapLibreStyleZoomStop(zoom: 12, value: 1.7),
          MateoMapLibreStyleZoomStop(zoom: 14, value: 4.5),
          MateoMapLibreStyleZoomStop(zoom: 16, value: 9),
        ]),
        lineOpacity: 0.9,
      ),
    ),
    MateoMapLibreStyleLayer.line(
      id: 'road_trunk',
      source: _openMapTilesSource,
      sourceLayer: 'transportation',
      filter: const MateoMapLibreStyleFilter.equals(
        key: 'class',
        value: 'trunk',
      ),
      paint: MateoMapLibreStyleLinePaint(
        lineColor: colorScheme.road.toHex(),
        lineWidth: const MateoMapLibreStyleValue.stops([
          MateoMapLibreStyleZoomStop(zoom: 7, value: 0.55),
          MateoMapLibreStyleZoomStop(zoom: 12, value: 2.2),
          MateoMapLibreStyleZoomStop(zoom: 14, value: 5.8),
          MateoMapLibreStyleZoomStop(zoom: 16, value: 11.5),
        ]),
        lineOpacity: 0.92,
      ),
    ),
    MateoMapLibreStyleLayer.line(
      id: 'road_motorway',
      source: _openMapTilesSource,
      sourceLayer: 'transportation',
      filter: const MateoMapLibreStyleFilter.equals(
        key: 'class',
        value: 'motorway',
      ),
      paint: MateoMapLibreStyleLinePaint(
        lineColor: colorScheme.road.toHex(),
        lineWidth: const MateoMapLibreStyleValue.stops([
          MateoMapLibreStyleZoomStop(zoom: 5, value: 0.6),
          MateoMapLibreStyleZoomStop(zoom: 10, value: 1.5),
          MateoMapLibreStyleZoomStop(zoom: 14, value: 6),
          MateoMapLibreStyleZoomStop(zoom: 16, value: 13.5),
        ]),
        lineOpacity: 0.95,
      ),
    ),
    MateoMapLibreStyleLayer.line(
      id: 'bridge',
      source: _openMapTilesSource,
      sourceLayer: 'transportation',
      filter: const MateoMapLibreStyleFilter.equals(
        key: 'brunnel',
        value: 'bridge',
      ),
      paint: MateoMapLibreStyleLinePaint(
        lineColor: colorScheme.road.toHex(),
        lineWidth: const MateoMapLibreStyleValue.stops([
          MateoMapLibreStyleZoomStop(zoom: 10, value: 0.5),
          MateoMapLibreStyleZoomStop(zoom: 14, value: 3),
          MateoMapLibreStyleZoomStop(zoom: 16, value: 12),
        ]),
        lineOpacity: 0.9,
      ),
    ),

    // ── Symbol layers ──────────────────────────────────────────────────
    MateoMapLibreStyleLayer.symbol(
      id: 'place_state_label',
      source: _openMapTilesSource,
      sourceLayer: 'place',
      minzoom: 3,
      maxzoom: 9,
      filter: const MateoMapLibreStyleFilter.equals(
        key: 'class',
        value: 'state',
      ),
      layout: MateoMapLibreStyleSymbolLayout(
        textField: '{name}',
        textFont: [fontStack],
        textSize: const MateoMapLibreStyleValue.stops([
          MateoMapLibreStyleZoomStop(zoom: 3, value: 7),
          MateoMapLibreStyleZoomStop(zoom: 4, value: 9),
          MateoMapLibreStyleZoomStop(zoom: 5, value: 12),
          MateoMapLibreStyleZoomStop(zoom: 8, value: 18),
        ]),
        textMaxWidth: 5,
        textTransform: 'uppercase',
        textLetterSpacing: 0.15,
      ),
      paint: MateoMapLibreStyleSymbolPaint(
        textColor: colorScheme.administrativeLabel.toHex(),
        textHaloColor: colorScheme.labelHalo.toHex(),
        textHaloWidth: 1,
        textOpacity: 0.5,
      ),
    ),
    MateoMapLibreStyleLayer.symbol(
      id: 'place_megacity_label',
      source: _openMapTilesSource,
      sourceLayer: 'place',
      minzoom: 4,
      maxzoom: 11,
      filter: const MateoMapLibreStyleFilter.greaterThanOrEqual(
        key: 'capital',
        value: 2,
      ),
      layout: MateoMapLibreStyleSymbolLayout(
        textField: '{name}',
        textFont: [fontStack],
        textSize: const MateoMapLibreStyleValue.stops([
          MateoMapLibreStyleZoomStop(zoom: 4, value: 7),
          MateoMapLibreStyleZoomStop(zoom: 5, value: 11),
          MateoMapLibreStyleZoomStop(zoom: 8, value: 15.5),
          MateoMapLibreStyleZoomStop(zoom: 10, value: 18),
          MateoMapLibreStyleZoomStop(zoom: 11, value: 22),
        ]),
        textMaxWidth: 14,
        textAnchor: 'bottom',
      ),
      paint: MateoMapLibreStyleSymbolPaint(
        textColor: colorScheme.cityLabel.toHex(),
        textHaloColor: colorScheme.labelHalo.toHex(),
        textHaloWidth: 1,
      ),
    ),
    MateoMapLibreStyleLayer.symbol(
      id: 'place_city_label',
      source: _openMapTilesSource,
      sourceLayer: 'place',
      minzoom: 5,
      maxzoom: 11,
      filter: const MateoMapLibreStyleFilter.any(
        filters: [
          MateoMapLibreStyleFilter.equals(key: 'class', value: 'city'),
          MateoMapLibreStyleFilter.lessThanOrEqual(key: 'rank', value: 4),
        ],
      ),
      layout: MateoMapLibreStyleSymbolLayout(
        textField: '{name}',
        textFont: [fontStack],
        textSize: const MateoMapLibreStyleValue.stops([
          MateoMapLibreStyleZoomStop(zoom: 5, value: 10),
          MateoMapLibreStyleZoomStop(zoom: 8, value: 14),
          MateoMapLibreStyleZoomStop(zoom: 10, value: 18),
          MateoMapLibreStyleZoomStop(zoom: 11, value: 20),
        ]),
        textMaxWidth: 10,
      ),
      paint: MateoMapLibreStyleSymbolPaint(
        textColor: colorScheme.cityLabel.toHex(),
        textHaloColor: colorScheme.labelHalo.toHex(),
        textHaloWidth: 1,
      ),
    ),
    MateoMapLibreStyleLayer.symbol(
      id: 'place_town_label',
      source: _openMapTilesSource,
      sourceLayer: 'place',
      minzoom: 8,
      filter: const MateoMapLibreStyleFilter.equals(
        key: 'class',
        value: 'town',
      ),
      layout: MateoMapLibreStyleSymbolLayout(
        textField: '{name}',
        textFont: [fontStack],
        textSize: const MateoMapLibreStyleValue.stops([
          MateoMapLibreStyleZoomStop(zoom: 8, value: 11),
          MateoMapLibreStyleZoomStop(zoom: 10, value: 13),
          MateoMapLibreStyleZoomStop(zoom: 14, value: 18),
        ]),
        textMaxWidth: 8,
      ),
      paint: MateoMapLibreStyleSymbolPaint(
        textColor: colorScheme.townLabel.toHex(),
        textHaloColor: colorScheme.labelHalo.toHex(),
        textHaloWidth: 1,
      ),
    ),
    MateoMapLibreStyleLayer.symbol(
      id: 'place_region_label',
      source: _openMapTilesSource,
      sourceLayer: 'place',
      minzoom: 11,
      maxzoom: 16,
      filter: const MateoMapLibreStyleFilter.any(
        filters: [
          MateoMapLibreStyleFilter.equals(key: 'class', value: 'suburb'),
          MateoMapLibreStyleFilter.equals(key: 'class', value: 'neighbourhood'),
          MateoMapLibreStyleFilter.equals(key: 'class', value: 'neighborhood'),
          MateoMapLibreStyleFilter.equals(key: 'class', value: 'quarter'),
          MateoMapLibreStyleFilter.equals(key: 'class', value: 'hamlet'),
          MateoMapLibreStyleFilter.equals(key: 'class', value: 'village'),
        ],
      ),
      layout: MateoMapLibreStyleSymbolLayout(
        textField: '{name}',
        textFont: [fontStack],
        textSize: const MateoMapLibreStyleValue.stops([
          MateoMapLibreStyleZoomStop(zoom: 11, value: 11),
          MateoMapLibreStyleZoomStop(zoom: 12, value: 13),
          MateoMapLibreStyleZoomStop(zoom: 14, value: 15),
        ]),
        textMaxWidth: 11,
      ),
      paint: MateoMapLibreStyleSymbolPaint(
        textColor: colorScheme.neighborhoodLabel.toHex(),
        textHaloColor: colorScheme.labelHalo.toHex(),
        textHaloWidth: 1,
      ),
    ),
    MateoMapLibreStyleLayer.symbol(
      id: 'road_major_label',
      source: _openMapTilesSource,
      sourceLayer: 'transportation_name',
      minzoom: 13,
      maxzoom: 18,
      filter: const MateoMapLibreStyleFilter.any(
        filters: [
          MateoMapLibreStyleFilter.equals(key: 'class', value: 'motorway'),
          MateoMapLibreStyleFilter.equals(key: 'class', value: 'trunk'),
          MateoMapLibreStyleFilter.equals(key: 'class', value: 'primary'),
          MateoMapLibreStyleFilter.equals(key: 'class', value: 'secondary'),
          MateoMapLibreStyleFilter.equals(key: 'class', value: 'tertiary'),
        ],
      ),
      layout: MateoMapLibreStyleSymbolLayout(
        symbolPlacement: 'line',
        textField: '{name}',
        textFont: [fontStack],
        textSize: const MateoMapLibreStyleValue.stops([
          MateoMapLibreStyleZoomStop(zoom: 13, value: 8),
          MateoMapLibreStyleZoomStop(zoom: 14, value: 10),
          MateoMapLibreStyleZoomStop(zoom: 16, value: 12),
        ]),
      ),
      paint: MateoMapLibreStyleSymbolPaint(
        textColor: colorScheme.roadMajorLabel.toHex(),
        textHaloColor: colorScheme.labelHalo.toHex(),
        textHaloWidth: 1,
      ),
    ),
    MateoMapLibreStyleLayer.symbol(
      id: 'road_local_label',
      source: _openMapTilesSource,
      sourceLayer: 'transportation_name',
      minzoom: 15,
      filter: const MateoMapLibreStyleFilter.any(
        filters: [
          MateoMapLibreStyleFilter.equals(key: 'class', value: 'minor'),
          MateoMapLibreStyleFilter.equals(key: 'class', value: 'service'),
          MateoMapLibreStyleFilter.equals(key: 'class', value: 'track'),
          MateoMapLibreStyleFilter.equals(key: 'class', value: 'path'),
        ],
      ),
      layout: MateoMapLibreStyleSymbolLayout(
        symbolPlacement: 'line',
        textField: '{name}',
        textFont: [fontStack],
        textSize: const MateoMapLibreStyleValue.stops([
          MateoMapLibreStyleZoomStop(zoom: 15, value: 8),
          MateoMapLibreStyleZoomStop(zoom: 18, value: 11),
        ]),
      ),
      paint: MateoMapLibreStyleSymbolPaint(
        textColor: colorScheme.roadLocalLabel.toHex(),
        textHaloColor: colorScheme.labelHalo.toHex(),
        textHaloWidth: 1,
      ),
    ),
    MateoMapLibreStyleLayer.symbol(
      id: 'poi_label',
      source: _openMapTilesSource,
      sourceLayer: 'poi',
      minzoom: 15,
      layout: MateoMapLibreStyleSymbolLayout(
        textField: '{name}',
        textFont: [fontStack],
        textSize: const MateoMapLibreStyleValue.scalar(13),
        textMaxWidth: 7,
      ),
      paint: MateoMapLibreStyleSymbolPaint(
        textColor: colorScheme.pointOfInterestLabel.toHex(),
        textHaloColor: colorScheme.labelHalo.toHex(),
        textHaloWidth: 1,
      ),
    ),
  ];
}
