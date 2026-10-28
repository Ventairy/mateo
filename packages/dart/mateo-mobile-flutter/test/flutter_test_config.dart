import 'dart:async';
import 'dart:io';

import 'package:alchemist/alchemist.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import 'fixtures/mateo_golden_file_comparator/mateo_golden_file_comparator.dart';

/// Loads the package fonts and configures focused theme goldens.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await (FontLoader(MateoTypography.interfaceFontFamily)
        ..addFont(rootBundle.load('assets/fonts/inter_variable.ttf'))
        ..addFont(rootBundle.load('assets/fonts/inter_italic.ttf')))
      .load();
  for (final (family, asset) in [
    (MateoTypography.decorativeRoundedFontFamily, 'fredoka/fredoka-variable.ttf'),
    (MateoTypography.decorativeCursiveFontFamily, 'momo-signature/momo-signature.ttf'),
  ]) {
    await (FontLoader(family)..addFont(rootBundle.load('assets/fonts/$asset'))).load();
  }
  final originalComparator = goldenFileComparator;
  if (Platform.environment['CI'] == 'true') {
    final comparator = goldenFileComparator as LocalFileComparator;
    goldenFileComparator = MateoGoldenFileComparator(comparator.basedir.resolve('_goldens.dart'));
  }
  try {
    await AlchemistConfig.runWithConfig(
      config: AlchemistConfig(
        platformGoldensConfig: PlatformGoldensConfig(enabled: Platform.environment['CI'] != 'true'),
      ),
      run: testMain,
    );
  } finally {
    goldenFileComparator = originalComparator;
  }
}
