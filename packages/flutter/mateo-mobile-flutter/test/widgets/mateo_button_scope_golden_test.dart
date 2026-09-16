import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:mateo_mobile_old/mateo_mobile_old.dart';
import 'package:mateo_mobile_old/src/components/mateo_button/mateo_button.dart' show MateoButton, MateoButtonScope;

import '../test_app.dart';

void main() {
  goldenTest(
    'when rendering a custom background, it should match the approved golden',
    fileName: 'mateo_button_custom_background',
    builder: () => MateoButtonScope(
      backgroundBuilder: (state, child) => DecoratedBox(
        decoration: BoxDecoration(
          color: state.backgroundColor,
          border: Border.all(color: mateoTestColorScheme.text.primary, width: 2),
          borderRadius: state.borderRadius,
        ),
        child: child,
      ),
      child: MateoButton(
        presentation: MateoButtonPresentation.label(
          variant: MateoButtonVariant.primary,
          label: 'Continue',
        ),
        onPressed: () {},
      ),
    ),
  );
}
