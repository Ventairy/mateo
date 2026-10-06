import { MateoIcon, MateoPress, MateoSurface } from 'mateo-web-react/react';
import { expect, it } from 'vitest';
import { commands, page, userEvent } from 'vitest/browser';
import { render } from 'vitest-browser-react';
import {
  captureMateoGolden,
  compareMateoGoldenGroup,
  mateoGoldenTheme,
  renderMateoGoldens,
  settleMateoGolden,
} from '../../../test/golden/mateo-golden.js';

for (const pressAnimation of ['scale', 'none'] as const) {
  for (const as of ['button', 'div'] as const) {
    it(`should preserve ${as} ${pressAnimation} feedback when exercising interaction states`, async () => {
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
        const name = `${as}-${pressAnimation === 'none' ? 'none-' : ''}${state}`;
        const reduced = state === 'reduced-motion';
        if (reduced) await commands.mateoReducedMotion();
        const result = await renderMateoGoldens([
          {
            name,
            content: (
              <MateoPress
                as={as}
                {...(pressAnimation === 'none' ? { pressAnimation } : {})}
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
                  <span
                    style={{ color: mateoGoldenTheme.colorScheme.onAccent }}
                  >
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
          expect(appearance.opacity).toBe(
            pressAnimation === 'none' && state === 'held-space' ? '1' : '0.8',
          );
        if (reduced || pressAnimation === 'none')
          expect(appearance.transform).toBe('none');
        else if (state === 'held-pointer' || state === 'held-space')
          expect(appearance.transform).not.toBe('none');
        if (
          state === 'resting' ||
          state === 'released' ||
          state === 'disabled'
        ) {
          expect(appearance.opacity).toBe('1');
          expect(appearance.transform).toBe('none');
        }
        if (state === 'disabled') {
          if (as === 'button') await expect.element(action).toBeDisabled();
          else {
            await expect
              .element(action)
              .toHaveAttribute('aria-disabled', 'true');
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
        if (state === 'held-space' || state === 'held-pointer')
          await expect.poll(() => activations).toBe(1);
        await result.unmount();
      }
      await compareMateoGoldenGroup(
        `${as}-${pressAnimation === 'none' ? 'none-' : ''}states`,
      );
    });
  }
}

for (const as of ['button', 'div'] as const) {
  it(`should activate ${as} from the keyboard when press animation is none`, async () => {
    let activations = 0;
    const result = await renderMateoGoldens([
      {
        name: 'keyboard-activation',
        content: (
          <MateoPress
            as={as}
            pressAnimation="none"
            onPressed={() => {
              activations++;
            }}
          >
            Save
          </MateoPress>
        ),
      },
    ]);
    const action = page.getByRole('button', { name: 'Save' });
    await userEvent.tab();
    await userEvent.keyboard('[Enter]');
    await expect.poll(() => activations).toBe(1);
    await userEvent.keyboard('[Space>]');
    await settleMateoGolden();
    const feedback = action.element().firstElementChild;
    if (!feedback) throw new Error('Missing visible press content');
    expect(getComputedStyle(feedback).transform).toBe('none');
    expect(getComputedStyle(feedback).opacity).toBe('1');
    await userEvent.keyboard('[/Space]');
    await expect.poll(() => activations).toBe(2);
    await result.unmount();
  });

  it(`should restore ${as} content immediately when changing an active animation to none`, async () => {
    let activations = 0;
    function onMateoActivate() {
      activations++;
    }
    const result = await render(
      <MateoPress
        as={as}
        data-testid="press-action"
        onPressed={onMateoActivate}
      >
        Save
      </MateoPress>,
    );
    const action = page.getByTestId('press-action');
    const feedback = action.element().firstElementChild;
    if (!feedback) throw new Error('Missing visible press content');
    const restingBounds = feedback.getBoundingClientRect();
    await commands.mateoPointerDown('press-action');
    await settleMateoGolden();
    expect(getComputedStyle(feedback).transform).not.toBe('none');
    await result.rerender(
      <MateoPress
        as={as}
        data-testid="press-action"
        pressAnimation="none"
        onPressed={onMateoActivate}
      >
        Save
      </MateoPress>,
    );
    expect(getComputedStyle(feedback).transform).toBe('none');
    expect(feedback.getBoundingClientRect().width).toBe(restingBounds.width);
    expect(feedback.getBoundingClientRect().height).toBe(restingBounds.height);
    await commands.mateoResetInput();
    await expect.poll(() => activations).toBe(1);
    await result.unmount();
  });
}

for (const pressAnimation of ['scale', 'none'] as const) {
  it(`should preserve native link ${pressAnimation} feedback when exercising text and icon states`, async () => {
    for (const content of ['text', 'icon'] as const) {
      for (const state of [
        'resting',
        'hover',
        'held-pointer',
        'keyboard-focus',
        'reduced-motion',
        'forced-colors',
      ] as const) {
        if (state === 'reduced-motion') await commands.mateoReducedMotion();
        if (state === 'forced-colors') await commands.mateoForcedColors(true);
        const name = `link-${pressAnimation}-${content}-${state}`;
        const result = await renderMateoGoldens([
          {
            name,
            width: 240,
            content: (
              <span
                style={{ color: mateoGoldenTheme.colorScheme.text.primary }}
              >
                <MateoPress
                  as="a"
                  href="#profile"
                  pressAnimation={pressAnimation}
                  data-testid="press-link"
                  aria-label="Profile"
                >
                  <span style={{ display: 'block', padding: 12 }}>
                    {content === 'text' ? (
                      'View profile'
                    ) : (
                      <MateoIcon
                        icon="instagramLogo"
                        size={24}
                        color={mateoGoldenTheme.colorScheme.text.primary}
                      />
                    )}
                  </span>
                </MateoPress>
              </span>
            ),
          },
        ]);
        const link = page.getByTestId('press-link');
        if (state === 'hover') await link.hover();
        if (state === 'held-pointer' || state === 'reduced-motion')
          await commands.mateoPointerDown('press-link');
        if (state === 'keyboard-focus' || state === 'forced-colors')
          await userEvent.tab();
        await settleMateoGolden();
        await captureMateoGolden(name);
        await commands.mateoResetInput();
        await result.unmount();
      }
    }
    await compareMateoGoldenGroup(`link-${pressAnimation}-states`);
  });
}
