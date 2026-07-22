/// JSON serialization converters for [MateoMapLibreStyleValue] and [MateoMapLibreStyleLayer].
///
/// These converters are used by `json_serializable` when generating `toJson`
/// code for Freezed DTOs that contain these types. They delegate to the
/// extension-based `toJson()` methods defined on each sealed class.
///
/// Only `toJson()` is supported. `fromJson()` throws `UnsupportedError`.
library;

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mateo_mobile/src/theme/map_style/mateo_map_style_layer.dart';
import 'package:mateo_mobile/src/theme/map_style/mateo_map_style_value.dart';

/// Converts [MateoMapLibreStyleValue] to/from its JSON representation.
///
/// Used via `@MateoMapLibreStyleValueConverter()` annotation on DTO fields.
class MateoMapLibreStyleValueConverter
    implements JsonConverter<MateoMapLibreStyleValue, Object> {
  const MateoMapLibreStyleValueConverter();

  @override
  MateoMapLibreStyleValue fromJson(Object json) => throw UnsupportedError(
    'MateoMapLibreStyleValue.fromJson is not supported',
  );

  @override
  Object toJson(MateoMapLibreStyleValue value) => value.toJson();
}

/// Converts a list of [MateoMapLibreStyleLayer] to/from its JSON representation.
///
/// Used via `@MateoMapLibreStyleLayerConverter()` annotation on DTO fields.
class MateoMapLibreStyleLayerConverter
    implements JsonConverter<List<MateoMapLibreStyleLayer>, List<dynamic>> {
  const MateoMapLibreStyleLayerConverter();

  @override
  List<MateoMapLibreStyleLayer> fromJson(List<dynamic> json) =>
      throw UnsupportedError(
        'MateoMapLibreStyleLayer.fromJson is not supported',
      );

  @override
  List<dynamic> toJson(List<MateoMapLibreStyleLayer> layers) =>
      layers.map((l) => l.toJson()).toList();
}
