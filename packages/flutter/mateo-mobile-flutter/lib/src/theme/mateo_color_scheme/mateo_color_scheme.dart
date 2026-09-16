/// Semantic color contract for Mateo Mobile.
library;

import 'package:flutter/material.dart';

import '../mateo_palette/mateo_palette.dart';

part 'mateo_sheet_color_scheme.dart';
part 'mateo_button_color_scheme.dart';
part 'mateo_primary_button_color_scheme.dart';
part 'mateo_secondary_button_color_scheme.dart';
part 'mateo_tertiary_button_color_scheme.dart';
part 'mateo_buttons_color_scheme.dart';
part 'mateo_character_counter_color_scheme.dart';
part 'mateo_character_counter_variant_color_scheme.dart';
part 'mateo_color_scheme_light.dart';
part 'mateo_color_variant_color_scheme.dart';
part 'mateo_controls_color_scheme.dart';
part 'mateo_inverse_color_scheme.dart';
part 'mateo_menu_color_scheme.dart';
part 'mateo_menus_color_scheme.dart';
part 'mateo_message_bubble_color_scheme.dart';
part 'mateo_overlay_color_scheme.dart';
part 'mateo_select_color_scheme.dart';
part 'mateo_select_variant_color_scheme.dart';
part 'mateo_skeleton_color_scheme.dart';
part 'mateo_text_color_scheme.dart';
part 'mateo_text_field_color_scheme.dart';
part 'mateo_text_field_variant_color_scheme.dart';
part 'mateo_toast_color_scheme.dart';
part 'mateo_toggle_color_scheme.dart';

/// {@template mateo_color_scheme_copy_with}
/// Returns a copy with the supplied values replaced.
/// {@endtemplate}
///
/// {@template mateo_color_scheme_lerp}
/// Interpolates every color role between `a` and `b`.
/// {@endtemplate}
///
/// Semantic colors used by Mateo Mobile components.
///
/// Use [MateoColorScheme.light] to build the scheme from a [MateoPalette]. Raw
/// palette scales remain separate from this component-oriented contract.
@immutable
class MateoColorScheme {
  /// Creates a complete Mateo Mobile color scheme.
  const MateoColorScheme({
    required this.background,
    required this.text,
    required this.buttons,
    required this.overlay,
    required this.sheet,
    required this.toast,
    required this.skeleton,
    required this.inverse,
    required this.controls,
    required this.toggle,
    required this.messageBubble,
    required this.menu,
    required this.characterCounter,
    required this.textField,
    required this.select,
  });

  /// {@macro mateo_color_scheme_lerp}
  factory MateoColorScheme.lerp(
    MateoColorScheme a,
    MateoColorScheme b,
    double t,
  ) => MateoColorScheme(
    background: Color.lerp(a.background, b.background, t)!,
    text: MateoTextColorScheme.lerp(a.text, b.text, t),
    buttons: MateoButtonsColorScheme.lerp(a.buttons, b.buttons, t),
    overlay: MateoOverlayColorScheme.lerp(a.overlay, b.overlay, t),
    sheet: MateoSheetColorScheme.lerp(
      a.sheet,
      b.sheet,
      t,
    ),
    toast: MateoToastColorScheme.lerp(a.toast, b.toast, t),
    skeleton: MateoSkeletonColorScheme.lerp(a.skeleton, b.skeleton, t),
    inverse: MateoInverseColorScheme.lerp(a.inverse, b.inverse, t),
    controls: MateoControlsColorScheme.lerp(a.controls, b.controls, t),
    toggle: MateoToggleColorScheme.lerp(a.toggle, b.toggle, t),
    messageBubble: MateoMessageBubbleColorScheme.lerp(
      a.messageBubble,
      b.messageBubble,
      t,
    ),
    menu: MateoMenusColorScheme.lerp(
      a.menu,
      b.menu,
      t,
    ),
    characterCounter: MateoCharacterCounterColorScheme.lerp(a.characterCounter, b.characterCounter, t),
    textField: MateoTextFieldColorScheme.lerp(a.textField, b.textField, t),
    select: MateoSelectColorScheme.lerp(a.select, b.select, t),
  );

  /// Creates Mateo's light color scheme.
  ///
  /// [onAccent] is a package-only input used as the foreground on accent
  /// component surfaces. It is supplied by the consuming app rather than the
  /// platform-independent Mateo color scheme.
  factory MateoColorScheme.light({MateoPalette? palette, Color? onAccent}) => _LightMateoColorScheme(
    palette: palette ?? MateoPalette(),
    onAccent: onAccent ?? Colors.white,
  );

  /// App background.
  final Color background;

  /// Shared text colors.
  final MateoTextColorScheme text;

  /// Button component colors.
  final MateoButtonsColorScheme buttons;

  /// Overlay colors.
  final MateoOverlayColorScheme overlay;

  /// Sheet colors.
  final MateoSheetColorScheme sheet;

  /// Toast colors grouped by message type.
  final MateoToastColorScheme toast;

  /// Skeleton and shimmer colors.
  final MateoSkeletonColorScheme skeleton;

  /// Inverse-surface colors.
  final MateoInverseColorScheme inverse;

  /// Control colors.
  final MateoControlsColorScheme controls;

  /// Toggle component colors.
  final MateoToggleColorScheme toggle;

  /// Message-bubble colors grouped by direction.
  final MateoMessageBubbleColorScheme messageBubble;

  /// Shared menu colors, independent of the application appearance.
  final MateoMenusColorScheme menu;

  /// Character-counter colors grouped by variant.
  final MateoCharacterCounterColorScheme characterCounter;

  /// Text-field colors grouped by variant.
  final MateoTextFieldColorScheme textField;

  /// Select colors grouped by variant.
  final MateoSelectColorScheme select;

  /// {@macro mateo_color_scheme_copy_with}
  MateoColorScheme copyWith({
    Color? background,
    MateoTextColorScheme? text,
    MateoButtonsColorScheme? buttons,
    MateoOverlayColorScheme? overlay,
    MateoSheetColorScheme? sheet,
    MateoToastColorScheme? toast,
    MateoSkeletonColorScheme? skeleton,
    MateoInverseColorScheme? inverse,
    MateoControlsColorScheme? controls,
    MateoToggleColorScheme? toggle,
    MateoMessageBubbleColorScheme? messageBubble,
    MateoMenusColorScheme? menu,
    MateoCharacterCounterColorScheme? characterCounter,
    MateoTextFieldColorScheme? textField,
    MateoSelectColorScheme? select,
  }) => MateoColorScheme(
    background: background ?? this.background,
    text: text ?? this.text,
    buttons: buttons ?? this.buttons,
    overlay: overlay ?? this.overlay,
    sheet: sheet ?? this.sheet,
    toast: toast ?? this.toast,
    skeleton: skeleton ?? this.skeleton,
    inverse: inverse ?? this.inverse,
    controls: controls ?? this.controls,
    toggle: toggle ?? this.toggle,
    messageBubble: messageBubble ?? this.messageBubble,
    menu: menu ?? this.menu,
    characterCounter: characterCounter ?? this.characterCounter,
    textField: textField ?? this.textField,
    select: select ?? this.select,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MateoColorScheme &&
          background == other.background &&
          text == other.text &&
          buttons == other.buttons &&
          overlay == other.overlay &&
          sheet == other.sheet &&
          toast == other.toast &&
          skeleton == other.skeleton &&
          inverse == other.inverse &&
          controls == other.controls &&
          toggle == other.toggle &&
          messageBubble == other.messageBubble &&
          menu == other.menu &&
          characterCounter == other.characterCounter &&
          textField == other.textField &&
          select == other.select;

  @override
  int get hashCode => Object.hashAll([
    background,
    text,
    buttons,

    overlay,
    sheet,
    toast,
    skeleton,
    inverse,
    controls,
    toggle,
    messageBubble,

    menu,
    characterCounter,
    textField,
    select,
  ]);
}
