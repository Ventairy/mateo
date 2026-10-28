import 'dart:async';
import 'dart:io';

import 'package:alchemist/alchemist.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

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
  await AlchemistConfig.runWithConfig(
    config: AlchemistConfig(
      platformGoldensConfig: PlatformGoldensConfig(enabled: Platform.environment['CI'] != 'true'),
    ),
    run: testMain,
  );
}
