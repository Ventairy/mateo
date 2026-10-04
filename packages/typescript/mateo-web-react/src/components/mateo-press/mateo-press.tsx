'use client';

import type { AriaAttributes, MouseEvent, ReactNode, Ref } from 'react';
import {
  mateoPressDurationStyle,
  mateoPressFeedbackClassName,
  mateoPressTargetClassNames,
} from './mateo-press-appearance.js';
import { useMateoPressInteraction } from './use-mateo-press-interaction.js';

/** Content forming one action; descendants must be noninteractive. */
interface MateoPressContentProps extends AriaAttributes {
  readonly children: ReactNode;
  readonly id?: string;
  readonly [attribute: `data-${string}`]: string | number | boolean | undefined;
}

/** Custom flow content uses a layout element; native actions use a button. */
export type MateoPressProps = MateoPressContentProps &
  (
    | {
        readonly as?: 'div';
        readonly onPressed?: (
          event: MouseEvent<HTMLDivElement>,
        ) => void | Promise<void>;
        readonly ref?: Ref<HTMLDivElement>;
      }
    | {
        readonly as: 'button';
        readonly onPressed?: (
          event: MouseEvent<HTMLButtonElement>,
        ) => void | Promise<void>;
        readonly ref?: Ref<HTMLButtonElement>;
      }
  );

/** Owns semantics, activation, and feedback for one Mateo action. */
export function MateoPress(props: MateoPressProps) {
  return props.as === 'button' ? (
    <MateoNativePress {...props} />
  ) : (
    <MateoCustomPress {...props} />
  );
}

/** Adds hover, contact feedback, and button semantics to a custom action. */
function MateoCustomPress({
  children,
  onPressed,
  ref,
  id,
  ...attributes
}: Extract<MateoPressProps, { as?: 'div' }>) {
  const press = useMateoPressInteraction<HTMLDivElement>(onPressed);
  const accessibleAttributes = getMateoPressAccessibleAttributes(attributes);
  return (
    // biome-ignore lint/a11y/useSemanticElements: Native buttons cannot contain arbitrary flow content such as MateoSurface.
    <div
      {...accessibleAttributes}
      ref={ref}
      id={id}
      role="button"
      tabIndex={press.enabled ? 0 : -1}
      aria-disabled={!press.enabled}
      {...press.attributes}
      className={getMateoPressTargetClassName('div', press.enabled)}
      {...press.handlers}
    >
      <MateoPressFeedback as="div">{children}</MateoPressFeedback>
    </div>
  );
}

/** Native activation stays with the browser, including Enter and Space clicks. */
function MateoNativePress({
  children,
  onPressed,
  ref,
  id,
  ...attributes
}: Extract<MateoPressProps, { as: 'button' }>) {
  const press = useMateoPressInteraction<HTMLButtonElement>(
    onPressed,
    'native',
  );
  const accessibleAttributes = getMateoPressAccessibleAttributes(attributes);
  return (
    <button
      {...accessibleAttributes}
      {...press.attributes}
      {...press.handlers}
      ref={ref}
      id={id}
      type="button"
      disabled={!press.enabled}
      aria-disabled={!press.enabled}
      className={getMateoPressTargetClassName('button', press.enabled)}
    >
      <MateoPressFeedback as="span">{children}</MateoPressFeedback>
    </button>
  );
}

function getMateoPressAccessibleAttributes(
  attributes: Omit<MateoPressContentProps, 'children' | 'id'>,
) {
  return Object.fromEntries(
    Object.entries(attributes).filter(
      ([name]) => name.startsWith('aria-') || name.startsWith('data-'),
    ),
  );
}

function getMateoPressTargetClassName(as: 'div' | 'button', enabled: boolean) {
  return [
    mateoPressTargetClassNames.shared,
    as === 'button' ? mateoPressTargetClassNames.native : '',
    enabled ? 'mateo:cursor-pointer' : 'mateo:cursor-default',
  ]
    .filter(Boolean)
    .join(' ');
}

/** Both element modes animate the content while keeping the target stationary. */
function MateoPressFeedback({
  as: Tag,
  children,
}: {
  readonly as: 'div' | 'span';
  readonly children: ReactNode;
}) {
  return (
    <Tag
      style={mateoPressDurationStyle}
      className={[
        mateoPressFeedbackClassName,
        Tag === 'span' ? 'mateo:block' : '',
      ]
        .filter(Boolean)
        .join(' ')}
    >
      {children}
    </Tag>
  );
}
