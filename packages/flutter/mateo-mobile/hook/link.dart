import 'package:data_assets/data_assets.dart';
import 'package:hooks/hooks.dart';
import 'package:record_use/record_use.dart';

void main(List<String> arguments) async {
  await link(arguments, (input, output) async {
    final recordedUses = input.recordedUses;
    if (recordedUses == null) {
      output.assets.data.addAll(input.assets.data);
      return;
    }

    final iconLibrary = Library('package:${input.packageName}/src/components/mateo_icon/mateo_icon.dart');
    final iconClass = Class('MateoIcon', iconLibrary);
    const imageAssetDirectory = 'assets/three_d_icons/';
    final imageAssets = input.assets.data.where((asset) => asset.name.startsWith(imageAssetDirectory)).toList();
    final retainedFiles = <String>{};

    for (final instance in recordedUses.instances[iconClass] ?? const []) {
      final (icon, style) = switch (instance) {
        InstanceConstantReference(instanceConstant: InstanceConstant(:final fields)) => (
          fields['icon'],
          fields['style'],
        ),
        InstanceCreationReference(positionalArguments: [final icon, ...], namedArguments: final named) => (
          icon,
          named['style'],
        ),
        _ => (null, null),
      };
      if (style case EnumConstant(name: 'svg')) continue;

      if (icon case EnumConstant(:final name)) {
        final fileName = name.replaceAllMapped(
          RegExp('[A-Z]'),
          (match) => '-${match[0]!.toLowerCase()}',
        );
        retainedFiles.add('$imageAssetDirectory$fileName.webp');
        continue;
      }

      retainedFiles.addAll(imageAssets.map((asset) => asset.name));
    }

    output.assets.data.addAll([
      for (final asset in input.assets.data)
        if (retainedFiles.contains(asset.name)) asset,
    ]);
  });
}
