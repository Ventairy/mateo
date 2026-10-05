import {
  lerpMateoRoundedShape,
  type MateoRoundedShapeEndpoint,
  type MateoRoundedShapeFrame,
  type MateoRoundedShapeLerpOptions,
} from '../src/mateo.js';
import { MateoSurface } from '../src/mateo-react.js';

export function checkMateoRoundedShapeTypes() {
  const begin: MateoRoundedShapeEndpoint = {
    width: 200,
    height: 56,
    shape: 'capsule',
  };
  const end: MateoRoundedShapeEndpoint = {
    width: 320,
    height: 180,
    shape: { type: 'rounded', radius: 24 },
  };
  const options: MateoRoundedShapeLerpOptions = { begin, end, progress: 0.5 };
  const frame: MateoRoundedShapeFrame = lerpMateoRoundedShape(options);
  const surface = <MateoSurface {...frame}>Content</MateoSurface>;
  const next = lerpMateoRoundedShape({
    begin: frame,
    end: { ...end, shape: 'none' },
    progress: 0.25,
  });
  const rounded: 'rounded' = frame.shape.type;
  // @ts-expect-error Endpoint dimensions are required.
  const incomplete: MateoRoundedShapeEndpoint = {
    width: 200,
    shape: 'capsule',
  };
  const misspelled: MateoRoundedShapeEndpoint = {
    width: 200,
    height: 56,
    // @ts-expect-error Misspelled shapes are rejected.
    shape: 'capsul',
  };
  const noRadius: MateoRoundedShapeEndpoint = {
    width: 200,
    height: 56,
    // @ts-expect-error A custom rounded shape requires its radius.
    shape: { type: 'rounded' },
  };
  // @ts-expect-error Interpolation requires progress.
  lerpMateoRoundedShape({ begin, end });
  // @ts-expect-error Progress is numeric.
  lerpMateoRoundedShape({ begin, end, progress: '0.5' });
  // @ts-expect-error Endpoint geometry is readonly.
  begin.width = 300;
  // @ts-expect-error Options are readonly.
  options.progress = 1;
  // @ts-expect-error Frame dimensions are readonly.
  frame.height = 300;
  // @ts-expect-error Frame shape is readonly.
  frame.shape.radius = 10;
  return { surface, next, rounded, incomplete, misspelled, noRadius };
}
