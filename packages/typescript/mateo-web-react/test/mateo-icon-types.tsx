import { createRef } from 'react';
import {
  MateoArrowDownIcon,
  type MateoNamedIconProps,
} from '../src/mateo-icons.js';
import {
  MateoIcon,
  type MateoIconName,
  type MateoIconProps,
} from '../src/mateo-react.js';

const mateoIconName: MateoIconName = 'arrowRotateClockwise';
const mateoIconProps: MateoIconProps = {
  icon: mateoIconName,
  size: 24,
  color: 'var(--foreground)',
  backgroundColor: 'rebeccapurple',
  'aria-label': 'Retry',
  ref: createRef<SVGSVGElement>(),
};
<MateoIcon {...mateoIconProps} />;
<MateoIcon icon="mapPin" />;
<MateoIcon icon="magnifierGlass" />;
<MateoIcon icon="wifiExclamation" />;
// @ts-expect-error An icon choice is required.
<MateoIcon />;
// @ts-expect-error Catalog names are closed literal options.
<MateoIcon icon="arrowLef" />;
// @ts-expect-error Sizes are pixels, not arbitrary CSS dimensions.
<MateoIcon icon="cross" size="2rem" />;
// @ts-expect-error Consumer styling is outside the icon contract.
<MateoIcon icon="cross" className="custom" />;
// @ts-expect-error Consumer styling is outside the icon contract.
<MateoIcon icon="cross" style={{ width: 24 }} />;
// @ts-expect-error The interactive parent owns actions.
<MateoIcon icon="cross" onClick={() => {}} />;
// @ts-expect-error SVG is the only supported treatment.
<MateoIcon icon="cross" style="threeD" />;
// @ts-expect-error The ref targets the rendered SVG.
<MateoIcon icon="cross" ref={createRef<HTMLDivElement>()} />;

const mateoNamedIconProps: MateoNamedIconProps = {
  size: 24,
  color: 'var(--foreground)',
  backgroundColor: 'rebeccapurple',
  'aria-label': 'Down',
  ref: createRef<SVGSVGElement>(),
};
<MateoArrowDownIcon {...mateoNamedIconProps} />;
<MateoArrowDownIcon />;
// @ts-expect-error The imported component already chooses its artwork.
<MateoArrowDownIcon icon="arrowDown" />;
// @ts-expect-error Named icons keep the closed appearance contract.
<MateoArrowDownIcon className="custom" />;
// @ts-expect-error Named icons keep numeric pixel sizing.
<MateoArrowDownIcon size="2rem" />;
// @ts-expect-error The interactive parent owns actions.
<MateoArrowDownIcon onClick={() => {}} />;
