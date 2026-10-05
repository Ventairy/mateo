/** Colors for native scrollbar thumbs. */
export class MateoScrollbarColorScheme {
  /** Color of the draggable scrollbar thumb at rest. */
  readonly thumb: string;
  /** Color of the draggable scrollbar thumb while hovered. */
  readonly thumbHover: string;

  /**
   * Creates an immutable scrollbar color group.
   *
   * @param colors - Colors retained as supplied without validation or derivation.
   */
  constructor(colors: Pick<MateoScrollbarColorScheme, 'thumb' | 'thumbHover'>) {
    this.thumb = colors.thumb;
    this.thumbHover = colors.thumbHover;
    Object.freeze(this);
  }
}
