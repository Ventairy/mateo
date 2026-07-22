import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

void main() {
  group('MateoHeroPage', () {
    testWidgets(
      'when creating a route from MateoHeroPage, it should return a MateoHeroPageRoute',
      (tester) async {
        MateoHeroPageRoute? capturedRoute;

        await tester.pumpWidget(
          _PageTestApp(
            onRouteCreated: (route) {
              capturedRoute = route;
            },
          ),
        );

        await tester.tap(find.text('Push'));
        await tester.pumpAndSettle();

        expect(capturedRoute, isA<MateoHeroPageRoute>());
      },
    );

    testWidgets(
      'when custom transition duration is set, it should use the custom value',
      (tester) async {
        const customDuration = Duration(milliseconds: 300);
        MateoHeroPageRoute? capturedRoute;

        await tester.pumpWidget(
          _PageTestApp(
            customTransitionDuration: customDuration,
            onRouteCreated: (route) {
              capturedRoute = route;
            },
          ),
        );

        await tester.tap(find.text('Push'));
        await tester.pumpAndSettle();

        expect(capturedRoute!.transitionDuration, equals(customDuration));
      },
    );

    testWidgets(
      'when custom reverse transition duration is set, it should use the custom value',
      (tester) async {
        const customDuration = Duration(milliseconds: 200);
        MateoHeroPageRoute? capturedRoute;

        await tester.pumpWidget(
          _PageTestApp(
            customReverseTransitionDuration: customDuration,
            onRouteCreated: (route) {
              capturedRoute = route;
            },
          ),
        );

        await tester.tap(find.text('Push'));
        await tester.pumpAndSettle();

        expect(
          capturedRoute!.reverseTransitionDuration,
          equals(customDuration),
        );
      },
    );
  });
}

class _PageTestApp extends StatelessWidget {
  const _PageTestApp({
    this.customTransitionDuration,
    this.customReverseTransitionDuration,
    this.onRouteCreated,
  });

  final Duration? customTransitionDuration;
  final Duration? customReverseTransitionDuration;
  final void Function(MateoHeroPageRoute route)? onRouteCreated;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (context) {
          return Scaffold(
            body: Center(
              child: TextButton(
                onPressed: () {
                  final page = MateoHeroPage(
                    builder: (_) => const SizedBox(),
                    transitionDuration:
                        customTransitionDuration ??
                        const Duration(milliseconds: 560),
                    reverseTransitionDuration:
                        customReverseTransitionDuration ??
                        const Duration(milliseconds: 430),
                  );
                  final createdRoute =
                      page.createRoute(context) as MateoHeroPageRoute;
                  onRouteCreated?.call(createdRoute);
                  unawaited(Navigator.of(context).push(createdRoute));
                },
                child: const Text('Push'),
              ),
            ),
          );
        },
      ),
    );
  }
}
