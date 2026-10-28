import 'dart:convert';
import 'dart:ffi';

import 'package:meta/meta.dart' show internal;

import 'three_d_icon_usage.dart';

@internal
abstract final class ThreeDIconMetadataNative {
  @Native<Pointer<Uint8> Function()>(symbol: 'mateo_three_d_icon_metadata_bytes')
  external static Pointer<Uint8> _bytes();

  @Native<Uint32 Function()>(symbol: 'mateo_three_d_icon_metadata_length')
  external static int _length();

  static List<ThreeDIconUsage> read() => ThreeDIconUsage.decode(utf8.decode(_bytes().asTypedList(_length())));
}
