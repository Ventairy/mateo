import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateo_mobile_old/mateo_mobile_old.dart';

void main() {
  group('MateoMessageBubbleColorScheme', () {
    const scheme = MateoMessageBubbleColorScheme(
      incoming: MateoColorVariantColorScheme(
        solid: Color(0xFFF5F5F5),
        onSolid: Color(0xFF181818),
      ),
      outgoing: MateoColorVariantColorScheme(
        solid: Color(0xFFE5EAFA),
        onSolid: Color(0xFF0C123E),
      ),
      typingIndicator: Color(0xFF737373),
    );

    test('when created, it should expose both direction roles', () {
      expect(scheme.incoming.solid, const Color(0xFFF5F5F5));
      expect(scheme.incoming.onSolid, const Color(0xFF181818));
      expect(scheme.outgoing.solid, const Color(0xFFE5EAFA));
      expect(scheme.outgoing.onSolid, const Color(0xFF0C123E));
      expect(scheme.typingIndicator, const Color(0xFF737373));
    });

    test('when copied, it should replace only supplied roles', () {
      const replacement = MateoColorVariantColorScheme(
        solid: Colors.orange,
        onSolid: Colors.black,
      );
      final copied = scheme.copyWith(outgoing: replacement);

      expect(copied.incoming, scheme.incoming);
      expect(copied.outgoing, replacement);
      expect(copied.typingIndicator, scheme.typingIndicator);
      expect(scheme.copyWith(), scheme);
      expect(scheme.copyWith().hashCode, scheme.hashCode);
    });

    test('when any role changes, it should no longer be equal', () {
      final changedIncoming = scheme.copyWith(
        incoming: scheme.incoming.copyWith(solid: Colors.purple),
      );
      final changedOutgoing = scheme.copyWith(
        outgoing: scheme.outgoing.copyWith(onSolid: Colors.green),
      );
      final changedTyping = scheme.copyWith(
        typingIndicator: Colors.orange,
      );

      expect(changedIncoming, isNot(equals(scheme)));
      expect(changedOutgoing, isNot(equals(scheme)));
      expect(changedTyping, isNot(equals(scheme)));
      expect(changedIncoming.hashCode, isNot(scheme.hashCode));
      expect(changedOutgoing.hashCode, isNot(scheme.hashCode));
      expect(changedTyping.hashCode, isNot(scheme.hashCode));
      expect(
        {scheme, changedIncoming, changedOutgoing, changedTyping},
        hasLength(4),
      );
    });

    test('when interpolated, it should interpolate every role', () {
      const target = MateoMessageBubbleColorScheme(
        incoming: MateoColorVariantColorScheme(
          solid: Colors.black,
          onSolid: Colors.white,
        ),
        outgoing: MateoColorVariantColorScheme(
          solid: Colors.red,
          onSolid: Colors.yellow,
        ),
        typingIndicator: Colors.blue,
      );
      final midpoint = MateoMessageBubbleColorScheme.lerp(
        scheme,
        target,
        0.5,
      );

      expect(
        midpoint.incoming.solid,
        Color.lerp(scheme.incoming.solid, target.incoming.solid, 0.5),
      );
      expect(
        midpoint.incoming.onSolid,
        Color.lerp(scheme.incoming.onSolid, target.incoming.onSolid, 0.5),
      );
      expect(
        midpoint.outgoing.solid,
        Color.lerp(scheme.outgoing.solid, target.outgoing.solid, 0.5),
      );
      expect(
        midpoint.outgoing.onSolid,
        Color.lerp(scheme.outgoing.onSolid, target.outgoing.onSolid, 0.5),
      );
      expect(
        midpoint.typingIndicator,
        Color.lerp(scheme.typingIndicator, target.typingIndicator, 0.5),
      );
    });
  });

  group('MateoColorScheme message bubble', () {
    test('when created for light mode, it should map the authored palette roles', () {
      final palette = MateoPalette();
      final colors = MateoColorScheme.light(palette: palette).messageBubble;

      expect(colors.incoming.solid, palette.neutral[3]);
      expect(colors.incoming.onSolid, palette.neutral[11]);
      expect(colors.outgoing.solid, palette.accent[9]);
      expect(colors.outgoing.onSolid, palette.neutral[1]);
      expect(colors.typingIndicator, palette.neutral[9]);
    });

    test('when copied and interpolated, it should preserve the complete contract', () {
      final source = MateoColorScheme.light();
      final replacement = source.messageBubble.copyWith(
        outgoing: source.messageBubble.outgoing.copyWith(
          solid: Colors.pink,
        ),
        typingIndicator: Colors.orange,
      );
      final target = source.copyWith(messageBubble: replacement);

      expect(source.copyWith().messageBubble, source.messageBubble);
      expect(target.messageBubble, replacement);
      expect(MateoColorScheme.lerp(source, target, 0), source);
      expect(
        MateoColorScheme.lerp(source, target, 0.5).messageBubble.outgoing.solid,
        Color.lerp(
          source.messageBubble.outgoing.solid,
          Colors.pink,
          0.5,
        ),
      );
      expect(
        MateoColorScheme.lerp(source, target, 0.5).messageBubble.typingIndicator,
        Color.lerp(
          source.messageBubble.typingIndicator,
          Colors.orange,
          0.5,
        ),
      );
    });

    test('when only the message bubble changes, parent equality should change', () {
      final source = MateoColorScheme.light();
      final changed = source.copyWith(
        messageBubble: source.messageBubble.copyWith(
          typingIndicator: Colors.orange,
        ),
      );
      final equalCopy = changed.copyWith();

      expect(changed, isNot(equals(source)));
      expect(changed.hashCode, isNot(source.hashCode));
      expect(equalCopy, changed);
      expect(equalCopy.hashCode, changed.hashCode);
      expect({source, changed}, hasLength(2));
    });
  });
}
