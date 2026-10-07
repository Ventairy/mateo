"use client";

import type { AriaAttributes, CSSProperties, MouseEvent, Ref } from "react";
import type { MateoButtonsColorScheme } from "../../theme/mateo-color-scheme/mateo-buttons-color-scheme.js";
import { useMateoTheme } from "../../theme/mateo-theme-context.js";
import { MateoPress } from "../mateo-press/mateo-press.js";
import { mateoButtonHeights } from "./mateo-button-options.js";
import type {
  MateoButtonPresentation,
  MateoButtonVariant,
} from "./mateo-button-presentation.js";
import { MateoIconButtonContent } from "./presentations/mateo-icon-button-presentation.js";
import {
  getMateoLabelButtonClassName,
  MateoLabelButtonContent,
} from "./presentations/mateo-label-button-presentation.js";

/**
 * Configuration for one native Mateo button action.
 *
 * @remarks
 * Supports React ARIA attributes and `data-*` attributes on the button. Use
 * `presentation` for supported appearance choices and `onPressed` to enable the
 * action. An `aria-label` overrides the presentation label as the accessible name.
 */
interface MateoButtonContentProps extends AriaAttributes {
  /**
   * Visible content, accessible label, size, and treatment for this action.
   */
  readonly presentation: MateoButtonPresentation;
  /**
   * DOM identifier on the native button for relationships and lookup.
   */
  readonly id?: string;
  /**
   * Consumer data attributes forwarded to the native button.
   */
  readonly [attribute: `data-${string}`]: string | number | boolean | undefined;
}

/**
 * A native button by default, or a native destination with `as="a"` and `href`.
 * Links retain browser navigation and remain enabled without `onPressed`.
 */
export type MateoButtonProps = MateoButtonContentProps &
  (
    | {
        /** Native action mode; this is the default. */
        readonly as?: "button";
        readonly href?: never;
        readonly target?: never;
        readonly rel?: never;
        /** Action callback. Omit to disable; promises do not change pending state. */
        readonly onPressed?: (
          event: MouseEvent<HTMLButtonElement>,
        ) => void | Promise<void>;
        /** Ref to the native button. */
        readonly ref?: Ref<HTMLButtonElement>;
      }
    | {
        /** Native destination mode with the same button presentation. */
        readonly as: "a";
        /** Nonempty destination URL, including relative paths and fragments. */
        readonly href: string;
        /** Browsing context receiving navigation. Defaults to the current context. */
        readonly target?: "_self" | "_blank" | "_parent" | "_top";
        /** Space-separated destination relationships, such as `noopener`. */
        readonly rel?: string;
        /**
         * Optional activation callback. Navigation remains native unless it calls
         * `preventDefault()`. Promises are not awaited before navigation.
         */
        readonly onPressed?: (
          event: MouseEvent<HTMLAnchorElement>,
        ) => void | Promise<void>;
        /** Ref to the native link. */
        readonly ref?: Ref<HTMLAnchorElement>;
      }
  );

function getMateoButtonColors(
  colors: MateoButtonsColorScheme,
  variant: MateoButtonVariant,
) {
  const treatments = {
    primary: colors.primary.accent,
    "primary-success": colors.primary.success,
    "primary-warning": colors.primary.warning,
    "primary-neutral": colors.primary.neutral,
    "primary-base": colors.primary.base,
    secondary: colors.secondary.accent,
    "secondary-neutral": colors.secondary.neutral,
    tertiary: colors.tertiary,
  } as const;
  if (!Object.hasOwn(treatments, variant))
    throw new TypeError("Unsupported MateoButton variant.");
  return treatments[variant];
}

/**
 * Renders a native action or destination with Mateo colors, shape, and press feedback.
 *
 * @remarks
 * Requires a MateoTheme ancestor. Uses `type="button"`, so activation does not
 * submit a form. Omit `onPressed` to disable actions. Use `as="a"` and `href`
 * for a destination, with optional `target`, `rel`, and `onPressed`. Enter follows
 * the link and Space scrolls. Links work without hydration. Pointer feedback respects
 * reduced-motion preferences. Label presentations truncate when space is limited;
 * the full label remains the default accessible name.
 *
 * @throws TypeError - If the presentation, label, icon content, or supported
 * appearance options are invalid.
 * @throws Error - If there is no MateoTheme ancestor.
 *
 * @example
 * ```tsx
 * <MateoButton
 *   presentation={{ kind: "label", label: "Save", variant: "primary" }}
 *   onPressed={() => save()}
 * />
 * ```
 */
export function MateoButton(props: MateoButtonProps) {
  const { presentation, id, ...attributes } = props;
  const theme = useMateoTheme();
  const enabled = props.as === "a" || props.onPressed !== undefined;
  if (
    (presentation?.kind !== "label" && presentation?.kind !== "icon") ||
    typeof presentation.label !== "string" ||
    !presentation.label.trim()
  ) {
    throw new TypeError(
      "MateoButton requires a supported presentation with a nonempty label.",
    );
  }
  const { label, variant = "primary", size = "standard" } = presentation;
  if (!Object.hasOwn(mateoButtonHeights, size))
    throw new TypeError("Unsupported MateoButton size.");
  const className =
    presentation.kind === "label"
      ? getMateoLabelButtonClassName(presentation)
      : "mateo:w-fit";
  const colors = getMateoButtonColors(theme.colorScheme.buttons, variant);
  const foreground = enabled ? colors.foreground : colors.foregroundDisabled;
  const style: CSSProperties & Record<`--mateo-${string}`, string> = {
    "--mateo-button-height": `${mateoButtonHeights[size]}px`,
    "--mateo-button-background": enabled
      ? colors.background
      : colors.backgroundDisabled,
    "--mateo-button-foreground": foreground,
    "--mateo-press-focus": theme.colorScheme.accent,
  };
  const accessibleAttributes = Object.fromEntries(
    Object.entries(attributes).filter(
      ([name]) => name.startsWith("aria-") || name.startsWith("data-"),
    ),
  );
  return (
    <span
      style={style}
      className={[
        "mateo:inline-grid mateo:box-border mateo:max-w-full mateo:align-middle",
        className,
      ].join(" ")}
    >
      <MateoPress
        {...accessibleAttributes}
        {...(props.as === "a"
          ? {
              as: "a" as const,
              href: props.href,
              ...(props.target === undefined ? {} : { target: props.target }),
              ...(props.rel === undefined ? {} : { rel: props.rel }),
              ...(props.onPressed === undefined
                ? {}
                : { onPressed: props.onPressed }),
              ...(props.ref === undefined ? {} : { ref: props.ref }),
            }
          : {
              as: "button" as const,
              ...(props.onPressed === undefined
                ? {}
                : { onPressed: props.onPressed }),
              ...(props.ref === undefined ? {} : { ref: props.ref }),
            })}
        {...(id === undefined ? {} : { id })}
        aria-label={attributes["aria-label"] ?? label}
      >
        {presentation.kind === "label" ? (
          <MateoLabelButtonContent
            presentation={presentation}
            foreground={foreground}
          />
        ) : (
          <MateoIconButtonContent
            presentation={presentation}
            foreground={foreground}
          />
        )}
      </MateoPress>
    </span>
  );
}
