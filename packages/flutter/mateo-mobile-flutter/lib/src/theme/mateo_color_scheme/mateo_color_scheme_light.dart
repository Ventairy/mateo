part of 'mateo_color_scheme.dart';

class _LightMateoColorScheme extends MateoColorScheme {
  _LightMateoColorScheme({
    required MateoPalette palette,
    required Color onAccent,
  }) : super(
         background: Colors.white,
         text: MateoTextColorScheme(
           primary: palette.neutral[12],
           secondary: palette.neutral[10],
           tertiary: palette.neutral[8],
           profit: palette.green[9],
         ),
         buttons: MateoButtonsColorScheme(
           primary: MateoPrimaryButtonColorScheme(
             accent: MateoButtonColorScheme(
               background: palette.accent[9],
               backgroundPressed: palette.accent[9],
               backgroundDisabled: palette.neutral[4],
               foreground: onAccent,
               foregroundDisabled: palette.neutral[9],
             ),
             neutral: MateoButtonColorScheme(
               background: palette.neutral[12],
               backgroundPressed: palette.neutral[12],
               backgroundDisabled: palette.neutral[5],
               foreground: palette.neutral[1],
               foregroundDisabled: palette.neutral[9],
             ),
             base: MateoButtonColorScheme(
               background: Colors.white,
               backgroundPressed: Colors.white,
               backgroundDisabled: palette.neutral[4],
               foreground: Colors.black,
               foregroundDisabled: palette.neutral[9],
             ),
           ),
           secondary: MateoSecondaryButtonColorScheme(
             accent: MateoButtonColorScheme(
               background: palette.accent[2],
               backgroundPressed: palette.accent[2],
               backgroundDisabled: palette.neutral[4],
               foreground: palette.accent[9],
               foregroundDisabled: palette.neutral[9],
             ),
             neutral: MateoButtonColorScheme(
               background: palette.neutral[2],
               backgroundPressed: palette.neutral[2],
               backgroundDisabled: palette.neutral[5],
               foreground: palette.neutral[12],
               foregroundDisabled: palette.neutral[9],
             ),
           ),
           tertiary: MateoTertiaryButtonColorScheme(
             neutral: MateoButtonColorScheme(
               background: Colors.transparent,
               backgroundPressed: Colors.transparent,
               backgroundDisabled: Colors.transparent,
               foreground: palette.neutral[12],
               foregroundDisabled: palette.neutral[9],
             ),
           ),
         ),
         overlay: const MateoOverlayColorScheme(scrim: Color(0x66000000)),
         sheet: const MateoSheetColorScheme(
           background: Colors.white,
         ),
         toast: MateoToastColorScheme(
           success: MateoToastVariantColorScheme(
             background: palette.green[12],
             foreground: Colors.white,
             icon: palette.green[9],
           ),
           error: MateoToastVariantColorScheme(
             background: palette.red[12],
             foreground: Colors.white,
             icon: palette.red[9],
           ),
           warning: MateoToastVariantColorScheme(
             background: palette.amber[12],
             foreground: Colors.white,
             icon: palette.amber[9],
           ),
           info: MateoToastVariantColorScheme(
             background: palette.blue[12],
             foreground: Colors.white,
             icon: palette.blue[9],
           ),
           neutral: MateoToastVariantColorScheme(
             background: palette.neutral[12],
             foreground: Colors.white,
             icon: palette.neutral[8],
           ),
         ),
         skeleton: MateoSkeletonColorScheme(
           bone: palette.neutral[3],
           skeletonText: palette.neutral[8],
           skeletonTextGlow: palette.neutral[4],
         ),
         inverse: MateoInverseColorScheme(
           background: palette.neutral[12],
           onBackground: Colors.white,
           accent: palette.accent[3],
         ),
         controls: MateoControlsColorScheme(
           track: palette.neutral[6],
           trackFilled: palette.accent[9],
         ),
         toggle: MateoToggleColorScheme(
           trackOn: palette.accent[9],
           trackOff: palette.neutral[3],
           trackDisabled: palette.neutral[4],
           circleOn: palette.neutral[1],
           circleOff: palette.neutral[1],
           circleDisabled: palette.neutral[8],
         ),
         messageBubble: MateoMessageBubbleColorScheme(
           incoming: MateoColorVariantColorScheme(
             solid: palette.neutral[3],
             onSolid: palette.neutral[11],
           ),
           outgoing: MateoColorVariantColorScheme(
             solid: palette.accent[9],
             onSolid: palette.neutral[1],
           ),
           typingIndicator: palette.neutral[9],
         ),
         menu: MateoMenusColorScheme(
           action: MateoMenuColorScheme(
             background: Colors.black,
             title: Colors.white,
             titleDisabled: palette.neutral[9],
             description: palette.neutral[7],
             descriptionDisabled: palette.neutral[11],
             icon: palette.neutral[1],
             iconDisabled: Colors.white.withValues(alpha: 0.45),
             scrim: Colors.transparent,
           ),
           context: MateoMenuColorScheme(
             background: Colors.black,
             title: Colors.white,
             titleDisabled: palette.neutral[9],
             description: palette.neutral[7],
             descriptionDisabled: palette.neutral[11],
             icon: palette.neutral[1],
             iconDisabled: Colors.white.withValues(alpha: 0.45),
             scrim: Colors.transparent,
           ),
         ),
         characterCounter: MateoCharacterCounterColorScheme(
           floating: MateoCharacterCounterVariantColorScheme(
             background: Colors.white,
             backgroundDisabled: palette.neutral[4],
             foreground: palette.neutral[12],
             foregroundDisabled: palette.neutral[9],
             foregroundReject: palette.red[10],
           ),
           text: MateoCharacterCounterVariantColorScheme(
             background: Colors.transparent,
             backgroundDisabled: Colors.transparent,
             foreground: palette.neutral[9],
             foregroundDisabled: palette.neutral[9],
             foregroundReject: palette.red[10],
           ),
         ),
         textField: MateoTextFieldColorScheme(
           floating: MateoTextFieldVariantColorScheme(
             background: Colors.white,
             backgroundDisabled: palette.neutral[4],
             text: palette.neutral[12],
             textDisabled: palette.neutral[8],
             placeholderResting: palette.neutral[9],
             placeholderDisabled: palette.neutral[8],
             iconResting: palette.neutral[9],
             iconFocused: palette.neutral[12],
             iconDisabled: palette.neutral[8],
             caret: palette.accent[9],
             selectionHighlight: palette.accent[9].withValues(alpha: 0.30),
           ),
           filled: MateoTextFieldVariantColorScheme(
             background: palette.neutral[3],
             backgroundDisabled: palette.neutral[4],
             text: palette.neutral[12],
             textDisabled: palette.neutral[8],
             placeholderResting: palette.neutral[6],
             placeholderDisabled: palette.neutral[8],
             iconResting: palette.neutral[6],
             iconFocused: palette.neutral[6],
             iconDisabled: palette.neutral[8],
             caret: palette.accent[9],
             selectionHighlight: palette.accent[9].withValues(alpha: 0.30),
           ),
         ),
         select: MateoSelectColorScheme(
           neutral: MateoSelectVariantColorScheme(
             background: palette.neutral[2],
             title: palette.neutral[12],
             icon: palette.neutral[12],
             chevron: palette.neutral[12],
           ),
           ghost: MateoSelectVariantColorScheme(
             background: Colors.transparent,
             title: palette.neutral[12],
             icon: palette.neutral[12],
             chevron: palette.neutral[12],
           ),
         ),
       );
}
