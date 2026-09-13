import 'package:code_assets/code_assets.dart';
import 'package:hooks/hooks.dart';
import 'package:native_toolchain_c/native_toolchain_c.dart';

void main(List<String> arguments) async {
  await build(arguments, (input, output) async {
    if (!input.config.buildCodeAssets) return;
    final targetOS = input.config.code.targetOS;
    if (targetOS != .android && targetOS != .iOS && targetOS != .macOS) {
      throw UnsupportedError(
        'Mateo supports Android, iOS, and macOS host tests.',
      );
    }
    await CBuilder.library(
      name: 'mateo_rounded_convex_interpolation',
      assetName: 'src/foundation/mateo_rounded_convex_interpolation/mateo_rounded_convex_evaluator.dart',
      sources: const [
        'src/rounded_convex_interpolation/kernel.cpp',
        'src/rounded_convex_interpolation/path.cpp',
      ],
      includes: const ['src/rounded_convex_interpolation'],
      language: .cpp,
      std: 'c++17',
      cppLinkStdLib: targetOS == .android ? 'c++_static' : 'c++',
      optimizationLevel: .o3,
      frameworks: const [],
      libraries: [if (targetOS == .android) 'm'],
      flags: [
        '-fno-fast-math',
        '-ffp-contract=off',
        '-fvisibility=hidden',
        '-fvisibility-inlines-hidden',
        if (targetOS == .android) '-Wl,--exclude-libs,ALL',
        if (targetOS == .android) '-Wl,--no-undefined',
      ],
    ).run(input: input, output: output);
  });
}
