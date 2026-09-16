import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile_old/mateo_mobile_old.dart';

void main() {
  group('MateoHeaderPresentation', () {
    test('when one presentation mode is reconfigured, it should update its concrete widget in place', () {
      expect(
        Widget.canUpdate(
          const MateoHeaderPresentation.view(title: Text('First')),
          const MateoHeaderPresentation.view(title: Text('Second'), centerTitle: true),
        ),
        isTrue,
      );
      expect(
        Widget.canUpdate(
          const MateoHeaderPresentation.standalone(title: Text('First')),
          const MateoHeaderPresentation.standalone(title: Text('Second'), padding: EdgeInsets.zero),
        ),
        isTrue,
      );
    });

    test('when the presentation mode changes, it should replace the concrete visual implementation', () {
      expect(
        Widget.canUpdate(
          const MateoHeaderPresentation.view(title: Text('Header')),
          const MateoHeaderPresentation.standalone(title: Text('Header')),
        ),
        isFalse,
      );
    });

    test('when controllers change within one mode, it should keep the concrete presentation mounted', () {
      final firstController = ScrollController();
      final secondController = ScrollController();
      addTearDown(firstController.dispose);
      addTearDown(secondController.dispose);

      expect(
        Widget.canUpdate(
          MateoHeaderPresentation.view(
            title: const Text('Header'),
            scrollController: firstController,
          ),
          MateoHeaderPresentation.view(
            title: const Text('Header'),
            scrollController: secondController,
          ),
        ),
        isTrue,
      );
    });
  });
}
