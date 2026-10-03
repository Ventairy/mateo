import { createRef } from 'react';
import { MateoPress } from '../src/mateo-react.js';

export function checkMateoPressTypes() {
  const action = (
    <MateoPress
      ref={createRef<HTMLDivElement>()}
      onPressed={(event) => {
        event.currentTarget.focus();
      }}
    >
      Save
    </MateoPress>
  );
  const asynchronous = <MateoPress onPressed={async () => {}}>Save</MateoPress>;
  const disabled = <MateoPress>Save</MateoPress>;
  // @ts-expect-error The callback owns enablement.
  const separateDisabled = <MateoPress disabled>Save</MateoPress>;
  // @ts-expect-error Navigation is outside the action-only contract.
  const link = <MateoPress href="/profile">Profile</MateoPress>;
  // @ts-expect-error Animation selection is not supported.
  const animation = <MateoPress animation="fade">Save</MateoPress>;
  // @ts-expect-error Styling is configured through semantic props.
  const styled = <MateoPress className="custom">Save</MateoPress>;
  // @ts-expect-error Sizing belongs to the wrapped content.
  const sized = <MateoPress width="fill">Save</MateoPress>;
  return {
    action,
    asynchronous,
    disabled,
    separateDisabled,
    link,
    animation,
    styled,
    sized,
  };
}
