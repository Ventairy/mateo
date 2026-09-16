part of 'mateo_grouped_list.dart';

/// A consumer-authored row displayed inside a [MateoGroupedList].
///
/// The row reserves a fixed leading slot and applies Mateo's grouped-row text,
/// spacing, and press feedback. [description] occupies no space when omitted,
/// and [onPressed] may be omitted for a non-interactive item.
class MateoGroupedListRow extends StatelessWidget {
  /// Creates a grouped-list row.
  const MateoGroupedListRow({
    required this.leading,
    required this.title,
    super.key,
    this.description,
    this.onPressed,
  }) : assert(title != '', 'title must not be empty.'),
       assert(
         description == null || description != '',
         'description must be null or non-empty.',
       );

  static const _horizontalPadding = 18.0;
  static const _verticalPadding = 18.0;
  static const _leadingExtent = 42.0;
  static const _leadingTextGap = 12.0;
  static const _textGap = 2.0;

  /// Widget centered in the fixed leading slot.
  final Widget leading;

  /// Primary one-line row label.
  final String title;

  /// Optional supporting text displayed on up to two lines.
  final String? description;

  /// Handles an optional row press.
  ///
  /// The callback receives a future that completes with the row's release
  /// feedback. Await it before navigation or another disruptive operation.
  final MateoGroupedListRowCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final textColorScheme = context.mateo.colorScheme.text;
    final content = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: _horizontalPadding,
        vertical: _verticalPadding,
      ),
      child: Row(
        children: [
          SizedBox.square(
            dimension: _leadingExtent,
            child: Center(child: leading),
          ),
          const SizedBox(width: _leadingTextGap),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    fontFamily: MateoTypography.fontFamily,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: MateoTypography.letterSpacing,
                    height: 1.25,
                    color: textColorScheme.primary,
                  ),
                ),
                if (description case final description?) ...[
                  const SizedBox(height: _textGap),
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      decoration: TextDecoration.none,
                      fontFamily: MateoTypography.fontFamily,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      letterSpacing: MateoTypography.letterSpacing,
                      height: 1.3,
                      color: textColorScheme.secondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );

    final onPressed = this.onPressed;
    if (onPressed == null) return content;
    return MateoTap(
      semanticLabel: description == null ? title : '$title, $description',
      onPressed: onPressed,
      child: content,
    );
  }
}
