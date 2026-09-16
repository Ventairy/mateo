import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile_old/mateo_mobile_old.dart';

void main() {
  group('when constructing MateoToggleColorScheme', () {
    const scheme = MateoToggleColorScheme(
      trackOn: Colors.green,
      trackOff: Colors.grey,
      trackDisabled: Colors.black12,
      circleOn: Colors.white,
      circleOff: Colors.white70,
      circleDisabled: Colors.black38,
    );

    test('when values match, it should compare equally', () {
      expect(
        scheme,
        const MateoToggleColorScheme(
          trackOn: Colors.green,
          trackOff: Colors.grey,
          trackDisabled: Colors.black12,
          circleOn: Colors.white,
          circleOff: Colors.white70,
          circleDisabled: Colors.black38,
        ),
      );
      expect(scheme.copyWith().hashCode, scheme.hashCode);
    });

    test('when copied, it should replace only supplied values', () {
      final copied = scheme.copyWith(
        trackOn: Colors.orange,
        circleDisabled: Colors.purple,
      );

      expect(copied.trackOn, Colors.orange);
      expect(copied.trackOff, scheme.trackOff);
      expect(copied.trackDisabled, scheme.trackDisabled);
      expect(copied.circleOn, scheme.circleOn);
      expect(copied.circleOff, scheme.circleOff);
      expect(copied.circleDisabled, Colors.purple);
    });

    test('when interpolated, it should interpolate every role', () {
      const destination = MateoToggleColorScheme(
        trackOn: Colors.blue,
        trackOff: Colors.red,
        trackDisabled: Colors.yellow,
        circleOn: Colors.cyan,
        circleOff: Colors.pink,
        circleDisabled: Colors.orange,
      );
      final midpoint = MateoToggleColorScheme.lerp(
        scheme,
        destination,
        0.5,
      );

      expect(
        midpoint.trackOn,
        Color.lerp(scheme.trackOn, destination.trackOn, 0.5),
      );
      expect(
        midpoint.trackOff,
        Color.lerp(scheme.trackOff, destination.trackOff, 0.5),
      );
      expect(
        midpoint.trackDisabled,
        Color.lerp(
          scheme.trackDisabled,
          destination.trackDisabled,
          0.5,
        ),
      );
      expect(
        midpoint.circleOn,
        Color.lerp(scheme.circleOn, destination.circleOn, 0.5),
      );
      expect(
        midpoint.circleOff,
        Color.lerp(scheme.circleOff, destination.circleOff, 0.5),
      );
      expect(
        midpoint.circleDisabled,
        Color.lerp(
          scheme.circleDisabled,
          destination.circleDisabled,
          0.5,
        ),
      );
    });
  });

  test('when using the light scheme, it should map the authored palette roles', () {
    final palette = MateoPalette();
    final scheme = MateoColorScheme.light(palette: palette).toggle;

    expect(scheme.trackOn, palette.accent[9]);
    expect(scheme.trackOff, palette.neutral[3]);
    expect(scheme.trackDisabled, palette.neutral[4]);
    expect(scheme.circleOn, palette.neutral[1]);
    expect(scheme.circleOff, palette.neutral[1]);
    expect(scheme.circleDisabled, palette.neutral[8]);
  });

  test('when replacing toggle colors, the complete scheme should preserve them', () {
    final base = MateoColorScheme.light();
    final replacement = base.toggle.copyWith(
      trackOn: Colors.pink,
      circleOff: Colors.orange,
    );
    final changed = base.copyWith(toggle: replacement);

    expect(changed.toggle, replacement);
    expect(MateoColorScheme.lerp(base, changed, 0), base);
    expect(
      MateoColorScheme.lerp(base, changed, 0.5).toggle.trackOn,
      Color.lerp(base.toggle.trackOn, Colors.pink, 0.5),
    );
  });
}
