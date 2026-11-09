export function getMateoScrollTarget(viewport: HTMLElement): HTMLElement {
  const document = viewport.ownerDocument;
  const win = document.defaultView;
  const scroller = document.scrollingElement;
  if (
    !win ||
    !(scroller instanceof win.HTMLElement) ||
    !viewport.hasAttribute('data-mateo-page-scroll') ||
    win.getComputedStyle(viewport).overflowY !== 'visible'
  ) {
    return viewport;
  }

  const view = viewport.closest<HTMLElement>('[data-mateo-page-view]');
  if (!view) return viewport;
  // An outer MateoView can still be embedded in a panel owned by the application.
  const parent = view.parentElement;
  const visibleHeight = win.visualViewport?.height ?? scroller.clientHeight;
  let contained =
    view.clientWidth < scroller.clientWidth - 1 ||
    (parent !== null &&
      parent.clientHeight > 0 &&
      parent.clientHeight < visibleHeight - 1 &&
      parent.clientHeight < view.clientHeight - 1);
  for (
    let ancestor = parent;
    !contained && ancestor && ancestor !== document.body;
    ancestor = ancestor.parentElement
  ) {
    contained = /^(auto|scroll|hidden)$/.test(
      win.getComputedStyle(ancestor).overflowY,
    );
  }
  if (
    contained ||
    document.querySelector(
      '[data-mateo-page-view]:not([data-mateo-contained-view]) [data-mateo-page-scroll]',
    ) !== viewport
  ) {
    view.setAttribute('data-mateo-contained-view', '');
    return viewport;
  }
  return scroller;
}
