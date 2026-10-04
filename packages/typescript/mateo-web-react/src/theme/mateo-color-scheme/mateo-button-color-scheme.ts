/** Immutable semantic color roles. */
export class MateoButtonColorScheme {
  readonly background: string;
  readonly foreground: string;
  readonly backgroundDisabled: string;
  readonly foregroundDisabled: string;

  constructor(
    colors: Pick<
      MateoButtonColorScheme,
      'background' | 'foreground' | 'backgroundDisabled' | 'foregroundDisabled'
    >,
  ) {
    this.background = colors.background;
    this.foreground = colors.foreground;
    this.backgroundDisabled = colors.backgroundDisabled;
    this.foregroundDisabled = colors.foregroundDisabled;
    Object.freeze(this);
  }
}
