import { render, screen } from '@testing-library/react';
import { describe, expect, it } from 'vitest';
import { MateoIcon } from './mateo-icon.js';
import {
  MateoIconProvider,
  useMateoIconContext,
} from './mateo-icon-provider.js';

function MateoCustomIcon() {
  const scope = useMateoIconContext();
  return (
    <svg
      aria-label="Custom"
      role="img"
      width={scope.size}
      height={scope.size}
      fill={scope.color}
    />
  );
}

describe('MateoIconProvider', () => {
  it('should inherit omitted defaults when nesting providers', () => {
    render(
      <MateoIconProvider size={24} color="red">
        <MateoIconProvider color="blue">
          <MateoIcon icon="circleCheck" aria-label="Check" />
          <MateoCustomIcon />
        </MateoIconProvider>
      </MateoIconProvider>,
    );
    expect(screen.getByRole('img', { name: 'Check' })).toHaveAttribute(
      'width',
      '24',
    );
    expect(
      screen
        .getByRole('img', { name: 'Check' })
        .style.getPropertyValue('--mateo-icon-color'),
    ).toBe('blue');
    expect(screen.getByRole('img', { name: 'Custom' })).toHaveAttribute(
      'width',
      '24',
    );
    expect(screen.getByRole('img', { name: 'Custom' })).toHaveAttribute(
      'fill',
      'blue',
    );
  });
  it('should retain explicit icon props when provided defaults are present', () => {
    render(
      <MateoIconProvider size={24} color="red">
        <MateoIcon
          icon="circleCheck"
          size={16}
          color="green"
          aria-label="Check"
        />
      </MateoIconProvider>,
    );
    const icon = screen.getByRole('img');
    expect(icon).toHaveAttribute('width', '16');
    expect(icon.style.getPropertyValue('--mateo-icon-color')).toBe('green');
  });
  it('should reject invalid size when an untyped consumer supplies provider defaults', () => {
    expect(() =>
      render(
        <MateoIconProvider size={-1}>
          <MateoIcon icon="cross" />
        </MateoIconProvider>,
      ),
    ).toThrow(TypeError);
  });
});
