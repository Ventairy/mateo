import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile_old/mateo_mobile_old.dart';

import '../test_app.dart';

void main() {
  test('when label factories are const, they should retain shared choices and update in place', () {
    const first = MateoButtonPresentation.label(label: 'Continue', variant: MateoButtonVariant.primary);
    const second = MateoButtonPresentation.label(label: 'Continue', variant: MateoButtonVariant.primary);
    expect(Widget.canUpdate(first, second), isTrue);
    expect(first.variant, MateoButtonVariant.primary);
    expect(first.colorScheme, isNull);
  });

  test('when label inputs change, they should remain the same presentation type', () {
    Widget icon(MateoButtonState state) => Icon(Icons.add, color: state.foregroundColor);
    MateoButtonPresentation make({
      String label = 'Action',
      MateoButtonVariant variant = MateoButtonVariant.primary,
      MateoButtonColorScheme? colorScheme,
      MateoButtonIconBuilder? leading,
      MateoButtonIconBuilder? trailing,
      MateoButtonAlignment alignment = MateoButtonAlignment.center,
      MateoButtonFit fit = MateoButtonFit.fit,
      EdgeInsetsGeometry? padding,
    }) => MateoButtonPresentation.label(
      label: label,
      variant: variant,
      colorScheme: colorScheme,
      leadingIconBuilder: leading,
      trailingIconBuilder: trailing,
      alignment: alignment,
      fit: fit,
      padding: padding,
    );
    final original = make();
    expect(Widget.canUpdate(original, make()), isTrue);
    for (final changed in [
      make(label: 'Next'),
      make(variant: MateoButtonVariant.secondary),
      make(colorScheme: mateoTestColorScheme.buttons.primary.neutral),
      make(leading: icon),
      make(trailing: icon),
      make(alignment: MateoButtonAlignment.right),
      make(fit: MateoButtonFit.expand),
      make(padding: EdgeInsets.zero),
    ]) {
      expect(Widget.canUpdate(original, changed), isTrue);
    }
  });
}
