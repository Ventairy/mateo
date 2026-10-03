import { createMateoTheme, getMateoThemeStyle } from 'mateo-web-react';
import { MateoSurface, MateoTheme, useMateoTheme } from 'mateo-web-react/react';

const outerMateoTheme = createMateoTheme({
  accentColor: '#4A5CFF',
  onAccent: '#FFFFFF',
});
const innerMateoTheme = createMateoTheme({
  accentColor: '#00A86B',
  onAccent: '#000000',
});

function MateoAccent() {
  const theme = useMateoTheme();
  return <span>{theme.colorScheme.accent}</span>;
}

export function MateoConsumerFixture() {
  return (
    <MateoTheme data={outerMateoTheme}>
      <main style={getMateoThemeStyle(outerMateoTheme)}>
        <MateoAccent />
        <MateoTheme data={innerMateoTheme}>
          <section style={getMateoThemeStyle(innerMateoTheme)}>
            <MateoAccent />
          </section>
        </MateoTheme>
        <MateoAccent />
      </main>
    </MateoTheme>
  );
}

// Checked as an external NodeNext consumer, never called at runtime.
export function checkMateoConsumerTypes() {
  // @ts-expect-error Both theme colors are required.
  createMateoTheme({ accentColor: '#4A5CFF' });
  // @ts-expect-error Palette steps are one-based.
  outerMateoTheme.palette.accent[0];
  // @ts-expect-error Theme roles are immutable.
  outerMateoTheme.colorScheme.accent = '#000';
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

export function MateoSurfaceFixture() {
  return (
    <MateoTheme data={outerMateoTheme}>
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

export function MateoShapeFixture() {
  return (
    <MateoTheme data={outerMateoTheme}>
      <MateoSurface width={200} height={52} shape="capsule">
        Capsule
      </MateoSurface>
      <MateoSurface
        width={140}
        height={76}
        shape={{ type: 'rounded', radius: 24 }}
      >
        Rounded
      </MateoSurface>
    </MateoTheme>
  );
}

export function checkMateoShapeConsumerTypes() {
  const reusable: import('mateo-web-react').MateoShape = {
    type: 'rounded',
    radius: 24,
  };
  const valid = <MateoSurface shape={reusable}>Content</MateoSurface>;
  const missing = (
    // @ts-expect-error Rounded shapes require their numeric radius.
    <MateoSurface shape={{ type: 'rounded' }}>Content</MateoSurface>
  );
  // @ts-expect-error Unsupported shape names are rejected by built declarations.
  const typo = <MateoSurface shape="pill">Content</MateoSurface>;
  return { valid, missing, typo };
}
