import 'dart:convert';

import 'package:meta/meta.dart' show internal;

@internal
class ThreeDIconUsage {
  const ThreeDIconUsage({required this.icon, required this.size, required this.background});

  static const backgroundArtworkScale = 0.65;

  final String icon;
  final double size;
  final bool background;

  static List<ThreeDIconUsage> decode(String source) {
    final value = jsonDecode(source);
    if (value is! List<Object?>) throw const FormatException('Expected recorded icon usages.');
    return [
      for (final entry in value)
        switch (entry) {
          {'icon': final String icon, 'size': final num size, 'background': final bool background}
              when size.isFinite && size > 0 =>
            ThreeDIconUsage(icon: icon, size: size.toDouble(), background: background),
          _ => throw const FormatException('Invalid recorded icon usage.'),
        },
    ];
  }

  double get artworkSize => background ? size * backgroundArtworkScale : size;

  Map<String, Object> toJson() => {'icon': icon, 'size': size, 'background': background};
}
