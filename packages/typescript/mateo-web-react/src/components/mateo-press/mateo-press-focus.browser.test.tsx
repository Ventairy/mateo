import { MateoPress } from '@mateo/web-react/react';
import { expect, it, vi } from 'vitest';
import { commands } from 'vitest/browser';
import {
  getMateoGoldenElement,
  renderMateoGoldens,
  settleMateoGolden,
} from '../../../test/golden/mateo-golden.js';

for (const pointer of ['mouse', 'touch'] as const) {
  it(`should retain focus and activate once when a ${pointer} presses a native action inside a focusable container`, async () => {
    const activate = vi.fn();
    await renderMateoGoldens([
      {
        name: 'native-focus',
        width: 300,
        content: (
          <div tabIndex={-1}>
            <MateoPress
              as="button"
              data-testid="native-action"
              onPressed={activate}
            >
              Action
            </MateoPress>
          </div>
        ),
      },
    ]);
    await settleMateoGolden();
    if (pointer === 'touch') await commands.mateoTouchTap('native-action');
    else {
      await commands.mateoPointerDown('native-action');
      await commands.mateoPointerUp();
    }
    expect(document.activeElement).toBe(getMateoGoldenElement('native-action'));
    expect(activate).toHaveBeenCalledTimes(1);
  });
}
