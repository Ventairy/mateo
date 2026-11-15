import {
  createMateoTheme,
  getMateoThemeStyle,
  mateoTypography,
} from '@mateo/web-react';
import { expect, it } from 'vitest';
import { render } from 'vitest-browser-react';

async function _settleMateoFonts() {
  await new Promise<void>((resolve) =>
    requestAnimationFrame(() => requestAnimationFrame(() => resolve())),
  );
  await document.fonts.ready;
}

for (const style of ['normal', 'italic'] as const) {
  it(`should defer full coverage until supported characters outside Latin need it when using ${style} Inter`, async () => {
    const appearance = {
      fontFamily: mateoTypography.fontFamily,
      fontStyle: style,
    };
    const view = await render(<p style={appearance}>Cataquí ação São Paulo</p>);
    await _settleMateoFonts();
    const latin = Array.from(document.fonts).filter(
      (face) =>
        face.family === 'Inter' &&
        face.style === style &&
        face.status === 'loaded',
    );
    expect(latin).toHaveLength(1);
    expect(latin[0]?.unicodeRange).not.toBe('U+0-10FFFF');

    const full = Array.from(document.fonts).find(
      (face) =>
        face.family === 'Inter' &&
        face.style === style &&
        !latin.includes(face),
    );
    expect(full?.status).toBe('unloaded');

    await view.rerender(<p style={appearance}>Cataquí 👋 東京</p>);
    await _settleMateoFonts();
    expect(full?.status).toBe('unloaded');

    await view.rerender(<p style={appearance}>{'ac\u0327a\u0303o'}</p>);
    await _settleMateoFonts();
    expect(full?.status).toBe('unloaded');

    await view.rerender(<p style={appearance}>ΕλληνικάКириллица</p>);
    await _settleMateoFonts();
    expect(full?.status).toBe('loaded');
  });
}

it('should resolve minus two percent at each font size when descendants resize text', async () => {
  const theme = createMateoTheme({
    accentColor: '#4A5CFF',
    onAccent: '#FFFFFF',
  });
  const view = await render(
    <div style={{ ...getMateoThemeStyle(theme), fontSize: 16 }}>
      <span data-testid="small" style={{ fontSize: 20 }}>
        Small
      </span>
      <span data-testid="large" style={{ fontSize: 40 }}>
        Large
      </span>
    </div>,
  );
  expect(
    getComputedStyle(view.getByTestId('small').element()).letterSpacing,
  ).toBe('-0.4px');
  expect(
    getComputedStyle(view.getByTestId('large').element()).letterSpacing,
  ).toBe('-0.8px');
});

// Native DOM inheritance is also the contract used by server-rendered Astro
// content. Object-shape tests cannot detect browser control font defaults.
it('should inherit regular weight in native content and controls while preserving explicit weights', async () => {
  const theme = createMateoTheme({ accentColor: '#4A5CFF', onAccent: '#FFF' });
  const view = await render(
    <main style={getMateoThemeStyle(theme)}>
      <p data-testid="body">Cataquí perto de você</p>
      <button type="button">Continue</button>
      <input aria-label="Name" />
      <textarea aria-label="Description" />
      <select aria-label="City">
        <option>São Paulo</option>
      </select>
      <h2 data-testid="heading" style={{ fontWeight: 550 }}>
        Novidades
      </h2>
      <p data-testid="custom" style={{ fontWeight: 350 }}>
        Custom weight
      </p>
    </main>,
  );
  for (const element of [
    view.getByTestId('body'),
    view.getByRole('button', { name: 'Continue' }),
    view.getByRole('textbox', { name: 'Name' }),
    view.getByRole('textbox', { name: 'Description' }),
    view.getByRole('combobox', { name: 'City' }),
  ]) {
    expect(getComputedStyle(element.element()).fontWeight).toBe('450');
  }
  expect(
    getComputedStyle(view.getByTestId('heading').element()).fontWeight,
  ).toBe('550');
  expect(
    getComputedStyle(view.getByTestId('custom').element()).fontWeight,
  ).toBe('350');
});
