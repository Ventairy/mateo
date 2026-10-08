import { createRef } from 'react';
import {
  MateoAppleLogoIcon,
  MateoArrowDownIcon,
  type MateoNamedIconProps,
} from '../src/mateo-icons.js';

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

<MateoAppleLogoIcon {...mateoNamedIconProps} />;
// @ts-expect-error Consumer styling is outside the icon contract.
<MateoAppleLogoIcon style={{ width: 24 }} />;
// @ts-expect-error The ref targets the rendered SVG.
<MateoAppleLogoIcon ref={createRef<HTMLDivElement>()} />;
