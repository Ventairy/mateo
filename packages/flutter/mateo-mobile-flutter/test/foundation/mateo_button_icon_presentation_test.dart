import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile_old/mateo_mobile_old.dart';

import '../test_app.dart';

Widget _icon(MateoIconButtonIconState state) => Icon(Icons.add, size: state.iconSize);
Widget _otherIcon(MateoIconButtonIconState state) => Icon(Icons.remove, size: state.iconSize);

void main() {
  test('when icon factories are const, they should update in place and differ from label factories', () {
    const first = MateoButtonPresentation.icon(iconBuilder: _icon, variant: MateoButtonVariant.primary);
    const second = MateoButtonPresentation.icon(iconBuilder: _icon, variant: MateoButtonVariant.primary);
    const label = MateoButtonPresentation.label(label: 'Add', variant: MateoButtonVariant.primary);
    expect(Widget.canUpdate(first, second), isTrue);
    expect(first.colorScheme, isNull);
    expect(Widget.canUpdate(first, label), isFalse);
    expect(Widget.canUpdate(label, first), isFalse);
  });

  test('when icon inputs change, they should remain the same presentation type', () {
    MateoButtonPresentation make({
      MateoIconButtonIconBuilder builder = _icon,
      MateoButtonVariant variant = MateoButtonVariant.primary,
      MateoButtonColorScheme? colorScheme,
      String? semanticLabel,
      double buttonSize = 53,
      double iconSize = 22,
      double? hitAreaSize,
    }) => MateoButtonPresentation.icon(
      iconBuilder: builder,
      variant: variant,
      colorScheme: colorScheme,
      semanticLabel: semanticLabel,
      buttonSize: buttonSize,
      iconSize: iconSize,
      hitAreaSize: hitAreaSize,
    );
    final original = make();
    for (final changed in [
      make(builder: _otherIcon),
      make(variant: MateoButtonVariant.secondary),
      make(colorScheme: mateoTestColorScheme.buttons.primary.neutral),
      make(semanticLabel: 'Add'),
      make(buttonSize: 64),
      make(iconSize: 30),
      make(hitAreaSize: 72),
    ]) {
      expect(Widget.canUpdate(original, changed), isTrue);
    }
  });

  test('when the tap target is invalid, it should reject it', () {
    for (final size in [0.0, 52.0, double.infinity, double.nan]) {
      expect(
        () => MateoButtonPresentation.icon(iconBuilder: _icon, variant: MateoButtonVariant.primary, hitAreaSize: size),
        throwsAssertionError,
      );
    }
  });

  test('when icon dimensions are invalid, it should reject them', () {
    for (final size in [0.0, -1.0, double.infinity, double.nan]) {
      expect(
        () => MateoButtonPresentation.icon(
          iconBuilder: _icon,
          semanticLabel: 'Add',
          variant: MateoButtonVariant.primary,
          buttonSize: size,
        ),
        throwsAssertionError,
      );
      expect(
        () => MateoButtonPresentation.icon(
          iconBuilder: _icon,
          semanticLabel: 'Add',
          variant: MateoButtonVariant.primary,
          iconSize: size,
        ),
        throwsAssertionError,
      );
    }
  });
}
