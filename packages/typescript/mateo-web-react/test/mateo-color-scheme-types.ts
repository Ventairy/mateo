import {
  createMateoPalette,
  type MateoButtonColorScheme,
  MateoColorScheme,
  MateoSelectionColorScheme,
  MateoTextColorScheme,
} from '../src/mateo.js';

const mateoSchemePalette = createMateoPalette({ accentColor: '#4A5CFF' });
const mateoLightScheme = MateoColorScheme.light({
  palette: mateoSchemePalette,
  onAccent: '#FFFFFF',
});
const mateoAccentTreatment: MateoButtonColorScheme =
  mateoLightScheme.buttons.primary.accent;
void mateoAccentTreatment;
const mateoTextColors: MateoTextColorScheme = mateoLightScheme.text;
const mateoPrimaryTextColor: string = mateoTextColors.primary;
void mateoPrimaryTextColor;
new MateoTextColorScheme(mateoTextColors);
// @ts-expect-error Text roles are immutable.
mateoTextColors.primary = '#000000';
// @ts-expect-error The text group itself is immutable.
mateoLightScheme.text = mateoTextColors;
// @ts-expect-error All four text roles are required.
new MateoTextColorScheme({
  primary: '#000000',
  secondary: '#555555',
  tertiary: '#999999',
});
// @ts-expect-error The light factory requires an accent foreground.
MateoColorScheme.light({ palette: mateoSchemePalette });
// @ts-expect-error Semantic roles are immutable.
mateoLightScheme.buttons.primary.accent.foreground = '#000000';
// @ts-expect-error General color schemes are created through appearance factories.
new MateoColorScheme({});
// @ts-expect-error Dark appearance is not supported.
MateoColorScheme.dark({ palette: mateoSchemePalette, onAccent: '#FFFFFF' });

const mateoSelectionColors: MateoSelectionColorScheme =
  mateoLightScheme.selection;
const mateoSelectionBackground: string = mateoSelectionColors.background;
const mateoSelectionForeground: string = mateoSelectionColors.foreground;
void mateoSelectionBackground;
void mateoSelectionForeground;
new MateoSelectionColorScheme(mateoSelectionColors);
// @ts-expect-error Selection backgrounds are immutable.
mateoSelectionColors.background = '#000000';
// @ts-expect-error Selection foregrounds are immutable.
mateoSelectionColors.foreground = '#000000';
// @ts-expect-error The selection group is immutable.
mateoLightScheme.selection = mateoSelectionColors;
// @ts-expect-error Both selection colors are required.
new MateoSelectionColorScheme({ background: '#FFFFFF' });
// @ts-expect-error Selection foregrounds belong to the selection group.
mateoLightScheme.onSelection;
