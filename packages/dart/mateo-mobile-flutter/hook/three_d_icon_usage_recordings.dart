import 'package:mateo_mobile/src/components/mateo_icon/three_d_icon_cache/three_d_icon_usage.dart';
import 'package:record_use/record_use.dart';

abstract final class ThreeDIconUsageRecordings {
  static List<ThreeDIconUsage> extract(Recordings? recordings) {
    if (recordings == null) return const [];
    const iconClass = Class('MateoIcon', Library('package:mateo_mobile/src/components/mateo_icon/mateo_icon.dart'));
    final usages = <String, ThreeDIconUsage>{};
    for (final instance in recordings.instances[iconClass] ?? const []) {
      final (icon, style, size, background) = switch (instance) {
        InstanceConstantReference(instanceConstant: InstanceConstant(:final fields)) => (
          fields['icon'],
          fields['style'],
          fields['size'],
          fields['backgroundColor'],
        ),
        InstanceCreationReference(positionalArguments: [final icon, ...], namedArguments: final named) => (
          icon,
          named['style'],
          named['size'],
          named['backgroundColor'],
        ),
        _ => (null, null, null, null),
      };
      if (style is! EnumConstant || style.name != 'threeD' || icon is! EnumConstant) continue;
      final logicalSize = switch (size) {
        DoubleConstant(:final value) => value,
        IntConstant(:final value) => value.toDouble(),
        _ => null,
      };
      if (logicalSize == null || !logicalSize.isFinite || logicalSize <= 0) continue;
      if (background == null || background is NonConstant) continue;
      final hasBackground = background is! NullConstant;
      final usage = ThreeDIconUsage(icon: icon.name, size: logicalSize, background: hasBackground);
      usages['${icon.name}:$logicalSize:$hasBackground'] = usage;
    }
    final keys = usages.keys.toList()..sort();
    return [for (final key in keys) usages[key]!];
  }
}
