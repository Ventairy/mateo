import { createMateoTheme, getMateoThemeStyle } from 'mateo-web-react';
import { MateoSurface, MateoTheme, useMateoTheme } from 'mateo-web-react/react';

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
  // @ts-expect-error Surface styling is configured through its named props.
  const invalid = <MateoSurface className="custom">Content</MateoSurface>;
  // @ts-expect-error Misspelled sizes must fail through the built declarations.
  const typo = <MateoSurface width="fil">Content</MateoSurface>;
  const custom = (
    <MateoSurface width="20rem" height="calc(100% - 2rem)">
      Content
    </MateoSurface>
  );
  return { invalid, typo, custom };
}

export function SurfaceFixture() {
  return (
    <MateoTheme data={outer}>
      <MateoSurface
        id="consumer-surface"
        width="fill"
        height={240}
        padding={8}
        paddingBlock={16}
        paddingInline="1rem"
        aria-label="Details"
      >
        Content
      </MateoSurface>
    </MateoTheme>
  );
}
