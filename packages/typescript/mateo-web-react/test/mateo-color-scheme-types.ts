import {
  createMateoPalette,
  type MateoButtonColorScheme,
  MateoColorScheme,
} from '../src/mateo.js';

const mateoSchemePalette = createMateoPalette({ accentColor: '#4A5CFF' });
const mateoLightScheme = MateoColorScheme.light({
  palette: mateoSchemePalette,
  onAccent: '#FFFFFF',
});
const mateoAccentTreatment: MateoButtonColorScheme =
  mateoLightScheme.buttons.primary.accent;
void mateoAccentTreatment;
// @ts-expect-error The light factory requires an accent foreground.
MateoColorScheme.light({ palette: mateoSchemePalette });
// @ts-expect-error Semantic roles are immutable.
mateoLightScheme.buttons.primary.accent.foreground = '#000000';
// @ts-expect-error General color schemes are created through appearance factories.
new MateoColorScheme({});
// @ts-expect-error Dark appearance is not supported.
MateoColorScheme.dark({ palette: mateoSchemePalette, onAccent: '#FFFFFF' });
