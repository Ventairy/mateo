import { fireEvent, render, screen } from '@testing-library/react';
import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest';
import { createMateoTheme } from '../../../theme/mateo-theme.js';
import { MateoTheme } from '../../../theme/mateo-theme-context.js';
import { MateoIcon } from '../../mateo-icon/mateo-icon.js';
import { MateoButton } from '../mateo-button.js';
import type { MateoIconButtonPresentation } from './mateo-icon-button-presentation.js';

const mateoIconButtonTestTheme = createMateoTheme({
  accentColor: '#4A5CFF',
  onAccent: '#FFFFFF',
});
class MateoIconButtonTestResizeObserver {
  observe() {}
  disconnect() {}
}
function MateoIconButtonFixture({
  presentation,
  enabled = true,
}: {
  presentation: MateoIconButtonPresentation;
  enabled?: boolean;
}) {
  return (
    <MateoTheme data={mateoIconButtonTestTheme}>
      <MateoButton
        presentation={presentation}
        {...(enabled ? { onPressed: () => {} } : {})}
      />
    </MateoTheme>
  );
}
beforeEach(() =>
  vi.stubGlobal('ResizeObserver', MateoIconButtonTestResizeObserver),
);
afterEach(() => vi.unstubAllGlobals());

describe('Mateo icon button presentation', () => {
  it('should expose one named action when rendering a decorative icon', () => {
    const onPressed = vi.fn();
    render(
      <MateoTheme data={mateoIconButtonTestTheme}>
        <MateoButton
          presentation={{
            kind: 'icon',
            icon: <MateoIcon icon="cross" aria-label="Cross artwork" />,
            label: 'Close menu',
          }}
          onPressed={onPressed}
        />
      </MateoTheme>,
    );
    const button = screen.getByRole('button', { name: 'Close menu' });
    expect(screen.queryByRole('img')).not.toBeInTheDocument();
    expect(screen.queryByText('Close menu')).not.toBeInTheDocument();
    fireEvent.click(button);
    expect(onPressed).toHaveBeenCalledOnce();
  });
  it.each([
    ['mini', 16],
    ['small', 20],
    ['standard', 24],
  ] as const)(
    'should supply icon proportions when using the %s size',
    (size, pixels) => {
      render(
        <MateoIconButtonFixture
          presentation={{
            kind: 'icon',
            label: 'Close',
            icon: <MateoIcon icon="cross" />,
            size,
          }}
        />,
      );
      const button = screen.getByRole('button');
      expect(button.querySelector('svg[viewBox]')).toHaveAttribute(
        'width',
        String(pixels),
      );
    },
  );
  it('should preserve explicit icon customization when changing disabled state', () => {
    const presentation = {
      kind: 'icon',
      label: 'Close',
      icon: <MateoIcon icon="cross" size={12} color="red" />,
    } satisfies MateoIconButtonPresentation;
    const view = render(<MateoIconButtonFixture presentation={presentation} />);
    view.rerender(
      <MateoIconButtonFixture presentation={presentation} enabled={false} />,
    );
    const button = screen.getByRole('button');
    expect(button).toBeDisabled();
    expect(button.querySelector('svg[viewBox]')).toHaveAttribute('width', '12');
    expect(button.querySelector('svg[viewBox]')).toHaveStyle(
      '--mateo-icon-color: red',
    );
  });
  it('should reject an unnamed action when JavaScript supplies an empty label', () => {
    expect(() =>
      render(
        <MateoIconButtonFixture
          presentation={{
            kind: 'icon',
            label: ' ',
            icon: <MateoIcon icon="cross" />,
          }}
        />,
      ),
    ).toThrow(TypeError);
  });
  it('should reject absent icon content when JavaScript supplies an empty presentation', () => {
    expect(() =>
      render(
        <MateoIconButtonFixture
          presentation={{ kind: 'icon', label: 'Close', icon: null }}
        />,
      ),
    ).toThrow(TypeError);
  });
});
