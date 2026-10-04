import type { MateoIconButtonPresentation } from './presentations/mateo-icon-button-presentation.js';
import type { MateoLabelButtonPresentation } from './presentations/mateo-label-button-presentation.js';

export type {
  MateoButtonAlignment,
  MateoButtonSize,
  MateoButtonVariant,
  MateoButtonWidth,
} from './mateo-button-options.js';
export type { MateoIconButtonPresentation } from './presentations/mateo-icon-button-presentation.js';
export type { MateoLabelButtonPresentation } from './presentations/mateo-label-button-presentation.js';

/** Content and appearance forwarded by any component that owns a button action. */
export type MateoButtonPresentation =
  | MateoLabelButtonPresentation
  | MateoIconButtonPresentation;
