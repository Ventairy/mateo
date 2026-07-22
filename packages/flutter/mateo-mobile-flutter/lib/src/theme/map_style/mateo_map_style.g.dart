// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mateo_map_style.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$MateoMapLibreStyleToJson(
  _MateoMapLibreStyle instance,
) => <String, dynamic>{
  'version': instance.version,
  'id': instance.id,
  'name': instance.name,
  'glyphs': instance.glyphs,
  'metadata': instance.metadata.toJson(),
  'sources': instance.sources.map((k, e) => MapEntry(k, e.toJson())),
  'layers': const MateoMapLibreStyleLayerConverter().toJson(instance.layers),
};
