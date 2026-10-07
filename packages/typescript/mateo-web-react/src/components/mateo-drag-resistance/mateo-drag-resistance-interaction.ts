import type {
  MateoDragResistanceReturnAnimation,
  MateoDragResistanceSides,
} from './mateo-drag-resistance.js';
import {
  getMateoDragResistanceReturn,
  mateoDragResistanceMotion,
} from './mateo-drag-resistance-motion.js';

interface MateoDragResistanceOptions {
  readonly resistance: Required<MateoDragResistanceSides>;
  readonly returnAnimation: {
    readonly durationMs: number;
    readonly curve: MateoDragResistanceReturnAnimation['curve'];
  };
}

export function createMateoDragResistance(
  element: HTMLElement | SVGElement,
  options: () => MateoDragResistanceOptions,
) {
  const ownerView = element.ownerDocument.defaultView;
  if (!ownerView)
    throw new Error('MateoDragResistance needs an attached document.');
  const view = ownerView;
  const media = view.matchMedia('(prefers-reduced-motion: reduce)');
  const originalTranslate = element.style.translate;
  const originalWillChange = element.style.willChange;
  let visible = { x: 0, y: 0 };
  let active:
    | {
        pointer: number;
        x: number;
        y: number;
        distanceX: number;
        distanceY: number;
      }
    | undefined;
  let frame: number | undefined;
  let disposed = false;
  let inverse: DOMMatrix | undefined;

  function _measureMateoCoordinates() {
    const parent = element.parentElement;
    inverse =
      parent instanceof SVGGraphicsElement
        ? parent.getScreenCTM()?.inverse()
        : undefined;
  }
  function _renderMateoOffset(x: number, y: number) {
    visible = { x, y };
    const localX = inverse ? inverse.a * x + inverse.c * y : x;
    const localY = inverse ? inverse.b * x + inverse.d * y : y;
    element.style.translate =
      x === 0 && y === 0 ? originalTranslate : `${localX}px ${localY}px`;
  }
  function _stopMateoReturn() {
    if (frame !== undefined) view.cancelAnimationFrame(frame);
    frame = undefined;
  }
  function _restoreMateoStyles() {
    element.style.willChange = originalWillChange;
    element.removeAttribute('data-mateo-dragging');
  }
  function _endMateoCapture() {
    const pointer = active?.pointer;
    active = undefined;
    if (pointer !== undefined && element.hasPointerCapture(pointer))
      element.releasePointerCapture(pointer);
    element.removeAttribute('data-mateo-dragging');
  }
  function _clearMateoOffset() {
    _stopMateoReturn();
    _endMateoCapture();
    _renderMateoOffset(0, 0);
    _restoreMateoStyles();
  }
  function _hasMateoResistance() {
    const { top, right, bottom, left } = options().resistance;
    return top > 0 || right > 0 || bottom > 0 || left > 0;
  }
  function _getMateoLimit(distance: number, axis: 'x' | 'y') {
    const limits = options().resistance;
    return axis === 'x'
      ? distance < 0
        ? limits.left
        : limits.right
      : distance < 0
        ? limits.top
        : limits.bottom;
  }
  function _resolveMateoAxis(distance: number, axis: 'x' | 'y') {
    return (
      (_getMateoLimit(distance, axis) * distance) /
      (mateoDragResistanceMotion.dampingDistancePx + Math.abs(distance))
    );
  }
  function _restoreMateoDistance(offset: number, axis: 'x' | 'y') {
    const maximum = _getMateoLimit(offset, axis);
    if (!offset || !maximum) return 0;
    const fraction = Math.min(1 - Number.EPSILON, Math.abs(offset) / maximum);
    return (
      (Math.sign(offset) *
        mateoDragResistanceMotion.dampingDistancePx *
        fraction) /
      (1 - fraction)
    );
  }
  function _releaseMateoDrag() {
    if (!active) return;
    _endMateoCapture();
    _stopMateoReturn();
    if (media.matches || !_hasMateoResistance() || (!visible.x && !visible.y)) {
      _clearMateoOffset();
      return;
    }
    const { durationMs, curve } = options().returnAnimation;
    if (durationMs === 0) {
      _clearMateoOffset();
      return;
    }
    const start = visible;
    const startedAt = view.performance.now();
    function _animateMateoReturn(now: number) {
      const progress = Math.min(1, (now - startedAt) / durationMs);
      const remaining = 1 - getMateoDragResistanceReturn(progress, curve);
      _renderMateoOffset(
        progress === 1 ? 0 : start.x * remaining,
        progress === 1 ? 0 : start.y * remaining,
      );
      if (progress < 1) frame = view.requestAnimationFrame(_animateMateoReturn);
      else {
        frame = undefined;
        _restoreMateoStyles();
      }
    }
    frame = view.requestAnimationFrame(_animateMateoReturn);
  }
  function _startMateoDrag(event: Event) {
    if (!(event instanceof PointerEvent)) return;
    if (
      disposed ||
      media.matches ||
      !_hasMateoResistance() ||
      active ||
      !event.isPrimary ||
      event.button !== 0
    )
      return;
    if (
      event.target instanceof Element &&
      event.target.closest(
        'a,button,input,select,textarea,[contenteditable]:not([contenteditable="false"]),[role="button"],[role="link"]',
      )
    )
      return;
    _stopMateoReturn();
    _measureMateoCoordinates();
    active = {
      pointer: event.pointerId,
      x: event.clientX,
      y: event.clientY,
      distanceX: _restoreMateoDistance(visible.x, 'x'),
      distanceY: _restoreMateoDistance(visible.y, 'y'),
    };
    element.setPointerCapture(event.pointerId);
    element.style.willChange = 'translate';
    element.setAttribute('data-mateo-dragging', '');
  }
  function _moveMateoDrag(event: Event) {
    if (!(event instanceof PointerEvent)) return;
    if (!active || active.pointer !== event.pointerId) return;
    active.distanceX += event.clientX - active.x;
    active.distanceY += event.clientY - active.y;
    active.x = event.clientX;
    active.y = event.clientY;
    _renderMateoOffset(
      _resolveMateoAxis(active.distanceX, 'x'),
      _resolveMateoAxis(active.distanceY, 'y'),
    );
  }
  function _endMateoDrag(event: Event) {
    if (!(event instanceof PointerEvent)) return;
    if (active?.pointer === event.pointerId) _releaseMateoDrag();
  }
  function _updateMateoPreference() {
    element.toggleAttribute(
      'data-mateo-resistance-disabled',
      disposed || media.matches || !_hasMateoResistance(),
    );
    if (media.matches) _clearMateoOffset();
  }
  function _resizeMateoDrag() {
    _measureMateoCoordinates();
    if (active || frame !== undefined) _renderMateoOffset(visible.x, visible.y);
  }
  function _hideMateoPage(event: PageTransitionEvent) {
    if (!event.persisted) _disposeMateoResistance();
  }
  function _disposeMateoResistance() {
    if (disposed) return;
    disposed = true;
    element.setAttribute('data-mateo-resistance-disabled', '');
    _clearMateoOffset();
    element.removeEventListener('pointerdown', _startMateoDrag);
    element.removeEventListener('pointermove', _moveMateoDrag);
    element.removeEventListener('pointerup', _endMateoDrag);
    element.removeEventListener('pointercancel', _endMateoDrag);
    element.removeEventListener('lostpointercapture', _endMateoDrag);
    view.removeEventListener('blur', _releaseMateoDrag);
    view.removeEventListener('resize', _resizeMateoDrag);
    view.removeEventListener('pagehide', _hideMateoPage);
    media.removeEventListener('change', _updateMateoPreference);
  }
  _updateMateoPreference();
  element.addEventListener('pointerdown', _startMateoDrag);
  element.addEventListener('pointermove', _moveMateoDrag);
  element.addEventListener('pointerup', _endMateoDrag);
  element.addEventListener('pointercancel', _endMateoDrag);
  element.addEventListener('lostpointercapture', _endMateoDrag);
  view.addEventListener('blur', _releaseMateoDrag);
  view.addEventListener('resize', _resizeMateoDrag);
  view.addEventListener('pagehide', _hideMateoPage);
  media.addEventListener('change', _updateMateoPreference);
  return {
    dispose: _disposeMateoResistance,
    update() {
      if (disposed) return;
      _updateMateoPreference();
      if (!_hasMateoResistance() || media.matches) _clearMateoOffset();
      else if (active)
        _renderMateoOffset(
          _resolveMateoAxis(active.distanceX, 'x'),
          _resolveMateoAxis(active.distanceY, 'y'),
        );
      else if (
        Math.abs(visible.x) > _getMateoLimit(visible.x, 'x') ||
        Math.abs(visible.y) > _getMateoLimit(visible.y, 'y')
      )
        _clearMateoOffset();
    },
  };
}
