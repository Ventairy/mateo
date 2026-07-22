import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

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
  RouteInformation restoreRouteInformation(Object configuration) =>
      _rootRouteInformation;
}

RouterConfig<Object> _createConfig({void Function(BuildContext)? onBuild}) {
  return RouterConfig<Object>(
    routeInformationParser: _TestRouteInformationParser(),
    routerDelegate: _TestRouterDelegate(onBuild: onBuild),
    routeInformationProvider: PlatformRouteInformationProvider(
      initialRouteInformation:
          _TestRouteInformationParser._rootRouteInformation,
    ),
  );
}

void main() {
  group('MateoApp', () {
    testWidgets(
      'when configured with home, it should render without a router',
      (tester) async {
        await tester.pumpWidget(
          MateoApp(
            title: 'Test App',
            color: (
              primary: mateoTestColorScheme.buttons.success.background,
              onPrimary: mateoTestColorScheme.text.inverse,
            ),
            home: Scaffold(body: Text('Home')),
          ),
        );

        final messengerContext = tester.element(
          find.byType(MateoToastMessenger),
        );
        final mateoTheme = Theme.of(
          messengerContext,
        ).extension<MateoThemeData>()!;
        final expectedPalette = MateoPalette(
          primaryColor: mateoTestColorScheme.buttons.success.background,
        );

        expect(find.text('Home'), findsOneWidget);
        expect(find.byType(Navigator), findsOneWidget);
        expect(find.byType(MateoToastMessenger), findsOneWidget);
        expect(mateoTheme.palette.primary[9], expectedPalette.primary[9]);
        expect(
          mateoTheme.colorScheme.buttons.primary.foreground,
          mateoTestColorScheme.text.inverse,
        );
      },
    );

    testWidgets(
      'when a named route is pushed, it should render the configured route',
      (tester) async {
        await tester.pumpWidget(
          MateoApp(
            title: 'Test App',
            color: (
              primary: mateoTestColorScheme.buttons.danger.background,
              onPrimary: mateoTestColorScheme.background,
            ),
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
      },
    );

    testWidgets('when showing a toast from home, it should show the message', (
      tester,
    ) async {
      late BuildContext homeContext;

      await tester.pumpWidget(
        MateoApp(
          title: 'Test App',
          color: (
            primary: mateoTestColorScheme.buttons.danger.background,
            onPrimary: mateoTestColorScheme.background,
          ),
          home: Builder(
            builder: (context) {
              homeContext = context;
              return const Scaffold(body: SizedBox.shrink());
            },
          ),
        ),
      );

      MateoToast.show(homeContext, message: 'Hello from MateoApp');
      await tester.pump();

      expect(find.text('Hello from MateoApp'), findsOneWidget);
    });
  });

  group('MateoApp.router', () {
    testWidgets(
      'when configured with a color, it should render the child widget',
      (tester) async {
        await tester.pumpWidget(
          MateoApp.router(
            title: 'Test App',
            color: (
              primary: mateoTestColorScheme.buttons.danger.background,
              onPrimary: mateoTestColorScheme.background,
            ),
            routerConfig: _createConfig(),
          ),
        );

        expect(find.byType(MaterialApp), findsOneWidget);
      },
    );

    testWidgets(
      'when configured with a color, it should apply the Mateo Mobile palette from the given primary',
      (tester) async {
        await tester.pumpWidget(
          MateoApp.router(
            title: 'Test App',
            color: (
              primary: mateoTestColorScheme.buttons.success.background,
              onPrimary: mateoTestColorScheme.text.inverse,
            ),
            routerConfig: _createConfig(),
            builder: (context, child) => child ?? const SizedBox.shrink(),
          ),
        );

        final messengerContext = tester.element(
          find.byType(MateoToastMessenger),
        );
        final mateoTheme = Theme.of(
          messengerContext,
        ).extension<MateoThemeData>()!;
        final expectedPalette = MateoPalette(
          primaryColor: mateoTestColorScheme.buttons.success.background,
        );

        expect(
          mateoTheme.palette.primary[9],
          equals(expectedPalette.primary[9]),
        );
        expect(
          mateoTheme.colorScheme.buttons.primary.foreground,
          mateoTestColorScheme.text.inverse,
        );
      },
    );

    testWidgets(
      'when configured with a builder, it should auto-inject the MateoToastMessenger',
      (tester) async {
        await tester.pumpWidget(
          MateoApp.router(
            title: 'Test App',
            color: (
              primary: mateoTestColorScheme.buttons.danger.background,
              onPrimary: mateoTestColorScheme.background,
            ),
            routerConfig: _createConfig(),
            builder: (context, child) => child ?? const SizedBox.shrink(),
          ),
        );

        expect(find.byType(MateoToastMessenger), findsOneWidget);
      },
    );

    testWidgets(
      'when inside the router, it should find the MateoToastMessenger via context lookup',
      (tester) async {
        late BuildContext routerContext;

        await tester.pumpWidget(
          MateoApp.router(
            title: 'Test App',
            color: (
              primary: mateoTestColorScheme.buttons.danger.background,
              onPrimary: mateoTestColorScheme.background,
            ),
            routerConfig: _createConfig(
              onBuild: (context) {
                routerContext = context;
              },
            ),
          ),
        );

        final messenger = MateoToastMessenger.maybeOf(routerContext);

        expect(messenger, isNotNull);
      },
    );

    testWidgets(
      'when showing a toast from inside the router, it should find the messenger and show the message',
      (tester) async {
        late BuildContext routerContext;

        await tester.pumpWidget(
          MateoApp.router(
            title: 'Test App',
            color: (
              primary: mateoTestColorScheme.buttons.danger.background,
              onPrimary: mateoTestColorScheme.background,
            ),
            routerConfig: _createConfig(
              onBuild: (context) {
                routerContext = context;
              },
            ),
          ),
        );

        MateoToast.show(routerContext, message: 'Hello from MateoApp');
        await tester.pump();

        expect(find.text('Hello from MateoApp'), findsOneWidget);
      },
    );
  });
}
