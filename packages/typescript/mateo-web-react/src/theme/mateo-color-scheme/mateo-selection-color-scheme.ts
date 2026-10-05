/** Colors for selected text. */
export class MateoSelectionColorScheme {
  /** Background color for selected text. */
  readonly background: string;
  /** Foreground color for selected text. */
  readonly foreground: string;

  /**
   * Creates an immutable selection color group.
   *
   * @param colors - Colors retained as supplied without validation or derivation.
   */
  constructor(
    colors: Pick<MateoSelectionColorScheme, 'background' | 'foreground'>,
  ) {
    this.background = colors.background;
    this.foreground = colors.foreground;
    Object.freeze(this);
  }
}
