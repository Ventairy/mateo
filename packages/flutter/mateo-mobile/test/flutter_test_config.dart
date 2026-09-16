import 'dart:async';

import 'package:alchemist/alchemist.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

/// Loads the package fonts and configures focused theme goldens.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await (FontLoader(MateoTypography.fontFamily)
        ..addFont(rootBundle.load('assets/fonts/inter_variable.ttf'))
        ..addFont(rootBundle.load('assets/fonts/inter_italic.ttf')))
      .load();
  await AlchemistConfig.runWithConfig(
    config: const AlchemistConfig(),
    run: testMain,
  );
}
