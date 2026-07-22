/// Semantic color contract for Mateo Mobile.
///
/// Its roles follow the authored mobile specification in the
/// [Mateo Mobile color scheme](https://github.com/Ventairy/mateo/blob/main/design-system/mobile/color-scheme.md).
library;

import 'package:flutter/material.dart';

import '../mateo_palette/mateo_palette.dart';

part 'mateo_bottom_sheet_color_scheme.dart';
part 'mateo_branded_button_color_scheme.dart';
part 'mateo_button_color_scheme.dart';
part 'mateo_buttons_color_scheme.dart';
part 'mateo_color_scheme_light.dart';
part 'mateo_color_variant_color_scheme.dart';
part 'mateo_colors_color_scheme.dart';
part 'mateo_controls_color_scheme.dart';
part 'mateo_floating_button_color_scheme.dart';
part 'mateo_inverse_color_scheme.dart';
part 'mateo_map_color_scheme.dart';
part 'mateo_overlay_color_scheme.dart';
part 'mateo_scrollbar_color_scheme.dart';
part 'mateo_search_bar_button_color_scheme.dart';
part 'mateo_skeleton_color_scheme.dart';
part 'mateo_text_color_scheme.dart';
part 'mateo_toast_color_scheme.dart';

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
    required this.colors,
    required this.text,
    required this.selectionHighlight,
    required this.buttons,
    required this.overlay,
    required this.bottomSheet,
    required this.toast,
    required this.scrollbar,
    required this.skeleton,
    required this.inverse,
    required this.controls,
    required this.map,
  });

  /// {@macro mateo_color_scheme_lerp}
  factory MateoColorScheme.lerp(
    MateoColorScheme a,
    MateoColorScheme b,
    double t,
  ) => MateoColorScheme(
    background: Color.lerp(a.background, b.background, t)!,
    colors: MateoColorsColorScheme.lerp(a.colors, b.colors, t),
    text: MateoTextColorScheme.lerp(a.text, b.text, t),
    selectionHighlight: Color.lerp(
      a.selectionHighlight,
      b.selectionHighlight,
      t,
    )!,
    buttons: MateoButtonsColorScheme.lerp(a.buttons, b.buttons, t),
    overlay: MateoOverlayColorScheme.lerp(a.overlay, b.overlay, t),
    bottomSheet: MateoBottomSheetColorScheme.lerp(
      a.bottomSheet,
      b.bottomSheet,
      t,
    ),
    toast: MateoToastColorScheme.lerp(a.toast, b.toast, t),
    scrollbar: MateoScrollbarColorScheme.lerp(a.scrollbar, b.scrollbar, t),
    skeleton: MateoSkeletonColorScheme.lerp(a.skeleton, b.skeleton, t),
    inverse: MateoInverseColorScheme.lerp(a.inverse, b.inverse, t),
    controls: MateoControlsColorScheme.lerp(a.controls, b.controls, t),
    map: MateoMapColorScheme.lerp(a.map, b.map, t),
  );

  /// Creates Mateo's light color scheme.
  ///
  /// [onPrimary] is a package-only input used as the foreground on primary
  /// component surfaces. It is supplied by the consuming app rather than the
  /// platform-independent Mateo color scheme.
  factory MateoColorScheme.light({MateoPalette? palette, Color? onPrimary}) =>
      _LightMateoColorScheme(
        palette: palette ?? MateoPalette(),
        onPrimary: onPrimary ?? Colors.white,
      );

  /// App background.
  final Color background;

  /// Theme-authored semantic color variants.
  final MateoColorsColorScheme colors;

  /// Shared text colors.
  final MateoTextColorScheme text;

  /// Text-selection highlight.
  final Color selectionHighlight;

  /// Button component colors.
  final MateoButtonsColorScheme buttons;

  /// Overlay colors.
  final MateoOverlayColorScheme overlay;

  /// Bottom-sheet colors.
  final MateoBottomSheetColorScheme bottomSheet;

  /// Toast colors grouped by message type.
  final MateoToastColorScheme toast;

  /// Scrollbar colors.
  final MateoScrollbarColorScheme scrollbar;

  /// Skeleton and shimmer colors.
  final MateoSkeletonColorScheme skeleton;

  /// Inverse-surface colors.
  final MateoInverseColorScheme inverse;

  /// Control colors.
  final MateoControlsColorScheme controls;

  /// Map colors.
  final MateoMapColorScheme map;

  /// {@macro mateo_color_scheme_copy_with}
  MateoColorScheme copyWith({
    Color? background,
    MateoColorsColorScheme? colors,
    MateoTextColorScheme? text,
    Color? selectionHighlight,
    MateoButtonsColorScheme? buttons,
    MateoOverlayColorScheme? overlay,
    MateoBottomSheetColorScheme? bottomSheet,
    MateoToastColorScheme? toast,
    MateoScrollbarColorScheme? scrollbar,
    MateoSkeletonColorScheme? skeleton,
    MateoInverseColorScheme? inverse,
    MateoControlsColorScheme? controls,
    MateoMapColorScheme? map,
  }) => MateoColorScheme(
    background: background ?? this.background,
    colors: colors ?? this.colors,
    text: text ?? this.text,
    selectionHighlight: selectionHighlight ?? this.selectionHighlight,
    buttons: buttons ?? this.buttons,
    overlay: overlay ?? this.overlay,
    bottomSheet: bottomSheet ?? this.bottomSheet,
    toast: toast ?? this.toast,
    scrollbar: scrollbar ?? this.scrollbar,
    skeleton: skeleton ?? this.skeleton,
    inverse: inverse ?? this.inverse,
    controls: controls ?? this.controls,
    map: map ?? this.map,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MateoColorScheme &&
          background == other.background &&
          colors == other.colors &&
          text == other.text &&
          selectionHighlight == other.selectionHighlight &&
          buttons == other.buttons &&
          overlay == other.overlay &&
          bottomSheet == other.bottomSheet &&
          toast == other.toast &&
          scrollbar == other.scrollbar &&
          skeleton == other.skeleton &&
          inverse == other.inverse &&
          controls == other.controls &&
          map == other.map;

  @override
  int get hashCode => Object.hashAll([
    background,
    colors,
    text,
    selectionHighlight,
    buttons,
    overlay,
    bottomSheet,
    toast,
    scrollbar,
    skeleton,
    inverse,
    controls,
    map,
  ]);
}
