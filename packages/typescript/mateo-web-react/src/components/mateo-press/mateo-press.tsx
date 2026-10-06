'use client';

import type { AriaAttributes, MouseEvent, ReactNode, Ref } from 'react';
import {
  mateoPressDurationStyle,
  mateoPressFeedbackClassName,
  mateoPressNoAnimationClassName,
  mateoPressScaleClassName,
  mateoPressTargetClassNames,
} from './mateo-press-appearance.js';
import { useMateoPressInteraction } from './use-mateo-press-interaction.js';

/** Press feedback applied to the content of a Mateo action. */
export type MateoPressAnimation = 'scale' | 'none';

/** Content forming one action; descendants must be noninteractive. */
interface MateoPressContentProps extends AriaAttributes {
  /**
   * Noninteractive content forming this one action. Do not nest buttons, links,
   * inputs, or other independently interactive descendants.
   */
  readonly children: ReactNode;
  /**
   * Feedback while pressing. `"scale"` compresses and dims the content; `"none"`
   * removes press feedback while preserving hover dimming and keyboard focus.
   *
   * @defaultValue `"scale"`
   */
  readonly pressAnimation?: MateoPressAnimation;
  /**
   * DOM identifier on the action element.
   */
  readonly id?: string;
  /**
   * Consumer data attributes forwarded to the action element.
   */
  readonly [attribute: `data-${string}`]: string | number | boolean | undefined;
}

/**
 * Content and activation options for a single Mateo press action.
 *
 * @remarks
 * Use `as: "button"` for content allowed inside a native button, or the default
 * `div` for flow content such as a composed surface. Use `as: "a"` with `href`
 * for navigation. Omit `onPressed` to disable button and container actions.
 * ARIA and `data-*` attributes are forwarded to the action element.
 */
export type MateoPressProps = MateoPressContentProps &
  (
    | {
        /**
         * Uses a layout element with button semantics for flow content.
         *
         * @defaultValue `"div"`
         */
        readonly as?: 'div';
        readonly href?: never;
        readonly target?: never;
        readonly rel?: never;
        /**
         * Called on activation. Omit to disable; pending promises and errors remain
         * caller-owned, with no automatic loading state.
         */
        readonly onPressed?: (
          event: MouseEvent<HTMLDivElement>,
        ) => void | Promise<void>;
        /**
         * Ref to the layout action element, suitable for moving focus.
         */
        readonly ref?: Ref<HTMLDivElement>;
      }
    | {
        /**
         * Uses a native button with `type="button"` and browser keyboard activation.
         */
        readonly as: 'button';
        readonly href?: never;
        readonly target?: never;
        readonly rel?: never;
        /**
         * Called on activation. Omit to disable; pending promises and errors remain
         * caller-owned, with no automatic loading state.
         */
        readonly onPressed?: (
          event: MouseEvent<HTMLButtonElement>,
        ) => void | Promise<void>;
        /**
         * Ref to the native action button, suitable for moving focus.
         */
        readonly ref?: Ref<HTMLButtonElement>;
      }
    | {
        /** Uses a native link with browser-owned navigation. */
        readonly as: 'a';
        /** Destination URL, including relative paths and page fragments. Must be nonempty. */
        readonly href: string;
        /** Browsing context receiving the destination. Defaults to the current context. */
        readonly target?: '_self' | '_blank' | '_parent' | '_top';
        /** Space-separated relationships to the destination, such as `noopener`. */
        readonly rel?: string;
        /**
         * Optional activation callback. Navigation remains native unless the callback
         * calls `event.preventDefault()`. Promises are not awaited before navigation.
         */
        readonly onPressed?: (
          event: MouseEvent<HTMLAnchorElement>,
        ) => void | Promise<void>;
        /** Ref to the native link, suitable for moving focus. */
        readonly ref?: Ref<HTMLAnchorElement>;
      }
  );

/**
 * Adds accessible activation and tactile feedback to one composed action.
 *
 * @remarks
 * Works with pointer and assistive-technology activation. Buttons support Enter
 * and Space; links retain native Enter activation and Space scrolling. The target
 * stays stationary while its content compresses by default. Reduced motion removes
 * the animated transform. Give the action an accessible name through its content or
 * ARIA attributes. Omit `onPressed` to disable button and container actions. Links
 * remain enabled through `href`, including without JavaScript.
 * Does not supply a surface or require a theme.
 *
 * @throws TypeError - If `onPressed` is neither a function nor omitted, or
 * `pressAnimation` is unsupported, or an anchor has an empty destination.
 *
 * @example
 * ```tsx
 * <MateoPress onPressed={() => openDetails()}>
 *   <MateoSurface padding={20}>Open details</MateoSurface>
 * </MateoPress>
 * ```
 */
export function MateoPress(props: MateoPressProps) {
  if (
    props.pressAnimation !== undefined &&
    props.pressAnimation !== 'scale' &&
    props.pressAnimation !== 'none'
  ) {
    throw new TypeError('MateoPress pressAnimation must be scale or none.');
  }
  if (props.as === 'a') {
    if (typeof props.href !== 'string' || props.href.trim().length === 0) {
      throw new TypeError('MateoPress anchor href must be a nonempty string.');
    }
    return <_MateoAnchorPress {...props} />;
  }
  return props.as === 'button' ? (
    <_MateoNativePress {...props} />
  ) : (
    <_MateoCustomPress {...props} />
  );
}

/** Adds hover, contact feedback, and button semantics to a custom action. */
function _MateoCustomPress({
  children,
  onPressed,
  pressAnimation = 'scale',
  ref,
  id,
  ...attributes
}: Extract<MateoPressProps, { as?: 'div' }>) {
  // biome-ignore lint/correctness/useHookAtTopLevel: Internal React component uses the Mateo private naming prefix.
  const press = useMateoPressInteraction<HTMLDivElement>(
    onPressed,
    'custom',
    pressAnimation === 'scale',
  );
  const accessibleAttributes = _getMateoPressAccessibleAttributes(attributes);
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
      className={_getMateoPressTargetClassName('div', press.enabled)}
      {...press.handlers}
    >
      <_MateoPressFeedback as="div" pressAnimation={pressAnimation}>
        {children}
      </_MateoPressFeedback>
    </div>
  );
}

/** Native activation stays with the browser, including Enter and Space clicks. */
function _MateoNativePress({
  children,
  onPressed,
  pressAnimation = 'scale',
  ref,
  id,
  ...attributes
}: Extract<MateoPressProps, { as: 'button' }>) {
  // biome-ignore lint/correctness/useHookAtTopLevel: Internal React component uses the Mateo private naming prefix.
  const press = useMateoPressInteraction<HTMLButtonElement>(
    onPressed,
    'native',
    pressAnimation === 'scale',
  );
  const accessibleAttributes = _getMateoPressAccessibleAttributes(attributes);
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
      className={_getMateoPressTargetClassName('button', press.enabled)}
    >
      <_MateoPressFeedback as="span" pressAnimation={pressAnimation}>
        {children}
      </_MateoPressFeedback>
    </button>
  );
}

function _MateoAnchorPress({
  children,
  href,
  target,
  rel,
  onPressed,
  pressAnimation = 'scale',
  ref,
  id,
  ...attributes
}: Extract<MateoPressProps, { as: 'a' }>) {
  // biome-ignore lint/correctness/useHookAtTopLevel: Internal React component uses the Mateo private naming prefix.
  const press = useMateoPressInteraction<HTMLAnchorElement>(
    onPressed,
    'link',
    pressAnimation === 'scale',
  );
  return (
    <a
      {..._getMateoPressAccessibleAttributes(attributes)}
      {...press.attributes}
      {...press.handlers}
      href={href}
      target={target}
      rel={rel}
      ref={ref}
      id={id}
      className={_getMateoPressTargetClassName('a', true)}
    >
      <_MateoPressFeedback as="span" pressAnimation={pressAnimation}>
        {children}
      </_MateoPressFeedback>
    </a>
  );
}

function _getMateoPressAccessibleAttributes(
  attributes: Omit<MateoPressContentProps, 'children' | 'id'>,
) {
  return Object.fromEntries(
    Object.entries(attributes).filter(
      ([name]) => name.startsWith('aria-') || name.startsWith('data-'),
    ),
  );
}

function _getMateoPressTargetClassName(
  as: 'div' | 'button' | 'a',
  enabled: boolean,
) {
  return [
    mateoPressTargetClassNames.shared,
    as === 'div' ? '' : mateoPressTargetClassNames.native,
    as === 'a' ? mateoPressTargetClassNames.link : '',
    enabled ? 'mateo:cursor-pointer' : 'mateo:cursor-default',
  ]
    .filter(Boolean)
    .join(' ');
}

/** Both element modes keep the target and content layout stationary. */
function _MateoPressFeedback({
  as: Tag,
  children,
  pressAnimation,
}: {
  readonly as: 'div' | 'span';
  readonly pressAnimation: MateoPressAnimation;
  readonly children: ReactNode;
}) {
  return (
    <Tag
      style={mateoPressDurationStyle}
      className={[
        mateoPressFeedbackClassName,
        pressAnimation === 'scale'
          ? mateoPressScaleClassName
          : mateoPressNoAnimationClassName,
        Tag === 'span' ? 'mateo:block' : '',
      ]
        .filter(Boolean)
        .join(' ')}
    >
      {children}
    </Tag>
  );
}
