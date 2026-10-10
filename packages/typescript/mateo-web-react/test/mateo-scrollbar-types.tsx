import { MateoScrollbar, MateoViewSurface } from '@mateo/web-react/react';
import { createRef } from 'react';

const mateoScrollRef = createRef<HTMLDivElement>();
<MateoScrollbar scrollRef={mateoScrollRef} aria-label="Messages" />;
<MateoScrollbar scrollRef={mateoScrollRef} aria-labelledby="messages-title" />;
<MateoViewSurface extendBehindScrollbar>{null}</MateoViewSurface>;
// @ts-expect-error A viewport reference is required.
<MateoScrollbar />;
// @ts-expect-error Styling belongs to the component.
<MateoScrollbar scrollRef={mateoScrollRef} className="custom" />;
// @ts-expect-error Axes are discovered from the native viewport.
<MateoScrollbar scrollRef={mateoScrollRef} orientation="vertical" />;
// @ts-expect-error A surface uses a boolean opt-in.
<MateoViewSurface extendBehindScrollbar="true">{null}</MateoViewSurface>;
