import { MateoDragResistance } from '@mateo/web-react/react';
import { it } from 'vitest';
import { commands } from 'vitest/browser';
import {
  captureMateoGolden,
  compareMateoGoldenGroup,
  mateoGoldenTheme,
  renderMateoGoldens,
  settleMateoGolden,
} from '../../../test/golden/mateo-golden.js';

it('should show bounded displacement when pulling HTML and scaled SVG content', async () => {
  for (const svg of [false, true]) {
    for (const [name, x, y] of [
      ['Resting', 0, 0],
      ['Right pull', 96, 0],
      ['Diagonal pull', 96, -96],
    ] as const) {
      const result = await renderMateoGoldens([
        {
          name: 'resistance',
          width: 240,
          height: 180,
          content: (
            <div style={{ padding: 30 }}>
              {svg ? (
                <svg
                  width="160"
                  height="120"
                  viewBox="0 0 320 240"
                  aria-label="Artwork"
                >
                  <MateoDragResistance resistance={16}>
                    <g data-testid="drag">
                      <rect
                        width="200"
                        height="140"
                        fill={mateoGoldenTheme.colorScheme.accent}
                      />
                    </g>
                  </MateoDragResistance>
                </svg>
              ) : (
                <MateoDragResistance resistance={16}>
                  <div
                    data-testid="drag"
                    style={{
                      width: 100,
                      height: 70,
                      background: mateoGoldenTheme.colorScheme.accent,
                    }}
                  />
                </MateoDragResistance>
              )}
            </div>
          ),
        },
      ]);
      await settleMateoGolden();
      if (x || y) await commands.mateoDragPointer('drag', x, y);
      await captureMateoGolden(
        `${svg ? 'SVG' : 'HTML'}: ${name}`,
        'resistance',
      );
      await commands.mateoPointerUp();
      await result.unmount();
    }
  }
  await compareMateoGoldenGroup('drag-resistance-poses', 3);
});
