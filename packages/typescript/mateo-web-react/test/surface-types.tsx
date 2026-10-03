import { createRef } from 'react';
import { MateoSurface, type MateoSurfaceSize } from '../src/react.js';

export function checkSurfaceTypes() {
  const ref = createRef<HTMLDivElement>();
  const surface = (
    <MateoSurface
      ref={ref}
      width="fill"
      height={240}
      paddingInline="1rem"
      aria-label="Details"
      data-state="ready"
    >
      Content
    </MateoSurface>
  );
  // @ts-expect-error Content is required.
  const empty = <MateoSurface />;
  // @ts-expect-error The surface is a container, not a polymorphic control.
  const button = <MateoSurface as="button">Content</MateoSurface>;
  const styled = (
    // @ts-expect-error Surface styling has named customization points.
    <MateoSurface style={{ borderRadius: 20 }}>Content</MateoSurface>
  );
  // @ts-expect-error Custom classes are not supported.
  const classified = <MateoSurface className="custom">Content</MateoSurface>;
  // @ts-expect-error Interaction belongs to a control.
  const clickable = <MateoSurface onClick={() => {}}>Content</MateoSurface>;
  // @ts-expect-error Dimensions use native values, not custom objects.
  const sized = <MateoSurface width={{ custom: 20 }}>Content</MateoSurface>;
  const invalidRef = (
    // @ts-expect-error The surface ref points to its div.
    <MateoSurface ref={createRef<HTMLButtonElement>()}>Content</MateoSurface>
  );
  const sizes: MateoSurfaceSize[] = [
    'fit',
    'fill',
    0,
    240,
    '0',
    '20rem',
    '50%',
    '12px',
    '100dvh',
    '10cqi',
    '2lh',
    'var(--surface-width)',
    'calc(100% - 2rem)',
    'min(20rem, 100%)',
    'max(10rem, 50%)',
    'clamp(10rem, 50%, 30rem)',
  ];
  // @ts-expect-error Misspelled sizing policies are rejected.
  const typo = <MateoSurface width="fil">Content</MateoSurface>;
  // @ts-expect-error Height uses the same strict size contract.
  const heightTypo = <MateoSurface height="fitt">Content</MateoSurface>;
  // @ts-expect-error Empty size strings are rejected.
  const emptySize = <MateoSurface width="">Content</MateoSurface>;
  // @ts-expect-error Custom string sizes must have a recognized unit.
  const unitTypo = <MateoSurface width="20rme">Content</MateoSurface>;
  // @ts-expect-error Pixel numbers use numbers, not unitless strings.
  const unitless = <MateoSurface width="240">Content</MateoSurface>;
  return {
    sizes,
    typo,
    heightTypo,
    emptySize,
    unitTypo,
    unitless,
    surface,
    empty,
    button,
    styled,
    classified,
    clickable,
    sized,
    invalidRef,
  };
}
