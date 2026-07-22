// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mateo_map_style_symbol_layout.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$MateoMapLibreStyleSymbolLayoutToJson(
  _MateoMapLibreStyleSymbolLayout instance,
) => <String, dynamic>{
  'text-field': ?instance.textField,
  'text-font': ?instance.textFont,
  'text-size': ?_$JsonConverterToJson<Object, MateoMapLibreStyleValue>(
    instance.textSize,
    const MateoMapLibreStyleValueConverter().toJson,
  ),
  'text-max-width': ?instance.textMaxWidth,
  'text-anchor': ?instance.textAnchor,
  'text-letter-spacing': ?instance.textLetterSpacing,
  'text-transform': ?instance.textTransform,
  'symbol-placement': ?instance.symbolPlacement,
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
