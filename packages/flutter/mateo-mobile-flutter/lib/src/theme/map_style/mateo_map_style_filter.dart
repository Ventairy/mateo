/// A typed representation of a MapLibre GL filter expression.
///
/// Filters select which features from a vector tile source layer are rendered
/// by a layer. The MapLibre GL Style Specification uses operator-based filter
/// expressions. This sealed class models the subset of filter operators used
/// by Mateo Mobile map styles.
///
/// ## MapLibre JSON mapping
/// Each variant serializes to the equivalent filter array:
/// - `equals` → `["==", key, value]`
/// - `greaterThanOrEqual` → `[">=", key, value]`
/// - `lessThanOrEqual` → `["<=", key, value]`
/// - `any` → `["any", filter1, filter2, ...]`
///
/// ## Supported operators
/// | Operator | Constructor | Description |
/// |---|---|---|
/// | `==` | `equals` | Feature key equals value |
/// | `>=` | `greaterThanOrEqual` | Feature key `>=` numeric value |
/// | `<=` | `lessThanOrEqual` | Feature key `<=` numeric value |
/// | `any` | `any` | Logical OR of child filters |
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'mateo_map_style_filter.freezed.dart';

@Freezed(toJson: false, fromJson: false)
sealed class MateoMapLibreStyleFilter with _$MateoMapLibreStyleFilter {
  /// Creates a filter that matches features where [key] equals [value].
  ///
  /// Corresponds to the MapLibre `["==", key, value]` expression.
  const factory MateoMapLibreStyleFilter.equals({
    required String key,
    required Object value,
  }) = MateoMapLibreStyleEqualsFilter;

  /// Creates a filter that matches features where [key] `>=` [value].
  ///
  /// Corresponds to the MapLibre `[">=", key, value]` expression.
  const factory MateoMapLibreStyleFilter.greaterThanOrEqual({
    required String key,
    required num value,
  }) = MateoMapLibreStyleGteFilter;

  /// Creates a filter that matches features where [key] `<=` [value].
  ///
  /// Corresponds to the MapLibre `["<=", key, value]` expression.
  const factory MateoMapLibreStyleFilter.lessThanOrEqual({
    required String key,
    required num value,
  }) = MateoMapLibreStyleLteFilter;

  /// Creates a filter that matches features matching any of [filters].
  ///
  /// Corresponds to the MapLibre `["any", ...]` expression. Child filters
  /// are evaluated with logical OR semantics.
  const factory MateoMapLibreStyleFilter.any({
    required List<MateoMapLibreStyleFilter> filters,
  }) = MateoMapLibreStyleAnyFilter;
}

/// JSON serialization extension for [MateoMapLibreStyleFilter].
extension MateoMapLibreStyleFilterJson on MateoMapLibreStyleFilter {
  /// Serializes this filter to a MapLibre-compatible array expression.
  List<dynamic> toJson() => switch (this) {
    MateoMapLibreStyleEqualsFilter(:final key, :final value) => [
      '==',
      key,
      value,
    ],
    MateoMapLibreStyleGteFilter(:final key, :final value) => ['>=', key, value],
    MateoMapLibreStyleLteFilter(:final key, :final value) => ['<=', key, value],
    MateoMapLibreStyleAnyFilter(:final filters) => [
      'any',
      ...filters.map((f) => f.toJson()),
    ],
  };
}
