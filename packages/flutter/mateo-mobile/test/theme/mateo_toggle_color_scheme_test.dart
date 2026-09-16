import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

void main() {
  final theme = MateoThemeData.light(accentColor: const Color(0xFF4A5CFF), onAccent: MateoPalette().white);
  test('when resolving toggle colors, it should retain the authored semantic roles', () {
    final colors = theme.colorScheme.toggle;
    expect(colors.trackOn, theme.palette.accent[9]);
    expect(colors.trackOff, theme.palette.neutral[3]);
    expect(colors.trackDisabled, theme.palette.neutral[4]);
    expect(colors.thumbOn, theme.palette.neutral[1]);
    expect(colors.thumbOff, theme.palette.neutral[1]);
    expect(colors.thumbDisabled, theme.palette.neutral[8]);
    expect(colors, theme.copyWith().colorScheme.toggle);
    expect(colors.hashCode, theme.copyWith().colorScheme.toggle.hashCode);
    final changed = theme.copyWith(accentColor: const Color(0xFFCC4422));
    expect(changed.colorScheme.toggle.trackOn, changed.palette.accent[9]);
    expect(changed.colorScheme.toggle, isNot(colors));
    expect(MateoColorScheme.dark(palette: theme.palette, onAccent: theme.colorScheme.onAccent).toggle, colors);
  });
}
