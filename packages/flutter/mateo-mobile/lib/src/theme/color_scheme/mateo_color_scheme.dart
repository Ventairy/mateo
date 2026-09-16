/// Semantic colors for Mateo appearances.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import '../palette/mateo_palette.dart';

part 'mateo_button_color_scheme.dart';
part 'mateo_buttons_color_scheme.dart';
part 'mateo_filled_text_input_color_scheme.dart';
part 'mateo_inverse_color_scheme.dart';
part 'mateo_menus_color_scheme.dart';
part 'mateo_options_menu_color_scheme.dart';
part 'mateo_primary_button_color_scheme.dart';
part 'mateo_secondary_button_color_scheme.dart';
part 'mateo_sheet_color_scheme.dart';
part 'mateo_skeleton_color_scheme.dart';
part 'mateo_text_color_scheme.dart';
part 'mateo_text_input_color_scheme.dart';
part 'mateo_text_inputs_color_scheme.dart';
part 'mateo_toast_color_scheme.dart';
part 'mateo_toast_status_color_scheme.dart';
part 'mateo_toggle_color_scheme.dart';

/// The shared and component color roles derived from a Mateo palette.
///
/// Obtain this scheme from the current theme to keep component treatments
/// consistent with the appearance.
@immutable
final class MateoColorScheme {
  /// Creates the light roles from [palette] and the supplied [onAccent].
  ///
  /// [onAccent] is preserved exactly; callers must verify contrast against
  /// their accent. This constructor does not accept individual role overrides.
  factory MateoColorScheme.light({required MateoPalette palette, required Color onAccent}) => MateoColorScheme._(
    background: palette.white,
    accent: palette.accent[9],
    onAccent: onAccent,
    buttons: ._(
      primary: ._(
        accent: .new(
          background: palette.accent[9],
          foreground: onAccent,
          backgroundDisabled: palette.neutral[4],
          foregroundDisabled: palette.neutral[9],
        ),
        neutral: .new(
          background: palette.neutral[12],
          foreground: palette.neutral[1],
          backgroundDisabled: palette.neutral[5],
          foregroundDisabled: palette.neutral[9],
        ),
        base: .new(
          background: palette.white,
          foreground: palette.black,
          backgroundDisabled: palette.neutral[4],
          foregroundDisabled: palette.neutral[9],
        ),
      ),
      secondary: ._(
        accent: .new(
          background: palette.accent[2],
          foreground: palette.accent[9],
          backgroundDisabled: palette.neutral[4],
          foregroundDisabled: palette.neutral[9],
        ),
        neutral: .new(
          background: palette.neutral[2],
          foreground: palette.neutral[12],
          backgroundDisabled: palette.neutral[5],
          foregroundDisabled: palette.neutral[9],
        ),
      ),
      tertiary: .new(
        background: const Color(0x00000000),
        foreground: palette.neutral[12],
        backgroundDisabled: const Color(0x00000000),
        foregroundDisabled: palette.neutral[9],
      ),
    ),
    menus: ._(
      options: .new(
        background: palette.black,
        leading: palette.white,
        principal: palette.white,
        supporting: palette.neutral[7],
      ),
    ),
    textInputs: ._(
      filled: ._(
        neutral: .new(
          background: palette.neutral[2],
          text: palette.black,
          placeholder: palette.neutral[7],
          icon: palette.neutral[10],
          backgroundDisabled: palette.neutral[4],
          textDisabled: palette.neutral[10],
          placeholderDisabled: palette.neutral[10],
          iconDisabled: palette.neutral[10],
        ),
        base: .new(
          background: palette.white,
          text: palette.black,
          placeholder: palette.neutral[7],
          icon: palette.neutral[9],
          backgroundDisabled: palette.neutral[4],
          textDisabled: palette.neutral[9],
          placeholderDisabled: palette.neutral[9],
          iconDisabled: palette.neutral[9],
        ),
      ),
    ),
    toast: ._(
      error: .new(background: palette.red[12], foreground: palette.white, icon: palette.red[9]),
      warning: .new(background: palette.amber[12], foreground: palette.white, icon: palette.amber[9]),
      info: .new(background: palette.blue[12], foreground: palette.white, icon: palette.blue[9]),
      success: .new(background: palette.green[12], foreground: palette.white, icon: palette.green[9]),
    ),
    toggle: .new(
      trackOn: palette.accent[9],
      trackOff: palette.neutral[4],
      trackDisabled: palette.neutral[4],
      thumbOn: palette.neutral[1],
      thumbOff: palette.neutral[1],
      thumbDisabled: palette.neutral[7],
    ),
    sheet: .new(scrim: palette.black.withValues(alpha: 0.2)),
    skeleton: .new(bone: palette.neutral[3]),
    text: ._(
      primary: palette.neutral[12],
      secondary: palette.neutral[10],
      tertiary: palette.neutral[8],
      profit: palette.green[9],
    ),
    inverse: ._(
      background: palette.neutral[12],
      onBackground: palette.white,
      accent: palette.accent[3],
    ),
  );

  /// Creates the current light fallback for requested dark roles.
  ///
  /// Passes [palette] and [onAccent] unchanged to [MateoColorScheme.light]
  /// until Mateo's dark color mappings are authored.
  factory MateoColorScheme.dark({required MateoPalette palette, required Color onAccent}) =>
      MateoColorScheme.light(palette: palette, onAccent: onAccent);

  const MateoColorScheme._({
    required this.background,
    required this.accent,
    required this.onAccent,
    required this.text,
    required this.inverse,
    required this.buttons,
    required this.menus,
    required this.textInputs,
    required this.sheet,
    required this.skeleton,
    required this.toggle,
    required this.toast,
  });

  /// The default page background.
  final Color background;

  /// The solid product accent.
  final Color accent;

  /// The supplied foreground for solid accent surfaces.
  final Color onAccent;

  /// The shared text emphasis roles.
  final MateoTextColorScheme text;

  /// The colors for surfaces that contrast with the default appearance.
  final MateoInverseColorScheme inverse;

  /// The authored button treatments.
  final MateoButtonsColorScheme buttons;

  /// The authored menu treatments.
  final MateoMenusColorScheme menus;

  /// The authored text input treatments.
  final MateoTextInputsColorScheme textInputs;

  /// The colors for sheet presentation.
  final MateoSheetColorScheme sheet;

  /// The colors for skeleton loading placeholders.
  final MateoSkeletonColorScheme skeleton;

  /// The colors for on/off controls.
  final MateoToggleColorScheme toggle;

  /// The colors for transient status messages.
  final MateoToastColorScheme toast;

  /// Whether every semantic role equals the other scheme's role.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MateoColorScheme &&
          background == other.background &&
          accent == other.accent &&
          onAccent == other.onAccent &&
          text == other.text &&
          inverse == other.inverse &&
          buttons == other.buttons &&
          menus == other.menus &&
          textInputs == other.textInputs &&
          sheet == other.sheet &&
          skeleton == other.skeleton &&
          toggle == other.toggle &&
          toast == other.toast;

  /// The hash of this scheme's semantic colors.
  @override
  int get hashCode => Object.hash(
    background,
    accent,
    onAccent,
    text,
    inverse,
    buttons,
    menus,
    textInputs,
    sheet,
    skeleton,
    toggle,
    toast,
  );
}
