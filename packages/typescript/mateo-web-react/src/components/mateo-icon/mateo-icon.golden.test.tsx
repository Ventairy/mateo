import {
  MateoIcon,
  type MateoIconName,
  MateoIconProvider,
} from 'mateo-web-react/react';
import { expect, it } from 'vitest';
import {
  captureMateoGoldens,
  mateoGoldenTheme,
  renderMateoGoldens,
} from '../../../test/golden/mateo-golden.js';
import { mateoGoldenIconCatalog } from '../../../test/golden/mateo-icon-catalog.js';

function isMateoGoldenIconName(name: string): name is MateoIconName {
  return Object.hasOwn(mateoGoldenIconCatalog, name);
}

it('should render the complete public artwork catalog when using the default size', async () => {
  const names = Object.keys(mateoGoldenIconCatalog).filter(
    isMateoGoldenIconName,
  );
  const scenarios = names.map((icon) => ({
    name: `catalog-${icon}`,
    content: <MateoIcon icon={icon} aria-label={icon} />,
  }));
  await renderMateoGoldens(scenarios);
  await captureMateoGoldens(scenarios, 'icon-catalog', 5);
});

it('should inherit or override appearance when composing icon scopes and backgrounds', async () => {
  const scenarios = [
    ...[16, 20, 24, 48].map((size) => ({
      name: `size-${size}`,
      content: <MateoIcon icon="checkmark" size={size} />,
    })),
    {
      name: 'inherited-text',
      content: (
        <span style={{ color: mateoGoldenTheme.colorScheme.accent }}>
          <MateoIcon icon="checkmark" />
        </span>
      ),
    },
    {
      name: 'explicit-foreground',
      content: (
        <MateoIcon
          icon="checkmark"
          color={mateoGoldenTheme.colorScheme.accent}
        />
      ),
    },
    {
      name: 'provider',
      content: (
        <MateoIconProvider
          size={32}
          color={mateoGoldenTheme.colorScheme.accent}
        >
          <MateoIcon icon="checkmark" />
        </MateoIconProvider>
      ),
    },
    {
      name: 'nested-provider',
      content: (
        <MateoIconProvider
          size={32}
          color={mateoGoldenTheme.colorScheme.accent}
        >
          <MateoIconProvider size={48}>
            <MateoIcon
              icon="checkmark"
              color={mateoGoldenTheme.colorScheme.text.secondary}
            />
          </MateoIconProvider>
        </MateoIconProvider>
      ),
    },
    {
      name: 'circular-background',
      content: (
        <MateoIcon
          icon="cross"
          size={48}
          color={mateoGoldenTheme.colorScheme.onAccent}
          backgroundColor={mateoGoldenTheme.colorScheme.accent}
        />
      ),
    },
    {
      name: 'repeated-definitions',
      content: (
        <div className="mateo-golden-row">
          <MateoIcon icon="beerMug" size={32} />
          <MateoIcon icon="beerMug" size={48} />
          <MateoIcon icon="boxPencil" size={32} />
        </div>
      ),
    },
  ];
  const result = await renderMateoGoldens(scenarios);
  const ids = Array.from(
    result.container.querySelectorAll('[id]'),
    (element) => element.id,
  );
  expect(new Set(ids).size).toBe(ids.length);
  await captureMateoGoldens(scenarios, 'icon-appearance');
});
