import { defineBrowserCommand } from '@vitest/browser-playwright';

export const mateoGoldenCommands = {
  mateoFollowLink: defineBrowserCommand(
    async (
      { page, iframe },
      testId: string,
      input: 'pointer' | 'enter' | 'modified' | 'middle',
    ) => {
      const popup = page.context().waitForEvent('page');
      const link = iframe.getByTestId(testId);
      if (input === 'enter') {
        await link.focus();
        await page.keyboard.press('Enter');
      } else {
        await link.click(
          input === 'middle'
            ? { button: 'middle' }
            : input === 'modified'
              ? { modifiers: ['ControlOrMeta'] }
              : {},
        );
      }
      const destination = await popup;
      try {
        await destination.waitForURL('about:blank#mateo-destination');
        return destination.url();
      } finally {
        await destination.close();
      }
    },
  ),
  mateoFollowStaticLink: defineBrowserCommand(
    async ({ page }, markup: string) => {
      const consumer = await page.context().newPage();
      try {
        await consumer.setContent(markup);
        await consumer.getByRole('link', { name: 'Profile' }).click();
        await consumer.waitForURL('about:blank#mateo-destination');
        return consumer.url();
      } finally {
        await consumer.close();
      }
    },
  ),
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
  mateoScrollbarDrag: defineBrowserCommand(
    async (
      { page, iframe },
      axis: 'vertical' | 'horizontal',
      delta: number,
    ) => {
      const track = iframe.locator(
        `[role="scrollbar"][aria-orientation="${axis}"]`,
      );
      const bounds = await track.locator('div').boundingBox();
      if (!bounds) throw new Error('Missing scrollbar thumb');
      const x = bounds.x + bounds.width / 2;
      const y = bounds.y + bounds.height / 2;
      await page.mouse.move(x, y);
      await page.mouse.down();
      await page.mouse.move(
        x + (axis === 'horizontal' ? delta : 0),
        y + (axis === 'vertical' ? delta : 0),
      );
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
  mateoWheel: defineBrowserCommand(
    async ({ page, iframe }, testId: string, deltaY: number) => {
      const bounds = await iframe.getByTestId(testId).boundingBox();
      if (!bounds) throw new Error(`Missing wheel target: ${testId}`);
      await page.mouse.move(
        bounds.x + bounds.width / 2,
        bounds.y + bounds.height / 2,
      );
      await page.mouse.wheel(0, deltaY);
      await page.waitForTimeout(150);
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
    mateoFollowLink(
      testId: string,
      input: 'pointer' | 'enter' | 'modified' | 'middle',
    ): Promise<string>;
    mateoFollowStaticLink(markup: string): Promise<string>;
    mateoGroupViewport(width: number, height: number): Promise<void>;
    mateoCaptureScenario(testId: string): Promise<string>;
    mateoScrollbarDrag(
      axis: 'vertical' | 'horizontal',
      delta: number,
    ): Promise<void>;
    mateoScrollbarHover(
      testId: string,
      axis: 'vertical' | 'horizontal',
    ): Promise<void>;
    mateoScrollKeyboard(testId: string): Promise<void>;
    mateoWheel(testId: string, deltaY: number): Promise<void>;
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
