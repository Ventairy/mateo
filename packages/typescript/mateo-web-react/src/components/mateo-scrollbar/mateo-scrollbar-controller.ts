import { mateoScrollbarDimensions } from '../../theme/mateo-scrollbar.js';

const mateoScrollbarOwners = new WeakSet<HTMLElement>();
const mateoScrollbarInteraction = Object.freeze({
  minimumThumbPx: 24,
  arrowStepPx: 40,
  pageFraction: 0.9,
});
type MateoScrollbarAxis = 'vertical' | 'horizontal';
interface MateoScrollbarGeometry {
  readonly maximum: number;
  readonly extent: number;
  readonly trackLength: number;
  readonly travel: number;
  readonly position: number;
  readonly rtl: boolean;
}

function _clampMateoScroll(value: number, maximum: number) {
  return Math.max(0, Math.min(maximum, value));
}

// CSS hiding is scoped to the target; nested native viewports remain untouched.
export function attachMateoScrollbar(
  target: HTMLElement,
  vertical: HTMLDivElement,
  horizontal: HTMLDivElement,
  id: string,
  label?: string,
  labelledBy?: string,
) {
  if (mateoScrollbarOwners.has(target))
    throw new Error('Only one MateoScrollbar may control a viewport.');
  const ownerWindow = target.ownerDocument.defaultView;
  if (!ownerWindow) return;
  const win = ownerWindow;
  mateoScrollbarOwners.add(target);
  const originalId = target.getAttribute('id');
  const originalMarker = target.getAttribute('data-mateo-overlay-scrollbar');
  const targetId = originalId || id;
  if (!originalId) target.id = targetId;
  const forcedColors = win.matchMedia('(forced-colors: active)');
  const listeners = new AbortController();
  const signal = listeners.signal;
  let frame = 0;
  let geometry = new Map<MateoScrollbarAxis, MateoScrollbarGeometry>();
  let drag:
    | {
        axis: MateoScrollbarAxis;
        track: HTMLDivElement;
        pointerId: number;
        grab: number;
      }
    | undefined;
  const tracks = { vertical, horizontal };
  // CSSOM keeps this declaration live as inherited direction changes.
  const targetStyle = win.getComputedStyle(target);
  let appliedForced: boolean | undefined;
  let appliedLabel: string | null | undefined;
  let appliedLabelledBy: string | null | undefined;

  function _endMateoDrag() {
    const active = drag;
    drag = undefined;
    if (!active) return;
    active.track.removeAttribute('data-dragging');
    if (active.track.hasPointerCapture(active.pointerId))
      active.track.releasePointerCapture(active.pointerId);
  }
  function _setMateoScroll(axis: MateoScrollbarAxis, value: number) {
    const current = geometry.get(axis);
    if (!current) return;
    const position = _clampMateoScroll(value, current.maximum);
    target.scrollTo(
      axis === 'vertical'
        ? { top: position, behavior: 'instant' }
        : { left: current.rtl ? -position : position, behavior: 'instant' },
    );
    _updateMateoScrollbar();
  }
  function _updateMateoScrollbar() {
    if (frame) win.cancelAnimationFrame(frame);
    frame = 0;
    const forced = forcedColors.matches;
    const presentationChanged = appliedForced !== forced;
    if (forced && presentationChanged) {
      _endMateoDrag();
      if (
        target.ownerDocument.activeElement === vertical ||
        target.ownerDocument.activeElement === horizontal
      )
        target.focus({ preventScroll: true });
      if (originalMarker === null)
        target.removeAttribute('data-mateo-overlay-scrollbar');
      else target.setAttribute('data-mateo-overlay-scrollbar', originalMarker);
    } else if (presentationChanged)
      target.setAttribute('data-mateo-overlay-scrollbar', '');
    const rtl = targetStyle.direction === 'rtl';
    const width = target.clientWidth;
    const height = target.clientHeight;
    const scrollWidth = target.scrollWidth;
    const scrollHeight = target.scrollHeight;
    const scrollLeft = target.scrollLeft;
    const scrollTop = target.scrollTop;
    const maxima = {
      vertical: Math.max(0, scrollHeight - height),
      horizontal: Math.max(0, scrollWidth - width),
    };
    const inheritedLabel = label ?? target.getAttribute('aria-label');
    const inheritedLabelledBy =
      labelledBy ??
      (label === undefined ? target.getAttribute('aria-labelledby') : null);
    const accessibilityChanged =
      appliedLabel !== inheritedLabel ||
      appliedLabelledBy !== inheritedLabelledBy;
    const next = new Map<MateoScrollbarAxis, MateoScrollbarGeometry>();
    // Read geometry first; apply all visual updates afterwards.
    for (const axis of ['vertical', 'horizontal'] as const) {
      const extent = axis === 'vertical' ? height : width;
      const other = axis === 'vertical' ? 'horizontal' : 'vertical';
      const trackLength = Math.max(
        0,
        extent - (maxima[other] > 0 ? mateoScrollbarDimensions.sizePx : 0),
      );
      const maximum = maxima[axis];
      const length = Math.min(
        trackLength,
        Math.max(
          mateoScrollbarInteraction.minimumThumbPx,
          (trackLength * extent) / (extent + maximum || 1),
        ),
      );
      const position = _clampMateoScroll(
        axis === 'vertical' ? scrollTop : rtl ? -scrollLeft : scrollLeft,
        maximum,
      );
      const travel = trackLength - length;
      next.set(axis, { maximum, extent, trackLength, position, travel, rtl });
      const previous = geometry.get(axis);
      if (
        !presentationChanged &&
        !accessibilityChanged &&
        previous?.maximum === maximum &&
        previous.extent === extent &&
        previous.trackLength === trackLength &&
        previous.position === position &&
        previous.travel === travel &&
        previous.rtl === rtl
      )
        continue;
      const track = tracks[axis];
      track.dir = rtl ? 'rtl' : 'ltr';
      track.style.setProperty('--mateo-scrollbar-track', `${trackLength}px`);
      track.style.setProperty('--mateo-scrollbar-length', `${length}px`);
      const fraction = maximum > 0 ? position / maximum : 0;
      track.style.setProperty(
        '--mateo-scrollbar-position',
        `${travel * (axis === 'horizontal' && rtl ? 1 - fraction : fraction)}px`,
      );
      const visible = !forced && maximum > 0 && trackLength > 0;
      if (!visible && target.ownerDocument.activeElement === track)
        target.focus({ preventScroll: true });
      track.style.setProperty(
        '--mateo-scrollbar-display',
        visible ? 'block' : 'none',
      );
      track.tabIndex = visible ? 0 : -1;
      track.setAttribute('aria-valuenow', `${Math.round(fraction * 100)}`);
      track.setAttribute('aria-controls', targetId);
      if (inheritedLabel) track.setAttribute('aria-label', inheritedLabel);
      else track.removeAttribute('aria-label');
      if (inheritedLabelledBy)
        track.setAttribute('aria-labelledby', inheritedLabelledBy);
      else track.removeAttribute('aria-labelledby');
    }
    appliedForced = forced;
    appliedLabel = inheritedLabel;
    appliedLabelledBy = inheritedLabelledBy;
    geometry = next;
    if (drag && (forced || !geometry.get(drag.axis)?.maximum)) _endMateoDrag();
  }
  function _scheduleMateoScrollbar() {
    if (!frame) frame = win.requestAnimationFrame(_updateMateoScrollbar);
  }
  const resize = new ResizeObserver(_scheduleMateoScrollbar);
  const observed = new Set<Element>();
  function _observeMateoElement(element: Element) {
    if (observed.has(element)) return;
    observed.add(element);
    resize.observe(element);
  }
  function _observeMateoSubtree(node: Node) {
    if (!(node instanceof win.Element) || !target.contains(node)) return;
    _observeMateoElement(node);
    for (const child of node.querySelectorAll('*')) _observeMateoElement(child);
  }
  function _releaseMateoSubtree(node: Node) {
    if (!(node instanceof win.Element) || target.contains(node)) return;
    for (const element of [node, ...node.querySelectorAll('*')]) {
      if (!observed.delete(element)) continue;
      resize.unobserve(element);
    }
  }
  // These properties change paint, never the native scrollable overflow.
  const paintOnly = new Set(['opacity', 'color', 'background-color']);
  const previousStyle = target.ownerDocument.createElement('div').style;
  const currentStyle = target.ownerDocument.createElement('div').style;
  function _changesMateoGeometryStyle(record: MutationRecord) {
    if (!(record.target instanceof win.Element)) return true;
    const inlineStyle = record.target.getAttribute('style');
    if (inlineStyle === record.oldValue) return false;
    previousStyle.cssText = record.oldValue ?? '';
    currentStyle.cssText = inlineStyle ?? '';
    for (const property of new Set([...previousStyle, ...currentStyle])) {
      if (
        !paintOnly.has(property) &&
        (previousStyle.getPropertyValue(property) !==
          currentStyle.getPropertyValue(property) ||
          previousStyle.getPropertyPriority(property) !==
            currentStyle.getPropertyPriority(property))
      )
        return true;
    }
    return false;
  }
  const mutation = new MutationObserver((records) => {
    let changed = frame !== 0;
    for (const record of records) {
      if (record.type === 'childList') {
        for (const node of record.removedNodes) _releaseMateoSubtree(node);
        for (const node of record.addedNodes) _observeMateoSubtree(node);
      }
      if (
        !changed &&
        (record.type !== 'attributes' ||
          record.attributeName !== 'style' ||
          _changesMateoGeometryStyle(record))
      )
        changed = true;
    }
    if (changed) _scheduleMateoScrollbar();
  });
  // Watch content/style changes, not our target marker or scrolling ARIA writes.
  mutation.observe(target, {
    subtree: true,
    childList: true,
    characterData: true,
    attributes: true,
    attributeOldValue: true,
    attributeFilter: [
      'style',
      'class',
      'dir',
      'hidden',
      'aria-label',
      'aria-labelledby',
    ],
  });
  _observeMateoSubtree(target);
  target.addEventListener('scroll', _scheduleMateoScrollbar, {
    passive: true,
    signal,
  });
  forcedColors.addEventListener('change', _updateMateoScrollbar, { signal });
  win.addEventListener('blur', _endMateoDrag, { signal });
  for (const axis of ['vertical', 'horizontal'] as const) {
    const track = tracks[axis];
    track.addEventListener(
      'pointerdown',
      (event) => {
        if (
          event.button !== 0 ||
          !event.isPrimary ||
          forcedColors.matches ||
          drag
        )
          return;
        const current = geometry.get(axis);
        if (!current?.maximum) return;
        event.preventDefault();
        track.focus({ preventScroll: true });
        const bounds = track.getBoundingClientRect();
        const coordinate =
          axis === 'vertical'
            ? event.clientY - bounds.top
            : event.clientX - bounds.left;
        const fraction = current.position / current.maximum;
        const start =
          current.travel *
          (axis === 'horizontal' && current.rtl ? 1 - fraction : fraction);
        if (event.target !== track) {
          drag = {
            axis,
            track,
            pointerId: event.pointerId,
            grab: coordinate - start,
          };
          track.setPointerCapture(event.pointerId);
          track.setAttribute('data-dragging', '');
        } else {
          const direction =
            (coordinate < start ? -1 : 1) *
            (axis === 'horizontal' && current.rtl ? -1 : 1);
          _setMateoScroll(
            axis,
            current.position +
              direction *
                current.extent *
                mateoScrollbarInteraction.pageFraction,
          );
        }
      },
      { signal },
    );
    track.addEventListener(
      'pointermove',
      (event) => {
        if (!drag || drag.track !== track || drag.pointerId !== event.pointerId)
          return;
        const current = geometry.get(axis);
        if (!current?.travel) return;
        const bounds = track.getBoundingClientRect();
        const coordinate =
          axis === 'vertical'
            ? event.clientY - bounds.top
            : event.clientX - bounds.left;
        const fraction =
          _clampMateoScroll(coordinate - drag.grab, current.travel) /
          current.travel;
        _setMateoScroll(
          axis,
          (axis === 'horizontal' && current.rtl ? 1 - fraction : fraction) *
            current.maximum,
        );
      },
      { signal },
    );
    for (const event of [
      'pointerup',
      'pointercancel',
      'lostpointercapture',
    ] as const)
      track.addEventListener(
        event,
        (event) => {
          if (drag?.pointerId === event.pointerId) _endMateoDrag();
        },
        { signal },
      );
    track.addEventListener(
      'keydown',
      (event) => {
        const current = geometry.get(axis);
        if (!current?.maximum || forcedColors.matches) return;
        let next: number;
        const step = mateoScrollbarInteraction.arrowStepPx;
        const page = current.extent * mateoScrollbarInteraction.pageFraction;
        switch (event.key) {
          case 'Home':
            next = 0;
            break;
          case 'End':
            next = current.maximum;
            break;
          case 'PageUp':
            next = current.position - page;
            break;
          case 'PageDown':
            next = current.position + page;
            break;
          case 'ArrowUp':
            if (axis !== 'vertical') return;
            next = current.position - step;
            break;
          case 'ArrowDown':
            if (axis !== 'vertical') return;
            next = current.position + step;
            break;
          case 'ArrowLeft':
            if (axis !== 'horizontal') return;
            next = current.position + (current.rtl ? step : -step);
            break;
          case 'ArrowRight':
            if (axis !== 'horizontal') return;
            next = current.position + (current.rtl ? -step : step);
            break;
          default:
            return;
        }
        event.preventDefault();
        _setMateoScroll(axis, next);
      },
      { signal },
    );
  }
  _updateMateoScrollbar();
  return () => {
    _endMateoDrag();
    listeners.abort();
    resize.disconnect();
    observed.clear();
    mutation.disconnect();
    if (frame) win.cancelAnimationFrame(frame);
    mateoScrollbarOwners.delete(target);
    if (originalMarker === null)
      target.removeAttribute('data-mateo-overlay-scrollbar');
    else target.setAttribute('data-mateo-overlay-scrollbar', originalMarker);
    if (!originalId && target.id === targetId) {
      if (originalId === null) target.removeAttribute('id');
      else target.id = originalId;
    }
  };
}
