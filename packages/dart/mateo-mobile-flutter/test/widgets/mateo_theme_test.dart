import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile/mateo_mobile.dart';

void main() {
  test('when using bundled typography, it should resolve the current package font', () {
    expect(MateoTypography.fontFamily, 'packages/mateo_mobile/Inter');
  });

  final theme = MateoThemeData.light(accentColor: const Color(0xFF4A5CFF), onAccent: MateoPalette().white);

  testWidgets('when no scope exists, it should return null or explain the missing ancestor', (tester) async {
    await tester.pumpWidget(
      Builder(
        builder: (context) {
          expect(MateoTheme.maybeOf(context), isNull);
          expect(
            () => MateoTheme.of(context),
            throwsA(
              isA<FlutterError>().having(
                (error) => error.toString(),
                'message',
                contains('Wrap this subtree in MateoTheme'),
              ),
            ),
          );
          return const SizedBox.shrink();
        },
      ),
    );
  });

  testWidgets('when scopes nest without Material, it should resolve the nearest theme', (tester) async {
    final nested = theme.copyWith(accentColor: const Color(0xFF00A86B));
    final observed = <MateoThemeData>[];
    await tester.pumpWidget(
      MateoTheme(
        data: theme,
        child: Builder(
          builder: (context) {
            observed.add(MateoTheme.of(context));
            return MateoTheme(
              data: nested,
              child: Builder(
                builder: (context) {
                  observed.add(MateoTheme.of(context));
                  return const SizedBox.shrink();
                },
              ),
            );
          },
        ),
      ),
    );
    expect(observed, [theme, nested]);
    expect(tester.takeException(), isNull);
  });

  testWidgets('when theme data changes, it should notify dependents immediately and skip equal values', (tester) async {
    var builds = 0;
    MateoThemeData? observed;
    final child = Builder(
      builder: (context) {
        builds++;
        observed = MateoTheme.of(context);
        return const SizedBox.shrink();
      },
    );
    await tester.pumpWidget(MateoTheme(data: theme, child: child));
    expect(builds, 1);
    await tester.pumpWidget(MateoTheme(data: theme.copyWith(), child: child));
    expect(builds, 1);
    final changed = theme.copyWith(onAccent: MateoPalette().black);
    await tester.pumpWidget(MateoTheme(data: changed, child: child));
    expect(builds, 2);
    expect(observed, changed);
    expect(tester.binding.hasScheduledFrame, isFalse);
    final newAccent = changed.copyWith(accentColor: const Color(0xFF00A86B));
    await tester.pumpWidget(MateoTheme(data: newAccent, child: child));
    expect(builds, 3);
    expect(observed, newAccent);
  });

  testWidgets('when inheriting typography, it should apply Mateo primitives and preserve layout settings', (
    tester,
  ) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: .ltr,
        child: DefaultTextStyle(
          style: const TextStyle(
            fontFamily: 'Other',
            fontSize: 23,
            height: 1.4,
            fontWeight: .w600,
            letterSpacing: 2,
            color: Color(0xFFFF0000),
          ),
          textAlign: .right,
          maxLines: 2,
          overflow: .ellipsis,
          child: MateoTheme(
            data: theme,
            child: Builder(
              builder: (context) {
                final inherited = DefaultTextStyle.of(context);
                expect(inherited.style.fontFamily, MateoTypography.fontFamily);
                expect(inherited.style.letterSpacing, -0.2);
                expect(inherited.style.color, theme.colorScheme.text.primary);
                expect(inherited.style.fontSize, 23);
                expect(inherited.style.height, 1.4);
                expect(inherited.style.fontWeight, FontWeight.w600);
                expect(inherited.textAlign, TextAlign.right);
                expect(inherited.maxLines, 2);
                expect(inherited.overflow, TextOverflow.ellipsis);
                return const Text('Mateo');
              },
            ),
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('when descendants override typography, it should honor their explicit styles', (tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: .ltr,
        child: MateoTheme(
          data: theme,
          child: DefaultTextStyle.merge(
            style: const TextStyle(fontFamily: 'Custom', letterSpacing: 1, color: Color(0xFF123456)),
            child: Builder(
              builder: (context) {
                final style = DefaultTextStyle.of(context).style;
                expect(style.fontFamily, 'Custom');
                expect(style.letterSpacing, 1);
                expect(style.color, const Color(0xFF123456));
                return const Text('Custom');
              },
            ),
          ),
        ),
      ),
    );
  });
}
