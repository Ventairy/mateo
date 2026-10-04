import { act, fireEvent, render, screen } from '@testing-library/react';
import { createRef } from 'react';
import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest';
import { createMateoTheme } from '../../theme/mateo-theme.js';
import { MateoTheme } from '../../theme/mateo-theme-context.js';
import { MateoIcon } from '../mateo-icon/mateo-icon.js';
import { useMateoIconContext } from '../mateo-icon/mateo-icon-provider.js';
import { MateoButton, type MateoButtonProps } from './mateo-button.js';
import type { MateoButtonPresentation } from './mateo-button-presentation.js';

const mateoButtonTestTheme = createMateoTheme({
  accentColor: '#4A5CFF',
  onAccent: '#FFFFFF',
});
class MateoButtonTestResizeObserver {
  observe() {}
  disconnect() {}
}
class MateoButtonTestPointerEvent extends MouseEvent {
  readonly pointerId = 1;
  readonly pointerType = 'mouse';
  readonly isPrimary = true;
}
function fireMateoButtonPointer(target: EventTarget, type: string) {
  act(() =>
    target.dispatchEvent(
      new MateoButtonTestPointerEvent(type, { bubbles: true }),
    ),
  );
}
function MateoButtonFixture(props: MateoButtonProps) {
  return (
    <MateoTheme data={mateoButtonTestTheme}>
      <MateoButton {...props} />
    </MateoTheme>
  );
}
function MateoButtonTrigger({
  buttonPresentation,
  onPressed,
}: {
  buttonPresentation: MateoButtonPresentation;
  onPressed: () => void;
}) {
  return (
    <MateoButtonFixture
      presentation={buttonPresentation}
      onPressed={onPressed}
      aria-haspopup="menu"
    />
  );
}
function MateoButtonCustomIcon() {
  const scope = useMateoIconContext();
  return (
    <svg
      role="img"
      aria-label="Custom icon"
      width={scope.size}
      fill={scope.color}
    />
  );
}

afterEach(() => vi.unstubAllGlobals());

beforeEach(() =>
  vi.stubGlobal('ResizeObserver', MateoButtonTestResizeObserver),
);

describe('MateoButton', () => {
  const colors = mateoButtonTestTheme.colorScheme.buttons;
  it.each([
    ['primary', colors.primary.accent],
    ['primary-success', colors.primary.success],
    ['primary-warning', colors.primary.warning],
    ['primary-neutral', colors.primary.neutral],
    ['primary-base', colors.primary.base],
    ['secondary', colors.secondary.accent],
    ['secondary-neutral', colors.secondary.neutral],
    ['tertiary', colors.tertiary],
  ] as const)(
    'should apply enabled and disabled colors when choosing %s',
    (variant, treatment) => {
      const presentation = {
        kind: 'label',
        label: 'Save',
        variant,
      } satisfies MateoButtonPresentation;
      const view = render(
        <MateoButtonFixture presentation={presentation} onPressed={() => {}} />,
      );
      const button = screen.getByRole('button');
      expect(
        button.parentElement?.style.getPropertyValue(
          '--mateo-button-background',
        ),
      ).toBe(treatment.background);
      expect(
        button.parentElement?.style.getPropertyValue(
          '--mateo-button-foreground',
        ),
      ).toBe(treatment.foreground);
      view.rerender(
        <MateoButtonFixture
          presentation={presentation}
          aria-disabled={false}
        />,
      );
      expect(button).toBeDisabled();
      expect(button).toHaveAttribute('aria-disabled', 'true');
      expect(
        button.parentElement?.style.getPropertyValue(
          '--mateo-button-background',
        ),
      ).toBe(treatment.backgroundDisabled);
      expect(
        button.parentElement?.style.getPropertyValue(
          '--mateo-button-foreground',
        ),
      ).toBe(treatment.foregroundDisabled);
    },
  );

  it('should expose a native trigger when a higher-level component forwards its presentation', () => {
    const onPressed = vi.fn();
    render(
      <MateoButtonTrigger
        buttonPresentation={{ kind: 'label', label: 'More actions' }}
        onPressed={onPressed}
      />,
    );
    const button = screen.getByRole('button', { name: 'More actions' });
    expect(button.tagName).toBe('BUTTON');
    expect(button).toHaveAttribute('type', 'button');
    expect(button).toHaveAttribute('aria-haspopup', 'menu');
    fireEvent.click(button);
    expect(onPressed).toHaveBeenCalledOnce();
  });
  it('should keep the full action name and supply decorative defaults when rendering custom icon slots', () => {
    render(
      <MateoButtonFixture
        presentation={{
          kind: 'label',
          label: 'Save all changes in this project',
          size: 'small',
          leadingIcon: <MateoIcon icon="circleCheck" aria-label="Check" />,
          trailingIcon: <MateoButtonCustomIcon />,
        }}
        onPressed={() => {}}
      />,
    );
    const button = screen.getByRole('button', {
      name: 'Save all changes in this project',
    });
    expect(screen.queryByRole('img')).not.toBeInTheDocument();
    for (const icon of button.querySelectorAll('svg[role="img"]'))
      expect(icon).toHaveAttribute('width', '20');
    expect(
      button.querySelector('svg[aria-label="Custom icon"]'),
    ).toHaveAttribute(
      'fill',
      mateoButtonTestTheme.colorScheme.buttons.primary.accent.foreground,
    );
  });
  it('should retain native keyboard activation when receiving Enter and Space events', () => {
    const onPressed = vi.fn();
    render(
      <MateoButtonFixture
        presentation={{ kind: 'label', label: 'Save' }}
        onPressed={onPressed}
      />,
    );
    const button = screen.getByRole('button');
    button.focus();
    for (const key of ['Enter', ' ']) {
      expect(fireEvent.keyDown(button, { key })).toBe(true);
      expect(button).toHaveAttribute('data-mateo-pressed');
      expect(fireEvent.keyUp(button, { key })).toBe(true);
      // jsdom does not perform native keyboard activation. A browser supplies this click.
      fireEvent.click(button, { detail: 0 });
    }
    expect(onPressed).toHaveBeenCalledTimes(2);
  });
  it('should cancel feedback and suppress the pointer click when a contact is cancelled', () => {
    const onPressed = vi.fn();
    render(
      <MateoButtonFixture
        presentation={{ kind: 'label', label: 'Save' }}
        onPressed={onPressed}
      />,
    );
    const button = screen.getByRole('button');
    fireMateoButtonPointer(button, 'pointerdown');
    expect(button).toHaveAttribute('data-mateo-compressed');
    fireMateoButtonPointer(button, 'pointercancel');
    expect(button).not.toHaveAttribute('data-mateo-compressed');
    fireEvent.click(button, { detail: 1 });
    expect(onPressed).not.toHaveBeenCalled();
  });
  it('should disable a held action when its callback is removed and permit fresh activation when restored', () => {
    const onPressed = vi.fn();
    const ref = createRef<HTMLButtonElement>();
    const presentation = {
      kind: 'label',
      label: 'Save',
    } satisfies MateoButtonPresentation;
    const view = render(
      <MateoButtonFixture
        presentation={presentation}
        onPressed={onPressed}
        ref={ref}
      />,
    );
    const button = screen.getByRole('button');
    expect(ref.current).toBe(button);
    fireMateoButtonPointer(button, 'pointerdown');
    view.rerender(<MateoButtonFixture presentation={presentation} />);
    expect(button).toBeDisabled();
    expect(button).not.toHaveAttribute('data-mateo-compressed');
    fireEvent.click(button);
    expect(onPressed).not.toHaveBeenCalled();
    view.rerender(
      <MateoButtonFixture presentation={presentation} onPressed={onPressed} />,
    );
    fireEvent.click(button);
    expect(onPressed).toHaveBeenCalledOnce();
  });
  it('should allow repeated activation when an asynchronous action is pending', () => {
    const onPressed = vi.fn(() => new Promise<void>(() => {}));
    render(
      <MateoButtonFixture
        presentation={{ kind: 'label', label: 'Save' }}
        onPressed={onPressed}
      />,
    );
    const button = screen.getByRole('button');
    fireEvent.click(button);
    fireEvent.click(button);
    expect(button).toBeEnabled();
    expect(onPressed).toHaveBeenCalledTimes(2);
    expect(screen.getByRole('button', { name: 'Save' })).toBe(button);
  });
  it('should use the nearest theme colors when theme data changes', () => {
    const alternate = createMateoTheme({
      accentColor: '#00A86B',
      onAccent: '#000000',
    });
    const view = render(
      <MateoButtonFixture
        presentation={{ kind: 'label', label: 'Save' }}
        onPressed={() => {}}
      />,
    );
    view.rerender(
      <MateoTheme data={alternate}>
        <MateoButton
          presentation={{ kind: 'label', label: 'Save' }}
          onPressed={() => {}}
        />
      </MateoTheme>,
    );
    expect(
      screen
        .getByRole('button')
        .parentElement?.style.getPropertyValue('--mateo-button-background'),
    ).toBe(alternate.colorScheme.buttons.primary.accent.background);
  });
  it('should reject unsupported presentation values when called from JavaScript', () => {
    expect(() =>
      render(
        <MateoButtonFixture
          presentation={JSON.parse(
            '{"kind":"label","label":"Save","variant":"typo"}',
          )}
        />,
      ),
    ).toThrow(TypeError);
  });
});
