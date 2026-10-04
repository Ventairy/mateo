'use client';

import { type CSSProperties, createContext, type ReactNode, use } from 'react';

/** Inherited defaults available to MateoIcon and custom icon content. */
export interface MateoIconContextData {
  readonly size?: number | undefined;
  readonly color?: CSSProperties['color'];
}
export interface MateoIconProviderProps extends MateoIconContextData {
  readonly children: ReactNode;
}
const mateoIconContextDefaults: MateoIconContextData = Object.freeze({});
const MateoIconContext = createContext(mateoIconContextDefaults);

/** Set icon defaults without adding an element; explicit icon props take precedence. */
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

/** Read nearest inherited defaults; outside a provider both values are absent. */
export function useMateoIconContext(): MateoIconContextData {
  return use(MateoIconContext);
}
