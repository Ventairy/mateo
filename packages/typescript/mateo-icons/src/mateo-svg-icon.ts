/** Static artwork for composing an SVG icon in a renderer. */
export interface MateoSvgIcon {
  /** SVG coordinate frame. Preserve its aspect ratio and internal spacing. */
  readonly viewBox: string;
  /** Inner SVG elements. Monochrome paint inherits currentColor; full-color artwork retains its colors. SVG IDs must be isolated when composing repeated instances. */
  readonly markup: string;
}
