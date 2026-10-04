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

/**
 * Reusable content and appearance for a Mateo button action.
 *
 * @remarks
 * Choose `kind: "label"` for visible text or `kind: "icon"` for a circular icon
 * action with an accessible label. The component using the presentation owns
 * activation and enabled state; the presentation carries no callback.
 */
export type MateoButtonPresentation =
  | MateoLabelButtonPresentation
  | MateoIconButtonPresentation;
