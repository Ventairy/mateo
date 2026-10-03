import 'package:flutter/widgets.dart';

/// Widget content for an option in a Mateo menu.
@immutable
class MateoMenuOptionsPresentationItem {
  /// Creates an option with optional content.
  const MateoMenuOptionsPresentationItem({this.leading, this.principal, this.supporting});

  /// The content preceding the principal content.
  final Widget? leading;

  /// The primary content identifying the item.
  final Widget? principal;

  /// The additional content supporting the principal content.
  final Widget? supporting;
}
