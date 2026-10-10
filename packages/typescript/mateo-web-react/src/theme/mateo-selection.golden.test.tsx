import { createMateoTheme, getMateoThemeStyle } from '@mateo/web-react';
import { expect, it } from 'vitest';
import { commands } from 'vitest/browser';
import { render } from 'vitest-browser-react';
import {
  captureMateoGolden,
  compareMateoGoldenGroup,
  getMateoGoldenElement,
  mateoGoldenCustomTheme,
  mateoGoldenTheme,
  renderMateoGoldens,
} from '../../test/golden/mateo-golden.js';

function getMateoSelectionRgb(color: string) {
  const sample = document.createElement('span');
  sample.style.color = color;
  return sample.style.color;
}

function selectMateoText(element: HTMLElement) {
  const range = document.createRange();
  range.selectNodeContents(element);
  const selection = window.getSelection();
  if (!selection) throw new Error('Text selection is unavailable.');
  selection.removeAllRanges();
  selection.addRange(range);
}

it('should highlight ordinary text and native fields when inheriting a themed root', async () => {
  const scenarios = [mateoGoldenTheme, mateoGoldenCustomTheme].flatMap(
    (theme, index) =>
      ['white', 'neutral', 'accent'].map((surface) => ({
        name: `${index === 0 ? 'violet' : 'green'}-${surface}`,
        width: 360,
        content: (
          <div
            style={{
              ...getMateoThemeStyle(theme),
              background:
                surface === 'white'
                  ? theme.palette.white
                  : surface === 'neutral'
                    ? theme.palette.neutral[2]
                    : theme.colorScheme.accent,
            }}
          >
            <p style={{ color: theme.colorScheme.text.primary }}>
              Selected primary text <strong>with inline content</strong>.
            </p>
            <p style={{ color: theme.colorScheme.text.secondary }}>
              Selected supporting text.
            </p>
          </div>
        ),
      })),
  );
  const result = await renderMateoGoldens(scenarios);
  for (const { name } of scenarios) {
    const canvas = getMateoGoldenElement(name);
    const content = canvas.querySelector('div');
    if (!(content instanceof HTMLElement))
      throw new Error('Missing text sample.');
    selectMateoText(content);
    expect(window.getSelection()?.toString()).toContain(
      'Selected supporting text.',
    );
    await captureMateoGolden(name);
  }
  window.getSelection()?.removeAllRanges();
  await result.unmount();

  const fields = await renderMateoGoldens([
    {
      name: 'native-input',
      content: (
        <input aria-label="Selected input" defaultValue="Selected input text" />
      ),
    },
    {
      name: 'native-textarea',
      content: (
        <textarea
          aria-label="Selected textarea"
          defaultValue="Selected textarea text"
        />
      ),
    },
  ]);
  for (const name of ['native-input', 'native-textarea']) {
    const field = getMateoGoldenElement(name).querySelector('input, textarea');
    if (
      !(
        field instanceof HTMLInputElement ||
        field instanceof HTMLTextAreaElement
      )
    )
      throw new Error('Missing native field.');
    field.focus();
    field.select();
    expect(field.selectionStart).toBe(0);
    expect(field.selectionEnd).toBe(field.value.length);
    expect(getComputedStyle(field, '::selection').backgroundColor).toBe(
      getMateoSelectionRgb(mateoGoldenTheme.colorScheme.selection.background),
    );
    expect(getComputedStyle(field, '::selection').color).toBe(
      getMateoSelectionRgb(mateoGoldenTheme.colorScheme.selection.foreground),
    );
    await captureMateoGolden(name);
  }
  await fields.unmount();
  await compareMateoGoldenGroup('text-selection', 2);
});

it('should preserve native selection and follow nested accents when updating a themed root', async () => {
  const outside = await render(
    <p data-testid="outside-selection">Outside the theme</p>,
  );
  const outsideText = getMateoGoldenElement('outside-selection');
  const nativeBackground = getComputedStyle(
    outsideText,
    '::selection',
  ).backgroundColor;
  const nativeForeground = getComputedStyle(outsideText, '::selection').color;
  const result = await render(
    <div style={getMateoThemeStyle(mateoGoldenTheme)}>
      Root text
      <div
        data-testid="nested-selection"
        style={getMateoThemeStyle(mateoGoldenCustomTheme)}
      >
        Nested text{' '}
        <strong data-testid="inline-selection">with inline content</strong>
      </div>
    </div>,
  );
  const nested = getMateoGoldenElement('nested-selection');
  const inline = getMateoGoldenElement('inline-selection');
  selectMateoText(nested);
  for (const element of [nested, inline]) {
    expect(getComputedStyle(element, '::selection').backgroundColor).toBe(
      getMateoSelectionRgb(
        mateoGoldenCustomTheme.colorScheme.selection.background,
      ),
    );
    expect(getComputedStyle(element, '::selection').color).toBe(
      getMateoSelectionRgb(
        mateoGoldenCustomTheme.colorScheme.selection.foreground,
      ),
    );
  }
  const updated = createMateoTheme({
    accentColor: '#FFAA00',
    onAccent: '#000',
  });
  await result.rerender(
    <div style={getMateoThemeStyle(mateoGoldenTheme)}>
      Root text
      <div data-testid="nested-selection" style={getMateoThemeStyle(updated)}>
        Nested text{' '}
        <strong data-testid="inline-selection">with inline content</strong>
      </div>
    </div>,
  );
  expect(getComputedStyle(inline, '::selection').backgroundColor).toBe(
    getMateoSelectionRgb(updated.colorScheme.selection.background),
  );
  expect(getComputedStyle(inline, '::selection').color).toBe(
    getMateoSelectionRgb(updated.colorScheme.selection.foreground),
  );
  expect(getComputedStyle(outsideText, '::selection').backgroundColor).toBe(
    nativeBackground,
  );
  expect(getComputedStyle(outsideText, '::selection').color).toBe(
    nativeForeground,
  );
  await commands.mateoForcedColors(true);
  expect(getComputedStyle(nested, '::selection').backgroundColor).toBe(
    getComputedStyle(outsideText, '::selection').backgroundColor,
  );
  expect(getComputedStyle(nested, '::selection').color).toBe(
    getComputedStyle(outsideText, '::selection').color,
  );
  window.getSelection()?.removeAllRanges();
  await result.unmount();
  await outside.unmount();
});
