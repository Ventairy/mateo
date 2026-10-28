import 'dart:convert';
import 'dart:io';

import 'package:mateo_mobile/src/components/mateo_icon/three_d_icon_cache/three_d_icon_usage.dart';

abstract final class ThreeDIconMetadataLibrary {
  static const name = 'mateo_three_d_icon_metadata';
  static const assetName = 'src/components/mateo_icon/three_d_icon_cache/three_d_icon_metadata_native.dart';

  static Future<Uri> write({required Uri directory, required List<ThreeDIconUsage> usages}) async {
    final bytes = utf8.encode(jsonEncode([for (final usage in usages) usage.toJson()]));
    final file = File.fromUri(directory.resolve('mateo_three_d_icon_metadata.c'));
    await file.parent.create(recursive: true);
    await file.writeAsString('''
#include <stdint.h>
#if defined(_WIN32)
#define MATEO_EXPORT __declspec(dllexport)
#else
#define MATEO_EXPORT __attribute__((visibility("default"))) __attribute__((used))
#endif
static const uint8_t mateo_three_d_icon_usages[] = {${bytes.join(',')}};
MATEO_EXPORT const uint8_t* mateo_three_d_icon_metadata_bytes(void) { return mateo_three_d_icon_usages; }
MATEO_EXPORT uint32_t mateo_three_d_icon_metadata_length(void) { return sizeof(mateo_three_d_icon_usages); }
''');
    return file.uri;
  }
}
