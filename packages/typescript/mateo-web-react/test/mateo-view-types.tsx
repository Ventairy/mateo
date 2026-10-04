import {
  MateoView,
  MateoViewHeader,
  type MateoViewPadding,
  MateoViewSurface,
} from '../src/mateo-react.js';

export function checkMateoViewTypes() {
  const padding: MateoViewPadding = { inlineStart: 24, blockEnd: 8 };
  const view = (
    <MateoView
      padding={padding}
      header={
        <MateoViewHeader
          leading={<button type="button">Back</button>}
          principal={<h1>Messages</h1>}
        />
      }
      surface={
        <MateoViewSurface shape={{ type: 'rounded', radius: 24 }} padding={0}>
          Content
        </MateoViewSurface>
      }
    />
  );
  // @ts-expect-error The view requires a surface.
  const missingSurface = <MateoView />;
  // @ts-expect-error Surface content is required.
  const missingContent = <MateoViewSurface />;
  const classes = (
    <MateoView
      surface={<MateoViewSurface>Content</MateoViewSurface>}
      // @ts-expect-error Use named view customization rather than arbitrary classes.
      className="custom"
    />
  );
  // @ts-expect-error The surface owns scrolling automatically in v1.
  const mode = <MateoViewSurface scrollable={false}>Content</MateoViewSurface>;
  // @ts-expect-error The view surface always fills its owner.
  const size = <MateoViewSurface height="fit">Content</MateoViewSurface>;
  const cssPadding = (
    // @ts-expect-error View spacing is expressed in numeric pixels.
    <MateoViewSurface padding="1rem">Content</MateoViewSurface>
  );
  // @ts-expect-error Logical edge names form a closed contract.
  const typo = <MateoViewHeader padding={{ inlineStrat: 12 }} />;
  // @ts-expect-error Arbitrary styles are not header customization points.
  const style = <MateoViewHeader style={{ position: 'fixed' }} />;
  return {
    view,
    missingSurface,
    missingContent,
    classes,
    mode,
    size,
    cssPadding,
    typo,
    style,
  };
}
