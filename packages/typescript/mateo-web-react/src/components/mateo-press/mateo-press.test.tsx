import {
  act,
  cleanup,
  fireEvent,
  render,
  screen,
} from '@testing-library/react';
import { createRef, useState } from 'react';
import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest';
import { createMateoTheme } from '../../theme/mateo-theme.js';
import { MateoTheme } from '../../theme/mateo-theme-context.js';
import { MateoSurface } from '../mateo-surface/mateo-surface.js';
import { MateoPress } from './mateo-press.js';

class MateoTestPointerEvent extends MouseEvent {
  readonly pointerId: number;
  readonly pointerType: string;
  readonly isPrimary: boolean;

  constructor(type: string, init: PointerEventInit = {}) {
    super(type, { bubbles: true, ...init });
    this.pointerId = init.pointerId ?? 1;
    this.pointerType = init.pointerType ?? 'mouse';
    this.isPrimary = init.isPrimary ?? true;
  }
}

function fireMateoPointer(
  target: EventTarget,
  type: string,
  init: PointerEventInit = {},
) {
  act(() => target.dispatchEvent(new MateoTestPointerEvent(type, init)));
}

describe('MateoPress', () => {
  it('should restore keyboard focus indication when keyboard input follows pointer focus', () => {
    render(<MateoPress onPressed={() => {}}>Save</MateoPress>);
    const press = screen.getByRole('button');
    fireMateoPointer(press, 'pointerdown');
    fireMateoPointer(press, 'pointerup');
    fireEvent.click(press, { detail: 1 });
    expect(press).toHaveFocus();
    expect(press).toHaveAttribute('data-mateo-pointer-focus');
    fireEvent.keyDown(press, { key: 'ArrowRight' });
    expect(press).not.toHaveAttribute('data-mateo-pointer-focus');
    expect(press).toHaveFocus();
  });
  it('should leave activation enabled when an asynchronous handler is still pending', () => {
    const onPressed = vi.fn(() => new Promise<void>(() => {}));
    render(<MateoPress onPressed={onPressed}>Save</MateoPress>);
    const press = screen.getByRole('button');
    fireEvent.click(press);
    expect(press).toHaveAttribute('aria-disabled', 'false');
    fireEvent.click(press);
    expect(onPressed).toHaveBeenCalledTimes(2);
  });
  it('should activate immediately once when a pointer click completes inside its content', () => {
    const onPressed = vi.fn();
    render(
      <MateoPress onPressed={onPressed}>
        <span>Save</span>
      </MateoPress>,
    );
    const press = screen.getByRole('button', { name: 'Save' });
    fireMateoPointer(press, 'pointerdown');
    expect(press).toHaveFocus();
    expect(press).toHaveAttribute('data-mateo-pressed');
    expect(press).toHaveAttribute('data-mateo-hovered');
    expect(onPressed).not.toHaveBeenCalled();
    fireMateoPointer(screen.getByText('Save'), 'pointerup');
    fireEvent.click(screen.getByText('Save'), { detail: 1 });
    expect(onPressed).toHaveBeenCalledOnce();
    expect(press).not.toHaveAttribute('data-mateo-pressed');
    expect(press).toHaveAttribute('data-mateo-hovered');
  });

  it('should activate on Enter down and Space up when using the keyboard without repeating', () => {
    const onPressed = vi.fn();
    render(<MateoPress onPressed={onPressed}>Save</MateoPress>);
    const press = screen.getByRole('button');
    press.focus();
    fireEvent.keyDown(press, { key: 'Enter' });
    expect(onPressed).toHaveBeenCalledOnce();
    fireEvent.keyDown(press, { key: 'Enter', repeat: true });
    expect(onPressed).toHaveBeenCalledOnce();
    fireEvent.keyUp(press, { key: 'Enter' });
    fireEvent.keyDown(press, { key: ' ' });
    expect(press).toHaveAttribute('data-mateo-pressed');
    expect(onPressed).toHaveBeenCalledOnce();
    fireEvent.keyUp(press, { key: ' ' });
    expect(onPressed).toHaveBeenCalledTimes(2);
    expect(press).not.toHaveAttribute('data-mateo-pressed');
  });

  it('should suppress feedback and activation when onPressed is absent', () => {
    const ref = createRef<HTMLDivElement>();
    render(
      <MateoPress ref={ref} aria-label="Save changes">
        Save
      </MateoPress>,
    );
    const press = screen.getByRole('button', { name: 'Save changes' });
    expect(ref.current).toBe(press);
    expect(press).toHaveAttribute('aria-disabled', 'true');
    expect(press).toHaveAttribute('tabindex', '-1');
    fireMateoPointer(press, 'pointerover');
    fireMateoPointer(press, 'pointerdown');
    fireEvent.keyDown(press, { key: 'Enter' });
    fireEvent.click(press);
    expect(press).not.toHaveAttribute('data-mateo-hovered');
    expect(press).not.toHaveAttribute('data-mateo-pressed');
  });

  it.each(['pointercancel', 'scroll', 'blur', 'outside release'])(
    'should cancel held feedback and activation when receiving %s',
    (reason) => {
      const onPressed = vi.fn();
      render(<MateoPress onPressed={onPressed}>Save</MateoPress>);
      const press = screen.getByRole('button');
      fireMateoPointer(press, 'pointerdown');
      if (reason === 'pointercancel') fireMateoPointer(press, 'pointercancel');
      else if (reason === 'outside release')
        fireMateoPointer(document.body, 'pointerup');
      else fireEvent(window, new Event(reason));
      expect(press).not.toHaveAttribute('data-mateo-pressed');
      expect(press).not.toHaveAttribute('data-mateo-compressed');
      fireEvent.click(press, { detail: 1 });
      expect(onPressed).not.toHaveBeenCalled();
      // Assistive activation remains available after a cancelled pointer interaction.
      fireEvent.click(press, { detail: 0 });
      expect(onPressed).toHaveBeenCalledOnce();
    },
  );

  it('should resume feedback when a held mouse returns and clear hover when it leaves', () => {
    const onPressed = vi.fn();
    render(<MateoPress onPressed={onPressed}>Save</MateoPress>);
    const press = screen.getByRole('button');
    fireMateoPointer(press, 'pointerover');
    expect(press).toHaveAttribute('data-mateo-hovered');
    fireMateoPointer(press, 'pointerdown');
    fireMateoPointer(press, 'pointerout', { relatedTarget: document.body });
    expect(press).not.toHaveAttribute('data-mateo-pressed');
    expect(press).not.toHaveAttribute('data-mateo-hovered');
    fireMateoPointer(press, 'pointerover', { relatedTarget: document.body });
    expect(press).toHaveAttribute('data-mateo-pressed');
    fireMateoPointer(press, 'pointerup');
    fireEvent.click(press, { detail: 1 });
    expect(onPressed).toHaveBeenCalledOnce();
  });

  it('should show press feedback without sticky hover when activated by touch', () => {
    render(<MateoPress onPressed={() => {}}>Save</MateoPress>);
    const press = screen.getByRole('button');
    fireMateoPointer(press, 'pointerover', { pointerType: 'touch' });
    fireMateoPointer(press, 'pointerdown', { pointerType: 'touch' });
    expect(press).toHaveAttribute('data-mateo-pressed');
    expect(press).not.toHaveAttribute('data-mateo-hovered');
    fireMateoPointer(press, 'pointerup', { pointerType: 'touch' });
    expect(press).not.toHaveAttribute('data-mateo-pressed');
    expect(press).not.toHaveAttribute('data-mateo-hovered');
  });

  it('should ignore secondary contacts and mouse buttons when they do not own the action', () => {
    render(<MateoPress onPressed={() => {}}>Save</MateoPress>);
    const press = screen.getByRole('button');
    fireMateoPointer(press, 'pointerdown', { button: 2 });
    fireMateoPointer(press, 'pointerdown', {
      pointerType: 'touch',
      isPrimary: false,
    });
    expect(press).not.toHaveAttribute('data-mateo-pressed');
    fireMateoPointer(press, 'pointerdown');
    fireMateoPointer(press, 'pointerup', { pointerId: 2 });
    expect(press).toHaveAttribute('data-mateo-pressed');
    fireMateoPointer(press, 'pointerup');
    expect(press).not.toHaveAttribute('data-mateo-pressed');
  });

  it('should cancel a held press when its callback is removed and allow a fresh press after re-enabling', () => {
    const onPressed = vi.fn();
    const view = render(<MateoPress onPressed={onPressed}>Save</MateoPress>);
    const press = screen.getByRole('button');
    fireMateoPointer(press, 'pointerdown');
    view.rerender(<MateoPress>Save</MateoPress>);
    expect(press).not.toHaveAttribute('data-mateo-pressed');
    fireMateoPointer(press, 'pointerup');
    fireEvent.click(press, { detail: 1 });
    expect(onPressed).not.toHaveBeenCalled();
    view.rerender(<MateoPress onPressed={onPressed}>Save</MateoPress>);
    fireMateoPointer(press, 'pointerdown');
    fireMateoPointer(press, 'pointerup');
    fireEvent.click(press, { detail: 1 });
    expect(onPressed).toHaveBeenCalledOnce();
  });

  it('should cancel Space activation when focus leaves before release', () => {
    const onPressed = vi.fn();
    render(<MateoPress onPressed={onPressed}>Save</MateoPress>);
    const press = screen.getByRole('button');
    fireEvent.keyDown(press, { key: ' ' });
    fireEvent.blur(press);
    fireEvent.keyUp(press, { key: ' ' });
    expect(onPressed).not.toHaveBeenCalled();
    expect(press).not.toHaveAttribute('data-mateo-pressed');
  });

  it('should preserve surface child state when feedback and enabled state change', () => {
    const initializeMateoContent = vi.fn(() => 1);
    function MateoStatefulContent() {
      const [value] = useState(initializeMateoContent);
      return <span>Count {value}</span>;
    }
    const theme = createMateoTheme({
      accentColor: '#4A5CFF',
      onAccent: '#FFF',
    });
    function MateoPressFixture({ enabled }: { enabled: boolean }) {
      return (
        <MateoTheme data={theme}>
          <MateoPress {...(enabled ? { onPressed: () => {} } : {})}>
            <MateoSurface padding={16}>
              <MateoStatefulContent />
            </MateoSurface>
          </MateoPress>
        </MateoTheme>
      );
    }
    const view = render(<MateoPressFixture enabled />);
    const content = screen.getByText('Count 1');
    fireMateoPointer(screen.getByRole('button'), 'pointerdown');
    view.rerender(<MateoPressFixture enabled={false} />);
    expect(screen.getByText('Count 1')).toBe(content);
    expect(initializeMateoContent).toHaveBeenCalledOnce();
  });
});

describe('MateoPress feedback completion', () => {
  beforeEach(() => vi.useFakeTimers());
  afterEach(() => {
    cleanup();
    vi.useRealTimers();
    vi.unstubAllGlobals();
  });

  it('should finish compression before returning when a click releases immediately', () => {
    const onPressed = vi.fn();
    render(<MateoPress onPressed={onPressed}>Save</MateoPress>);
    const press = screen.getByRole('button');
    // Exercise a down/up pair in one React batch, before a frame can paint.
    act(() => {
      press.dispatchEvent(new MateoTestPointerEvent('pointerdown'));
      press.dispatchEvent(new MateoTestPointerEvent('pointerup'));
      press.dispatchEvent(
        new MouseEvent('click', { bubbles: true, detail: 1 }),
      );
    });
    expect(onPressed).toHaveBeenCalledOnce();
    expect(press).not.toHaveAttribute('data-mateo-pressed');
    expect(press).toHaveAttribute('data-mateo-compressed');
    act(() => vi.advanceTimersByTime(140));
    expect(press).toHaveAttribute('data-mateo-compressed');
    act(() => vi.advanceTimersByTime(80));
    expect(press).not.toHaveAttribute('data-mateo-compressed');
  });

  it('should return immediately on release when a held press has finished compressing', () => {
    render(<MateoPress onPressed={() => {}}>Save</MateoPress>);
    const press = screen.getByRole('button');
    fireMateoPointer(press, 'pointerdown');
    act(() => vi.advanceTimersByTime(300));
    expect(press).toHaveAttribute('data-mateo-compressed');
    fireMateoPointer(press, 'pointerup');
    expect(press).not.toHaveAttribute('data-mateo-compressed');
  });

  it('should keep the new press compressed when pressing again during unfinished feedback', () => {
    render(<MateoPress onPressed={() => {}}>Save</MateoPress>);
    const press = screen.getByRole('button');
    fireMateoPointer(press, 'pointerdown');
    fireMateoPointer(press, 'pointerup');
    act(() => vi.advanceTimersByTime(80));
    fireMateoPointer(press, 'pointerdown');
    act(() => vi.advanceTimersByTime(300));
    expect(press).toHaveAttribute('data-mateo-compressed');
    fireMateoPointer(press, 'pointerup');
    expect(press).not.toHaveAttribute('data-mateo-compressed');
  });

  it('should skip lingering compression when reduced motion is requested', () => {
    vi.stubGlobal('matchMedia', () => ({
      matches: true,
      addEventListener() {},
      removeEventListener() {},
    }));
    const onPressed = vi.fn();
    render(<MateoPress onPressed={onPressed}>Save</MateoPress>);
    const press = screen.getByRole('button');
    fireMateoPointer(press, 'pointerdown');
    fireMateoPointer(press, 'pointerup');
    fireEvent.click(press, { detail: 1 });
    expect(onPressed).toHaveBeenCalledOnce();
    expect(press).not.toHaveAttribute('data-mateo-compressed');
  });

  it('should clear unfinished feedback when the action becomes unavailable', () => {
    const onPressed = vi.fn();
    const view = render(<MateoPress onPressed={onPressed}>Save</MateoPress>);
    const press = screen.getByRole('button');
    fireMateoPointer(press, 'pointerdown');
    fireMateoPointer(press, 'pointerup');
    view.rerender(<MateoPress>Save</MateoPress>);
    expect(press).not.toHaveAttribute('data-mateo-compressed');
    act(() => vi.advanceTimersByTime(300));
    expect(onPressed).not.toHaveBeenCalled();
  });
});

describe('MateoPress native button composition', () => {
  it('should render one native button and forward its ref when using button mode', () => {
    const ref = createRef<HTMLButtonElement>();
    const onPressed = vi.fn();
    const theme = createMateoTheme({
      accentColor: '#4A5CFF',
      onAccent: '#FFF',
    });
    const { container } = render(
      <MateoTheme data={theme}>
        <MateoPress
          as="button"
          ref={ref}
          id="save-action"
          data-action="save"
          onPressed={onPressed}
        >
          <MateoSurface as="span">Save</MateoSurface>
        </MateoPress>
      </MateoTheme>,
    );
    const button = screen.getByRole('button', { name: 'Save' });
    expect(button.tagName).toBe('BUTTON');
    expect(button).toHaveAttribute('type', 'button');
    expect(button).toHaveAttribute('id', 'save-action');
    expect(button).toHaveAttribute('data-action', 'save');
    expect(ref.current).toBe(button);
    expect(container.querySelectorAll('button, [role="button"]')).toHaveLength(
      1,
    );
    expect(button.querySelector('div')).toBeNull();
    fireEvent.click(button);
    expect(onPressed).toHaveBeenCalledOnce();
  });

  it('should leave keyboard activation to the browser when using button mode', () => {
    const onPressed = vi.fn();
    render(
      <MateoPress as="button" onPressed={onPressed}>
        Save
      </MateoPress>,
    );
    const button = screen.getByRole('button', { name: 'Save' });
    for (const key of ['Enter', ' ']) {
      expect(fireEvent.keyDown(button, { key })).toBe(true);
      expect(button).toHaveAttribute('data-mateo-pressed');
      expect(onPressed).not.toHaveBeenCalled();
      expect(fireEvent.keyUp(button, { key })).toBe(true);
      expect(button).not.toHaveAttribute('data-mateo-pressed');
    }
    fireEvent.click(button, { detail: 0 });
    expect(onPressed).toHaveBeenCalledOnce();
  });

  it('should cancel contact and use native disablement when removing the action', () => {
    const onPressed = vi.fn();
    const view = render(
      <MateoPress as="button" onPressed={onPressed}>
        Save
      </MateoPress>,
    );
    const button = screen.getByRole('button', { name: 'Save' });
    fireMateoPointer(button, 'pointerdown');
    expect(button).toHaveAttribute('data-mateo-pressed');
    view.rerender(<MateoPress as="button">Save</MateoPress>);
    expect(button).toBeDisabled();
    expect(button).not.toHaveAttribute('data-mateo-pressed');
    fireEvent.click(button);
    expect(onPressed).not.toHaveBeenCalled();
    view.rerender(
      <MateoPress as="button" onPressed={onPressed}>
        Save
      </MateoPress>,
    );
    expect(button).toBeEnabled();
    fireEvent.click(button, { detail: 0 });
    expect(onPressed).toHaveBeenCalledOnce();
  });
});
