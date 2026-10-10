import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { test } from 'vitest';
import { MateoDefaultPalette } from './mateo-palette.js';

test('should match all foundation and Flutter shades when using authored primitives', () => {
  const foundation = readFileSync(
    new URL(
      '../../../../design-system/foundation/color-palette.md',
      import.meta.url,
    ),
    'utf8',
  );
  const flutter: unknown = JSON.parse(
    readFileSync(
      new URL(
        '../../../dart/mateo-mobile-flutter/test/theme/fixtures/palette.json',
        import.meta.url,
      ),
      'utf8',
    ),
  );
  assert.ok(typeof flutter === 'object' && flutter !== null);
  const sections = foundation.split(/^## /m);
  const scales = Object.entries(MateoDefaultPalette).filter(
    ([, value]) => typeof value !== 'string',
  );
  assert.equal(scales.length, 12);
  for (const [index, [name, scale]] of scales.entries()) {
    assert.ok(typeof scale !== 'string');
    const section = sections.find((text) => text.startsWith(`${index + 1}. `));
    assert.ok(section, name);
    const shades = [
      ...section.matchAll(/^\|\s*\d+\s*\|\s*\*?\*?`(#[\dA-F]{6})`/gm),
    ].map((match) => match[1]);
    assert.equal(shades.length, 12, name);
    assert.deepEqual(Object.values(scale), shades, name);
    assert.deepEqual(
      Object.values(scale).map((shade) => {
        assert.ok(typeof shade === 'string');
        return Number.parseInt(`FF${shade.slice(1)}`, 16);
      }),
      Reflect.get(flutter, name),
      name,
    );
  }
  assert.match(foundation, /\*\*White\*\*\s*\|\s*`#FFFFFF`/);
  assert.match(foundation, /\*\*Black\*\*\s*\|\s*`#000000`/);
  assert.equal(MateoDefaultPalette.white, '#FFFFFF');
  assert.equal(MateoDefaultPalette.black, '#000000');
  const flutterSource = readFileSync(
    new URL(
      '../../../dart/mateo-mobile-flutter/lib/src/theme/palette/mateo_palette.dart',
      import.meta.url,
    ),
    'utf8',
  );
  assert.match(flutterSource, /0xFFFFFFFF/);
  assert.match(flutterSource, /0xFF000000/);
});

test('should preserve primitives when a consumer attempts to mutate them', () => {
  assert.ok(Object.isFrozen(MateoDefaultPalette));
  assert.equal(Reflect.set(MateoDefaultPalette, 'white', '#000000'), false);
  for (const [name, scale] of Object.entries(MateoDefaultPalette)) {
    if (typeof scale === 'string') continue;
    assert.ok(Object.isFrozen(scale), name);
    assert.equal(Reflect.set(scale, '11', '#000000'), false);
    assert.equal(Reflect.deleteProperty(scale, '1'), false);
    assert.equal(Reflect.get(scale, '0'), undefined);
    assert.equal(Reflect.get(scale, '13'), undefined);
  }
});
