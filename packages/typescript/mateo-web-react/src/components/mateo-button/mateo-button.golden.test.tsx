import {
  MateoArrowRightIcon,
  MateoCheckmarkIcon,
  MateoCrossIcon,
  MateoFigureCropCircleIcon,
  MateoPaperPlaneUpRightIcon,
} from '@mateo/web-react/icons';
import {
  MateoButton,
  type MateoButtonColorSchemeOverride,
  type MateoButtonSize,
  type MateoButtonVariant,
  type MateoLabelButtonPresentation,
  MateoTheme,
} from '@mateo/web-react/react';
import { renderToStaticMarkup } from 'react-dom/server';
import { expect, it } from 'vitest';
import { commands, page, userEvent } from 'vitest/browser';
import {
  captureMateoGolden,
  captureMateoGoldens,
  compareMateoGoldenGroup,
  getMateoGoldenElement,
  type MateoGoldenScenario,
  mateoGoldenCustomTheme,
  mateoGoldenTheme,
  renderMateoGoldens,
  settleMateoGolden,
} from '../../../test/golden/mateo-golden.js';

const mateoGoldenButtonVariants = [
  'primary',
  'primary-success',
  'primary-warning',
  'primary-neutral',
  'primary-base',
  'secondary',
  'secondary-neutral',
  'tertiary',
] as const satisfies readonly MateoButtonVariant[];
const mateoGoldenButtonSizes = [
  'mini',
  'small',
  'standard',
] as const satisfies readonly MateoButtonSize[];
const mateoGoldenButtonHeights = { mini: 32, small: 40, standard: 48 } as const;
function onMateoGoldenPressed() {}

it('should render inherited and overridden colors when custom presentations are enabled or disabled', async () => {
  const customColors =
    mateoGoldenCustomTheme.colorScheme.buttons.primary.accent;
  const variantColors = mateoGoldenTheme.colorScheme.buttons.primary.accent;
  const cases: readonly {
    readonly name: string;
    readonly colorScheme: MateoButtonColorSchemeOverride;
  }[] = [
    {
      name: 'background-only',
      colorScheme: { background: customColors.background },
    },
    {
      name: 'disabled-foreground-only',
      colorScheme: {
        foregroundDisabled: mateoGoldenTheme.colorScheme.text.primary,
      },
    },
    { name: 'complete-scheme', colorScheme: customColors },
  ];
  const scenarios = cases.flatMap(({ name, colorScheme }) =>
    [true, false].map((enabled) => ({
      name: `${name}-${enabled ? 'enabled' : 'disabled'}`,
      width: 320,
      colorScheme,
      enabled,
      content: (
        <div className="mateo-golden-row">
          <MateoButton
            presentation={{
              kind: 'label',
              label: 'Continue',
              trailingIcon: <MateoArrowRightIcon />,
              colorScheme,
            }}
            {...(enabled ? { onPressed: onMateoGoldenPressed } : {})}
          />
          <MateoButton
            presentation={{
              kind: 'icon',
              label: 'Continue',
              icon: <MateoArrowRightIcon />,
              colorScheme,
            }}
            {...(enabled ? { onPressed: onMateoGoldenPressed } : {})}
          />
        </div>
      ),
    })),
  );
  await renderMateoGoldens(scenarios);
  await settleMateoGolden();
  for (const { name, colorScheme, enabled } of scenarios) {
    const background = enabled
      ? (colorScheme.background ?? variantColors.background)
      : (colorScheme.backgroundDisabled ?? variantColors.backgroundDisabled);
    const foreground = enabled
      ? (colorScheme.foreground ?? variantColors.foreground)
      : (colorScheme.foregroundDisabled ?? variantColors.foregroundDisabled);
    // Let the browser normalize the theme's color notation for computed styles.
    const reference = document.createElement('span');
    reference.style.color = foreground;
    reference.style.backgroundColor = background;
    document.body.append(reference);
    const expected = getComputedStyle(reference);
    for (const button of page
      .getByTestId(name)
      .getByRole('button')
      .elements()) {
      const surface = button.querySelector('span[style*="background-color"]');
      expect(surface).not.toBeNull();
      if (surface)
        expect(getComputedStyle(surface).backgroundColor).toBe(
          expected.backgroundColor,
        );
      const label = button.querySelector('span[class*="truncate"]');
      if (label) expect(getComputedStyle(label).color).toBe(expected.color);
      const icon = button.querySelector('svg');
      expect(icon).not.toBeNull();
      if (icon) expect(getComputedStyle(icon).color).toBe(expected.color);
      expect(button.hasAttribute('disabled')).toBe(!enabled);
    }
    reference.remove();
  }
  await captureMateoGoldens(scenarios, 'custom-color-overrides');
});

for (const enabled of [true, false]) {
  it(`should preserve every treatment and size when ${enabled ? 'enabled' : 'disabled'}`, async () => {
    const scenarios = mateoGoldenButtonVariants.flatMap((variant) =>
      mateoGoldenButtonSizes.map((size) => ({
        name: `${enabled ? 'enabled' : 'disabled'}-${variant}-${size}`,
        width: 300,
        size,
        content: (
          <div className="mateo-golden-row">
            <MateoButton
              presentation={{
                kind: 'label',
                label: 'Publish',
                variant,
                size,
                trailingIcon: <MateoPaperPlaneUpRightIcon />,
              }}
              {...(enabled ? { onPressed: onMateoGoldenPressed } : {})}
            />
            <MateoButton
              presentation={{
                kind: 'icon',
                label: 'Close',
                icon: <MateoCrossIcon />,
                variant,
                size,
              }}
              {...(enabled ? { onPressed: onMateoGoldenPressed } : {})}
            />
          </div>
        ),
      })),
    );
    await renderMateoGoldens(scenarios);
    await settleMateoGolden();
    for (const scenario of scenarios) {
      const buttons = page.getByTestId(scenario.name).getByRole('button');
      await expect.element(buttons.nth(0)).toHaveAccessibleName('Publish');
      for (const button of buttons.elements()) {
        expect(button.getBoundingClientRect().height).toBe(
          mateoGoldenButtonHeights[scenario.size],
        );
        expect(button.querySelector('svg')).not.toBeNull();
        expect(button.hasAttribute('disabled')).toBe(!enabled);
      }
    }
    await captureMateoGoldens(
      scenarios,
      enabled ? 'enabled-treatments' : 'disabled-treatments',
    );
  });
}

const mateoGoldenButtonContentCases: readonly (MateoLabelButtonPresentation & {
  readonly name: string;
  readonly dir?: 'rtl';
})[] = [
  { name: 'short-label', kind: 'label', label: 'OK' },
  {
    name: 'long-label',
    kind: 'label',
    label: 'Publicar oportunidade para minha comunidade',
    width: 'fill',
  },
  { name: 'fit-width', kind: 'label', label: 'Save changes', width: 'fit' },
  ...(['start', 'center', 'end'] as const).map((alignment) => ({
    name: `fill-${alignment}`,
    kind: 'label' as const,
    label: 'Publish',
    width: 'fill' as const,
    alignment,
  })),
  {
    name: 'leading-icon',
    kind: 'label',
    label: 'Save',
    leadingIcon: <MateoCheckmarkIcon />,
  },
  {
    name: 'trailing-icon',
    kind: 'label',
    label: 'Send',
    trailingIcon: <MateoPaperPlaneUpRightIcon />,
  },
  {
    name: 'both-icons',
    kind: 'label',
    label: 'Send',
    leadingIcon: <MateoCheckmarkIcon />,
    trailingIcon: <MateoPaperPlaneUpRightIcon />,
  },
  {
    name: 'rtl-start',
    dir: 'rtl',
    kind: 'label',
    label: 'Publicar',
    width: 'fill',
    alignment: 'start',
    leadingIcon: <MateoCheckmarkIcon />,
    trailingIcon: <MateoPaperPlaneUpRightIcon />,
  },
];

it('should fit or truncate content and follow direction when composing label presentations', async () => {
  const scenarios = mateoGoldenButtonContentCases.map(
    ({ name, dir, ...presentation }) => ({
      name,
      width: 256,
      ...(dir ? { dir } : {}),
      content: (
        <MateoButton
          presentation={presentation}
          onPressed={onMateoGoldenPressed}
        />
      ),
    }),
  );
  await renderMateoGoldens(scenarios);
  await settleMateoGolden();
  const filled = getMateoGoldenElement('fill-start');
  expect(filled.querySelector('button')?.getBoundingClientRect().width).toBe(
    240,
  );
  const fitted = getMateoGoldenElement('fit-width');
  expect(
    fitted.querySelector('button')?.getBoundingClientRect().width,
  ).toBeLessThan(240);
  const longButton = page.getByTestId('long-label').getByRole('button');
  await expect
    .element(longButton)
    .toHaveAccessibleName('Publicar oportunidade para minha comunidade');
  const label = longButton.element().querySelector('span[class*="truncate"]');
  expect(label?.scrollWidth).toBeGreaterThan(label?.clientWidth ?? 0);
  await captureMateoGoldens(scenarios, 'label-presentations');
});

it('should retain tactile and focus treatment when exercising interaction states', async () => {
  for (const state of ['hover', 'held-pointer', 'keyboard-focus'] as const) {
    for (const variant of ['primary', 'tertiary'] as const) {
      const name = `${variant}-${state}`;
      const scenario: MateoGoldenScenario = {
        name,
        content: (
          <MateoButton
            data-testid="action"
            presentation={{ kind: 'label', label: 'Save changes', variant }}
            onPressed={onMateoGoldenPressed}
          />
        ),
      };
      const result = await renderMateoGoldens([scenario]);
      const action = page.getByTestId('action');
      if (state === 'hover') await action.hover();
      else if (state === 'held-pointer')
        await commands.mateoPointerDown('action');
      else await userEvent.tab();
      await settleMateoGolden();
      if (state === 'keyboard-focus') {
        await expect.element(action).toHaveFocus();
        expect(getComputedStyle(action.element()).outlineStyle).toBe('solid');
        expect(getComputedStyle(action.element()).outlineWidth).toBe('2px');
      } else {
        expect(
          getComputedStyle(
            action.element().firstElementChild ?? action.element(),
          ).opacity,
        ).toBe('0.8');
      }
      await captureMateoGolden(name);
      await commands.mateoResetInput();
      await result.unmount();
    }
  }
  await compareMateoGoldenGroup('button-interaction-states');
});

it('should use the applied accent when consuming a custom theme', async () => {
  const scenarios = [
    {
      name: 'custom-accent',
      content: (
        <MateoButton
          presentation={{ kind: 'label' as const, label: 'Publish' }}
          onPressed={onMateoGoldenPressed}
        />
      ),
    },
  ];
  await renderMateoGoldens(scenarios, mateoGoldenCustomTheme);
  await captureMateoGoldens(scenarios, 'custom-accent');
});

it('should preserve native destination label and icon presentations', async () => {
  const scenarios = mateoGoldenButtonSizes.map((size) => ({
    name: `native-link-${size}`,
    width: 360,
    content: (
      <div className="mateo-golden-row">
        <MateoButton
          as="a"
          href="#profile"
          presentation={{
            kind: 'label',
            label: 'Profile',
            size,
            leadingIcon: <MateoFigureCropCircleIcon />,
          }}
        />
        <MateoButton
          as="a"
          href="#profile"
          presentation={{
            kind: 'icon',
            label: 'Profile',
            size,
            icon: <MateoFigureCropCircleIcon />,
          }}
        />
      </div>
    ),
  }));
  const staticScenario = {
    name: 'native-link-server-rendered',
    width: 360,
    content: (
      <div
        // biome-ignore lint/security/noDangerouslySetInnerHtml: Render fixed public Mateo components to verify their unhydrated appearance.
        dangerouslySetInnerHTML={{
          __html: renderToStaticMarkup(
            <MateoTheme data={mateoGoldenCustomTheme}>
              <MateoButton
                as="a"
                href="#profile"
                presentation={{
                  kind: 'label',
                  label: 'Profile',
                  leadingIcon: <MateoFigureCropCircleIcon />,
                }}
              />
            </MateoTheme>,
          ),
        }}
      />
    ),
  };
  const links = [...scenarios, staticScenario];
  await renderMateoGoldens(links);
  await settleMateoGolden();
  await captureMateoGoldens(links, 'link-presentations');
});
