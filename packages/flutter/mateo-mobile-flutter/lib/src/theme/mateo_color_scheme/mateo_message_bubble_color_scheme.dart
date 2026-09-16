part of 'mateo_color_scheme.dart';

/// Semantic colors for Mateo message bubbles.
@immutable
class MateoMessageBubbleColorScheme {
  /// Creates the complete color contract for Mateo message bubbles.
  const MateoMessageBubbleColorScheme({
    required this.incoming,
    required this.outgoing,
    required this.typingIndicator,
  });

  /// {@macro mateo_color_scheme_lerp}
  factory MateoMessageBubbleColorScheme.lerp(
    MateoMessageBubbleColorScheme a,
    MateoMessageBubbleColorScheme b,
    double t,
  ) => MateoMessageBubbleColorScheme(
    incoming: MateoColorVariantColorScheme.lerp(a.incoming, b.incoming, t),
    outgoing: MateoColorVariantColorScheme.lerp(a.outgoing, b.outgoing, t),
    typingIndicator: Color.lerp(a.typingIndicator, b.typingIndicator, t)!,
  );

  /// Colors used by incoming message bubbles.
  final MateoColorVariantColorScheme incoming;

  /// Colors used by outgoing message bubbles.
  final MateoColorVariantColorScheme outgoing;

  /// Foreground color used by the typing indicator.
  final Color typingIndicator;

  /// {@macro mateo_color_scheme_copy_with}
  MateoMessageBubbleColorScheme copyWith({
    MateoColorVariantColorScheme? incoming,
    MateoColorVariantColorScheme? outgoing,
    Color? typingIndicator,
  }) => MateoMessageBubbleColorScheme(
    incoming: incoming ?? this.incoming,
    outgoing: outgoing ?? this.outgoing,
    typingIndicator: typingIndicator ?? this.typingIndicator,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MateoMessageBubbleColorScheme &&
          incoming == other.incoming &&
          outgoing == other.outgoing &&
          typingIndicator == other.typingIndicator;

  @override
  int get hashCode => Object.hash(incoming, outgoing, typingIndicator);
}
