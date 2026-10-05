import { defineBrowserCommand } from '@vitest/browser-playwright';

export const mateoGoldenCommands = {
  mateoGroupViewport: defineBrowserCommand(
    async ({ page, iframe }, width: number, height: number) => {
      await page.setViewportSize({ width, height });
      await iframe.owner().evaluate(
        (element, bounds) => {
          element.style.width = `${bounds.width}px`;
          element.style.height = `${bounds.height}px`;
        },
        { width, height },
      );
    },
  ),
  mateoCaptureScenario: defineBrowserCommand(
    async ({ page, iframe }, testId: string) => {
      const bounds = await iframe.getByTestId(testId).boundingBox();
      if (!bounds) throw new Error(`Missing golden canvas: ${testId}`);
      const image = await page.screenshot({
        clip: bounds,
        animations: 'allow',
      });
      return image.toString('base64');
    },
  ),
  mateoScrollbarHover: defineBrowserCommand(
    async (
      { page, iframe },
      testId: string,
      axis: 'vertical' | 'horizontal',
    ) => {
      const bounds = await iframe.getByTestId(testId).boundingBox();
      if (!bounds) throw new Error(`Missing scrollbar target: ${testId}`);
      await page.mouse.move(
        axis === 'vertical' ? bounds.x + bounds.width - 6 : bounds.x + 30,
        axis === 'vertical' ? bounds.y + 30 : bounds.y + bounds.height - 6,
      );
    },
  ),
  mateoScrollKeyboard: defineBrowserCommand(
    async ({ page, iframe }, testId: string) => {
      await iframe.getByTestId(testId).focus();
      await page.keyboard.press('ArrowDown');
    },
  ),
  mateoPointerDown: defineBrowserCommand(
    async ({ page, iframe }, testId: string) => {
      const bounds = await iframe.getByTestId(testId).boundingBox();
      if (!bounds) throw new Error(`Missing pointer target: ${testId}`);
      await page.mouse.move(
        bounds.x + bounds.width / 2,
        bounds.y + bounds.height / 2,
      );
      await page.mouse.down();
    },
  ),
  mateoFocusKey: defineBrowserCommand(
    async ({ page }, key: 'Tab' | 'Shift+Tab') => {
      await page.keyboard.press(key);
    },
  ),
  mateoTouchTap: defineBrowserCommand(
    async ({ page, iframe }, testId: string) => {
      const bounds = await iframe.getByTestId(testId).boundingBox();
      if (!bounds) throw new Error(`Missing touch target: ${testId}`);
      await page.touchscreen.tap(
        bounds.x + bounds.width / 2,
        bounds.y + bounds.height / 2,
      );
    },
  ),
  mateoPenClick: defineBrowserCommand(
    async ({ page, iframe }, testId: string) => {
      const bounds = await iframe.getByTestId(testId).boundingBox();
      if (!bounds) throw new Error(`Missing pen target: ${testId}`);
      const session = await page.context().newCDPSession(page);
      const point = {
        x: bounds.x + bounds.width / 2,
        y: bounds.y + bounds.height / 2,
        pointerType: 'pen' as const,
      };
      try {
        await session.send('Input.dispatchMouseEvent', {
          ...point,
          type: 'mousePressed',
          button: 'left',
          buttons: 1,
          clickCount: 1,
        });
        await session.send('Input.dispatchMouseEvent', {
          ...point,
          type: 'mouseReleased',
          button: 'left',
          buttons: 0,
          clickCount: 1,
        });
      } finally {
        await session.detach();
      }
    },
  ),
  mateoPointerUp: defineBrowserCommand(async ({ page }) => {
    await page.mouse.up();
  }),
  mateoResetInput: defineBrowserCommand(async ({ page }) => {
    await page.mouse.up();
    await page.keyboard.up('Space');
    await page.mouse.move(0, 0);
    await page.emulateMedia({
      reducedMotion: 'no-preference',
      forcedColors: 'none',
    });
  }),
  mateoForcedColors: defineBrowserCommand(async ({ page }, active: boolean) => {
    await page.emulateMedia({ forcedColors: active ? 'active' : 'none' });
  }),
  mateoReducedMotion: defineBrowserCommand(async ({ page }) => {
    await page.emulateMedia({ reducedMotion: 'reduce' });
  }),
};

declare module 'vitest/browser' {
  interface BrowserCommands {
    mateoGroupViewport(width: number, height: number): Promise<void>;
    mateoCaptureScenario(testId: string): Promise<string>;
    mateoScrollbarHover(
      testId: string,
      axis: 'vertical' | 'horizontal',
    ): Promise<void>;
    mateoScrollKeyboard(testId: string): Promise<void>;
    mateoPointerDown(testId: string): Promise<void>;
    mateoFocusKey(key: 'Tab' | 'Shift+Tab'): Promise<void>;
    mateoTouchTap(testId: string): Promise<void>;
    mateoPenClick(testId: string): Promise<void>;
    mateoPointerUp(): Promise<void>;
    mateoResetInput(): Promise<void>;
    mateoReducedMotion(): Promise<void>;
    mateoForcedColors(active: boolean): Promise<void>;
  }
}
