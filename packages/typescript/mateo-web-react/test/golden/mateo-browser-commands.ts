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
    mateoPointerDown(testId: string): Promise<void>;
    mateoResetInput(): Promise<void>;
    mateoReducedMotion(): Promise<void>;
    mateoForcedColors(active: boolean): Promise<void>;
  }
}
