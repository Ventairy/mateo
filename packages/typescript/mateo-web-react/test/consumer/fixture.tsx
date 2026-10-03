import { createMateoTheme, getMateoThemeStyle } from 'mateo-web-react';
import { MateoTheme, useMateoTheme } from 'mateo-web-react/react';

const outer = createMateoTheme({ accentColor: '#4A5CFF', onAccent: '#FFFFFF' });
const inner = createMateoTheme({ accentColor: '#00A86B', onAccent: '#000000' });

function Accent() {
  const theme = useMateoTheme();
  return <span>{theme.colorScheme.accent}</span>;
}

export function ConsumerFixture() {
  return (
    <MateoTheme data={outer}>
      <main style={getMateoThemeStyle(outer)}>
        <Accent />
        <MateoTheme data={inner}>
          <section style={getMateoThemeStyle(inner)}>
            <Accent />
          </section>
        </MateoTheme>
        <Accent />
      </main>
    </MateoTheme>
  );
}

// Checked as an external NodeNext consumer, never called at runtime.
export function checkTypes() {
  // @ts-expect-error Both theme colors are required.
  createMateoTheme({ accentColor: '#4A5CFF' });
  // @ts-expect-error Palette steps are one-based.
  outer.palette.accent[0];
  // @ts-expect-error Theme roles are immutable.
  outer.colorScheme.accent = '#000';
}
