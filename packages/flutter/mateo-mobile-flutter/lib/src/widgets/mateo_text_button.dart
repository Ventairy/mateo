import 'package:flutter/material.dart';
import 'package:mateo_mobile/src/theme/mateo_theme_context.dart';
import 'package:mateo_mobile/src/theme/mateo_typography.dart';
import 'package:mateo_mobile/src/widgets/mateo_tap/mateo_tap.dart';

part 'mateo_text_button_types.dart';

/// A lightweight Mateo text button with optional icon support.
///
/// `MateoTextButton` renders as clickable text without Material button chrome.
/// It is intended for compact actions where the text itself is the affordance.
class MateoTextButton extends StatefulWidget {
  /// Creates a Mateo text button.
  const MateoTextButton({
    required this.text,
    super.key,
    this.onPressed,
    this.leadingIconBuilder,
    this.trailingIconBuilder,
    this.leadingIconSpacing = 4,
    this.trailingIconSpacing = 4,
    this.color,
  });

  /// Visible button label.
  final String text;

  /// Called when the button is pressed.
  ///
  /// When null, the button renders disabled and ignores pointer input.
  final VoidCallback? onPressed;

  /// Optional icon rendered before [text].
  final MateoTextButtonIconBuilder? leadingIconBuilder;

  /// Optional icon rendered after [text].
  final MateoTextButtonIconBuilder? trailingIconBuilder;

  /// Horizontal spacing between [leadingIconBuilder]'s icon and [text].
  final double leadingIconSpacing;

  /// Horizontal spacing between [text] and [trailingIconBuilder]'s icon.
  final double trailingIconSpacing;

  /// Text and matched-icon color.
  ///
  /// Defaults to `context.mateo.colors.textPrimary` when enabled and
  /// Uses the active Mateo text-button foreground, or its disabled foreground.
  final Color? color;

  @override
  State<MateoTextButton> createState() => _MateoTextButtonState();
}

class _MateoTextButtonState extends State<MateoTextButton> {
  bool get _isEnabled => widget.onPressed != null;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.mateo.colorScheme;
    final resolvedColor = _isEnabled
        ? widget.color ?? colorScheme.buttons.text.foreground
        : colorScheme.buttons.text.foregroundDisabled;

    Widget content = Text(
      widget.text,
      style: TextStyle(
        fontFamily: MateoTypography.fontFamily,
        fontSize: 17,
        fontWeight: FontWeight.w600,
        letterSpacing: MateoTypography.letterSpacing,
        color: resolvedColor,
      ),
    );

    final iconState = MateoTextButtonIconState(
      isEnabled: _isEnabled,
      recommendedIconColor: resolvedColor,
    );
    final hasLeading = widget.leadingIconBuilder != null;
    final hasTrailing = widget.trailingIconBuilder != null;

    if (hasLeading || hasTrailing) {
      final children = <Widget>[];
      if (hasLeading) {
        children.add(
          Padding(
            padding: EdgeInsets.only(right: widget.leadingIconSpacing),
            child: widget.leadingIconBuilder!(iconState),
          ),
        );
      }
      children.add(content);
      if (hasTrailing) {
        children.add(
          Padding(
            padding: EdgeInsets.only(left: widget.trailingIconSpacing),
            child: widget.trailingIconBuilder!(iconState),
          ),
        );
      }
      content = Row(mainAxisSize: MainAxisSize.min, children: children);
    }

    return Semantics(
      button: true,
      enabled: _isEnabled,
      onTap: _isEnabled ? widget.onPressed : null,
      child: MateoTap(
        onPressed: widget.onPressed != null
            ? (animation) async {
                widget.onPressed!();
              }
            : null,
        animation: MateoTapAnimationType.scaleFade,
        child: content,
      ),
    );
  }
}
