import 'package:alchemist/alchemist.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

import '../fixtures/app_test_router_delegate.dart';

Future<void> main() async {
  await goldenTest(
    'when rendering home and router apps, it should apply the same Mateo appearance',
    fileName: 'mateo_app',
    builder: () {
      final theme = MateoThemeData.light(accentColor: const Color(0xFF4A5CFF), onAccent: MateoPalette().white);
      final delegate = AppTestRouterDelegate(home: const Builder(builder: _buildContent));
      addTearDown(delegate.dispose);
      return GoldenTestGroup(
        columns: 2,
        children: [
          for (final (label, app) in [
            (
              'Home',
              MateoApp(
                theme: theme,
                home: const Builder(builder: _buildContent),
              ),
            ),
            (
              'Router',
              MateoApp.router(
                theme: theme,
                routerConfig: RouterConfig<Object>(routerDelegate: delegate),
              ),
            ),
          ])
            GoldenTestScenario(
              name: label,
              child: SizedBox(
                width: 280,
                height: 240,
                child: DefaultTextStyle(style: const TextStyle(fontSize: 18, height: 1.4), child: app),
              ),
            ),
        ],
      );
    },
  );
}

Widget _buildContent(BuildContext context) {
  final colors = MateoTheme.of(context).colorScheme;
  return Padding(
    padding: const .all(24),
    child: Column(
      mainAxisAlignment: .center,
      crossAxisAlignment: .stretch,
      children: [
        const Text('Hello, Mateo'),
        Text('A place to get started.', style: TextStyle(color: colors.text.secondary)),
        const SizedBox(height: 20),
        ColoredBox(
          color: colors.accent,
          child: Padding(
            padding: const .all(12),
            child: Text('Your app, your accent', style: TextStyle(color: colors.onAccent)),
          ),
        ),
      ],
    ),
  );
}
