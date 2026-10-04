'use client';

import { type CSSProperties, createContext, type ReactNode, use } from 'react';

/** Inherited defaults available to MateoIcon and custom icon content. */
export interface MateoIconContextData {
  /**
   * Inherited total square size in pixels. Must be finite and nonnegative; omission
   * keeps the outer provider's size, or leaves the default to each icon.
   */
  readonly size?: number | undefined;
  /**
   * Inherited icon foreground. Omission keeps the outer provider's color, or lets
   * icons use surrounding text color.
   */
  readonly color?: CSSProperties['color'];
}
/**
 * Defaults and children for an inherited icon scope.
 */
export interface MateoIconProviderProps extends MateoIconContextData {
  /**
   * Content receiving these defaults without an additional DOM wrapper.
   */
  readonly children: ReactNode;
}
const mateoIconContextDefaults: MateoIconContextData = Object.freeze({});
const MateoIconContext = createContext(mateoIconContextDefaults);

/**
 * Provides inherited icon size and color without adding a DOM element.
 *
 * @remarks
 * Nested providers override only the supplied defaults. Explicit MateoIcon props
 * take precedence. Custom artwork can read these values with
 * {@link useMateoIconContext}. No theme is required.
 *
 * @throws TypeError - If a supplied size is not finite and nonnegative.
 *
 * @example
 * ```tsx
 * <MateoIconProvider size={24} color="currentColor">
 *   <MateoIcon icon="checkmark" />
 * </MateoIconProvider>
 * ```
 */
export function MateoIconProvider({
  children,
  size,
  color,
}: MateoIconProviderProps) {
  const inherited = useMateoIconContext();
  if (size !== undefined && (!Number.isFinite(size) || size < 0)) {
    throw new TypeError(
      'MateoIconProvider size must be finite and nonnegative.',
    );
  }
  return (
    <MateoIconContext
      value={{ size: size ?? inherited.size, color: color ?? inherited.color }}
    >
      {children}
    </MateoIconContext>
  );
}

/**
 * Reads the nearest inherited icon defaults for custom icon content.
 *
 * @returns The current scope's optional size and color. Both are absent outside
 * a provider; custom artwork should supply its own fallback when needed.
 */
export function useMateoIconContext(): MateoIconContextData {
  return use(MateoIconContext);
}
