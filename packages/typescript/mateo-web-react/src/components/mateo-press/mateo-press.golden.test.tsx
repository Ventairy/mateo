import { MateoPress, MateoSurface } from 'mateo-web-react/react';
import { expect, it } from 'vitest';
import { commands, page, userEvent } from 'vitest/browser';
import {
  captureMateoGolden,
  compareMateoGoldenGroup,
  mateoGoldenTheme,
  renderMateoGoldens,
  settleMateoGolden,
} from '../../../test/golden/mateo-golden.js';

for (const as of ['button', 'div'] as const) {
  it(`should preserve ${as} feedback when exercising interaction states`, async () => {
    for (const state of [
      'resting',
      'disabled',
      'hover',
      'held-pointer',
      'held-space',
      'keyboard-focus',
      'released',
      'reduced-motion',
    ] as const) {
      let activations = 0;
      function onMateoGoldenActivate() {
        activations++;
      }
      const name = `${as}-${state}`;
      const reduced = state === 'reduced-motion';
      if (reduced) await commands.mateoReducedMotion();
      const result = await renderMateoGoldens([
        {
          name,
          content: (
            <MateoPress
              as={as}
              data-testid="press-action"
              aria-label="Save changes"
              {...(state === 'disabled'
                ? {}
                : { onPressed: onMateoGoldenActivate })}
            >
              <MateoSurface
                as={as === 'button' ? 'span' : 'div'}
                padding="12px 24px"
                shape="capsule"
                color={mateoGoldenTheme.colorScheme.accent}
              >
                <span style={{ color: mateoGoldenTheme.colorScheme.onAccent }}>
                  Save changes
                </span>
              </MateoSurface>
            </MateoPress>
          ),
        },
      ]);
      const action = page.getByTestId('press-action');
      if (state === 'hover') await action.hover();
      if (state === 'held-pointer' || reduced || state === 'released')
        await commands.mateoPointerDown('press-action');
      if (state === 'held-space' || state === 'keyboard-focus') {
        await userEvent.tab();
        await expect.element(action).toHaveFocus();
        if (state === 'held-space') await userEvent.keyboard('[Space>]');
      }
      if (state === 'released') {
        await commands.mateoResetInput();
        await expect.poll(() => activations).toBe(1);
        await expect
          .poll(
            () =>
              getComputedStyle(
                action.element().firstElementChild ?? action.element(),
              ).opacity,
          )
          .toBe('1');
      }
      await settleMateoGolden();
      const feedback = action.element().firstElementChild;
      if (!feedback) throw new Error('Missing visible press content');
      const appearance = getComputedStyle(feedback);
      if (
        state === 'held-pointer' ||
        state === 'held-space' ||
        reduced ||
        state === 'hover'
      )
        expect(appearance.opacity).toBe('0.8');
      if (reduced) expect(appearance.transform).toBe('none');
      else if (state === 'held-pointer' || state === 'held-space')
        expect(appearance.transform).not.toBe('none');
      if (state === 'resting' || state === 'released' || state === 'disabled') {
        expect(appearance.opacity).toBe('1');
        expect(appearance.transform).toBe('none');
      }
      if (state === 'disabled') {
        if (as === 'button') await expect.element(action).toBeDisabled();
        else {
          await expect.element(action).toHaveAttribute('aria-disabled', 'true');
          expect(action.element().tabIndex).toBe(-1);
        }
      }
      if (state === 'keyboard-focus') {
        expect(
          Number.parseFloat(getComputedStyle(action.element()).outlineWidth),
        ).toBeGreaterThan(0);
        expect(getComputedStyle(action.element()).outlineStyle).not.toBe(
          'none',
        );
      }
      await captureMateoGolden(name);
      await commands.mateoResetInput();
      await result.unmount();
    }
    await compareMateoGoldenGroup(`${as}-states`);
  });
}
