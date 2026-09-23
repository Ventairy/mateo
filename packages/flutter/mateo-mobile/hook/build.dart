import 'dart:io';

import 'package:data_assets/data_assets.dart';
import 'package:hooks/hooks.dart';

void main(List<String> arguments) async {
  await build(arguments, (input, output) async {
    if (!input.config.buildDataAssets) return;

    const imageAssetDirectory = 'assets/three_d_icons/';
    final assetDirectory = Directory.fromUri(input.packageRoot.resolve(imageAssetDirectory));
    output.dependencies.add(assetDirectory.uri);
    final imageFiles = assetDirectory.listSync().whereType<File>().where((file) => file.path.endsWith('.webp')).toList()
      ..sort((first, second) => first.path.compareTo(second.path));

    for (final file in imageFiles) {
      final fileName = file.uri.pathSegments.last;
      final assetPath = '$imageAssetDirectory$fileName';
      final staged = input.outputDirectoryShared.resolve(assetPath);
      output.dependencies.add(file.uri);
      await File.fromUri(staged).create(recursive: true);
      await file.copy(staged.toFilePath());
      output.assets.data.add(
        DataAsset(package: input.packageName, name: assetPath, file: staged),
        routing: input.config.linkingEnabled ? ToLinkHook(input.packageName) : const ToAppBundle(),
      );
    }
  });
}
