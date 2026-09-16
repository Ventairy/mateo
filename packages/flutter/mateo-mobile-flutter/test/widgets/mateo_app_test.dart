import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile_old/mateo_mobile_old.dart';

import '../test_app.dart';

class _TestRouterDelegate extends RouterDelegate<Object> with ChangeNotifier {
  _TestRouterDelegate({this.onBuild});

  final void Function(BuildContext)? onBuild;

  @override
  Widget build(BuildContext context) {
    onBuild?.call(context);
    return const SizedBox.shrink();
  }

  @override
  Future<void> setNewRoutePath(Object configuration) async {}

  @override
  Future<bool> popRoute() async => false;

  @override
  Object? get currentConfiguration => null;
}

class _TestRouteInformationParser extends RouteInformationParser<Object> {
  static final RouteInformation _rootRouteInformation = RouteInformation(
    uri: Uri.parse('/'),
  );

  @override
  Future<Object> parseRouteInformation(
    RouteInformation routeInformation,
  ) async => Object();

  @override
  RouteInformation restoreRouteInformation(Object configuration) => _rootRouteInformation;
}

RouterConfig<Object> _createConfig({void Function(BuildContext)? onBuild}) {
  return RouterConfig<Object>(
    routeInformationParser: _TestRouteInformationParser(),
    routerDelegate: _TestRouterDelegate(onBuild: onBuild),
    routeInformationProvider: PlatformRouteInformationProvider(
      initialRouteInformation: _TestRouteInformationParser._rootRouteInformation,
    ),
  );
}

MateoTheme _lightTheme({
  Color accentColor = const Color(0xFF4A5CFF),
  Color onAccent = const Color(0xFFFFFFFF),
}) {
  return MateoTheme.light(
    accentColor: accentColor,
    onAccent: onAccent,
  );
}

void main() {
  group('MateoApp', () {
    testWidgets('when configured with home, it should render without a router', (tester) async {
      final configuration = _lightTheme(
        accentColor: mateoTestThemeData.palette.green[9],
        onAccent: mateoTestColorScheme.inverse.onBackground,
      );

      await tester.pumpWidget(
        MateoApp(
          title: 'Test App',
          theme: configuration,
          home: Scaffold(body: Text('Home')),
        ),
      );

      final messengerContext = tester.element(find.byType(MateoToastMessenger));
      final mateoTheme = Theme.of(messengerContext).extension<MateoThemeData>()!;

      expect(find.text('Home'), findsOneWidget);
      expect(find.byType(Navigator), findsOneWidget);
      expect(find.byType(MateoToastMessenger), findsOneWidget);
      expect(mateoTheme.palette, configuration.lightTheme.extension<MateoThemeData>()!.palette);
      expect(
        mateoTheme.colorScheme.buttons.primary.accent.foreground,
        mateoTestColorScheme.inverse.onBackground,
      );
    });

    testWidgets('when configured with a theme, it should forward the complete configuration', (tester) async {
      final configuration = _lightTheme();

      await tester.pumpWidget(
        MateoApp(
          title: 'Test App',
          theme: configuration,
          home: const SizedBox.shrink(),
        ),
      );

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      final context = tester.element(find.byType(MateoToastMessenger));
      final palette = Theme.of(context).extension<MateoThemeData>()!.palette;

      expect(materialApp.theme, same(configuration.lightTheme));
      expect(materialApp.darkTheme, same(configuration.darkTheme));
      expect(materialApp.themeMode, configuration.themeMode);
      expect(materialApp.color, configuration.lightTheme.colorScheme.primary);
      expect(palette.neutral.colors, MateoPalette().neutral.colors);
    });

    testWidgets('when a named route is pushed, it should render the configured route', (tester) async {
      await tester.pumpWidget(
        MateoApp(
          title: 'Test App',
          theme: _lightTheme(),
          home: Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () => Navigator.pushNamed(context, '/details'),
                child: const Text('Open details'),
              ),
            ),
          ),
          routes: {'/details': (_) => const Scaffold(body: Text('Details'))},
        ),
      );

      await tester.tap(find.text('Open details'));
      await tester.pumpAndSettle();

      expect(find.text('Details'), findsOneWidget);
    });

    testWidgets('when showing a toast from home, it should show the message', (tester) async {
      late BuildContext homeContext;

      await tester.pumpWidget(
        MateoApp(
          title: 'Test App',
          theme: _lightTheme(),
          home: Builder(
            builder: (context) {
              homeContext = context;
              return const Scaffold(body: SizedBox.shrink());
            },
          ),
        ),
      );

      MateoToast.show(homeContext, message: 'Hello from MateoApp', presentation: .error());
      await tester.pump();

      expect(find.text('Hello from MateoApp'), findsOneWidget);
    });
  });

  group('MateoApp.router', () {
    testWidgets('when configured with a theme, it should render the child widget', (tester) async {
      await tester.pumpWidget(
        MateoApp.router(
          title: 'Test App',
          theme: _lightTheme(),
          routerConfig: _createConfig(),
        ),
      );

      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('when adaptive under light brightness, it should use the light appearance', (tester) async {
      tester.binding.platformDispatcher.platformBrightnessTestValue = Brightness.light;
      addTearDown(tester.binding.platformDispatcher.clearPlatformBrightnessTestValue);
      final configuration = MateoTheme.adaptive(
        accentColor: const Color(0xFF4A5CFF),
        onAccent: const Color(0xFFFFFFFF),
      );

      await tester.pumpWidget(
        MateoApp.router(
          title: 'Test App',
          theme: configuration,
          routerConfig: _createConfig(),
        ),
      );

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      final context = tester.element(find.byType(MateoToastMessenger));

      expect(materialApp.themeMode, ThemeMode.system);
      expect(Theme.of(context).brightness, Brightness.light);
    });

    testWidgets('when adaptive under dark brightness, it should select the current light fallback branch', (
      tester,
    ) async {
      tester.binding.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
      addTearDown(tester.binding.platformDispatcher.clearPlatformBrightnessTestValue);
      final configuration = MateoTheme.adaptive(
        accentColor: const Color(0xFF4A5CFF),
        onAccent: const Color(0xFFFFFFFF),
      );

      await tester.pumpWidget(
        MateoApp.router(
          title: 'Test App',
          theme: configuration,
          routerConfig: _createConfig(),
        ),
      );

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      final context = tester.element(find.byType(MateoToastMessenger));

      expect(materialApp.darkTheme, same(configuration.darkTheme));
      expect(materialApp.themeMode, ThemeMode.system);
      expect(Theme.of(context).brightness, Brightness.light);
    });

    testWidgets('when configured with a builder, it should auto-inject the MateoToastMessenger', (tester) async {
      await tester.pumpWidget(
        MateoApp.router(
          title: 'Test App',
          theme: _lightTheme(),
          routerConfig: _createConfig(),
          builder: (context, child) => child ?? const SizedBox.shrink(),
        ),
      );

      expect(find.byType(MateoToastMessenger), findsOneWidget);
    });

    testWidgets('when inside the router, it should find the MateoToastMessenger via context lookup', (tester) async {
      late BuildContext routerContext;

      await tester.pumpWidget(
        MateoApp.router(
          title: 'Test App',
          theme: _lightTheme(),
          routerConfig: _createConfig(
            onBuild: (context) {
              routerContext = context;
            },
          ),
        ),
      );

      expect(MateoToastMessenger.maybeOf(routerContext), isNotNull);
    });

    testWidgets('when showing a toast from inside the router, it should find the messenger and show the message', (
      tester,
    ) async {
      late BuildContext routerContext;

      await tester.pumpWidget(
        MateoApp.router(
          title: 'Test App',
          theme: _lightTheme(),
          routerConfig: _createConfig(
            onBuild: (context) {
              routerContext = context;
            },
          ),
        ),
      );

      MateoToast.show(routerContext, message: 'Hello from MateoApp', presentation: .error());
      await tester.pump();

      expect(find.text('Hello from MateoApp'), findsOneWidget);
    });
  });
}
