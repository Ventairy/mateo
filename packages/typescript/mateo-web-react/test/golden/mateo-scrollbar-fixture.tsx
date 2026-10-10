import { MateoScrollbar } from '@mateo/web-react/react';
import { useRef, useState } from 'react';

export function MateoScrollbarSample({
  rtl = false,
  controls = true,
  axis = 'both',
}: {
  readonly rtl?: boolean;
  readonly controls?: boolean;
  readonly axis?: 'vertical' | 'horizontal' | 'both' | 'none';
}) {
  const ref = useRef<HTMLElement>(null);
  const [enabled, setEnabled] = useState(true);
  const [large, setLarge] = useState(axis !== 'none');
  const [target, setTarget] = useState(0);
  const [revision, setRevision] = useState(0);
  return (
    <>
      {controls && (
        <>
          <button type="button" onClick={() => setEnabled(!enabled)}>
            Toggle
          </button>
          <button type="button" onClick={() => setLarge(!large)}>
            Resize
          </button>
          <button type="button" onClick={() => setRevision(revision + 1)}>
            Refresh
          </button>
          <button type="button" onClick={() => setTarget(target + 1)}>
            Replace
          </button>
        </>
      )}
      <div style={{ position: 'relative', width: 240, height: 160 }}>
        <section
          key={target}
          ref={ref}
          aria-label="Messages"
          dir={rtl ? 'rtl' : 'ltr'}
          data-testid="viewport"
          // biome-ignore lint/a11y/noNoninteractiveTabindex: Native scroll viewport is keyboard reachable.
          tabIndex={0}
          style={{ width: '100%', height: '100%', overflow: 'auto' }}
        >
          <div
            style={{
              width: large && axis !== 'vertical' ? 480 : '100%',
              height: large && axis !== 'horizontal' ? 640 : 100,
              background:
                'linear-gradient(135deg, transparent 30%, var(--mateo-scrollbar-thumb) 100%)',
            }}
          >
            Messages
          </div>
        </section>
        {enabled && <MateoScrollbar scrollRef={ref} />}
      </div>
    </>
  );
}
