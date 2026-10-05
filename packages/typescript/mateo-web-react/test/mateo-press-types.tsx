import { createRef } from 'react';
import { MateoPress, type MateoPressAnimation } from '../src/mateo-react.js';

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
  const pressAnimation: MateoPressAnimation = 'none';
  const staticAction = (
    <MateoPress pressAnimation={pressAnimation}>Save</MateoPress>
  );
  const scalingAction = (
    <MateoPress as="button" pressAnimation="scale">
      Save
    </MateoPress>
  );
  const unsupportedAnimation = (
    // @ts-expect-error Only named press animations are supported.
    <MateoPress pressAnimation="fade">Save</MateoPress>
  );
  const disabled = <MateoPress>Save</MateoPress>;
  // @ts-expect-error The callback owns enablement.
  const separateDisabled = <MateoPress disabled>Save</MateoPress>;
  // @ts-expect-error Navigation is outside the action-only contract.
  const link = <MateoPress href="/profile">Profile</MateoPress>;
  // @ts-expect-error The prop is named pressAnimation.
  const animation = <MateoPress animation="fade">Save</MateoPress>;
  // @ts-expect-error Styling is configured through semantic props.
  const styled = <MateoPress className="custom">Save</MateoPress>;
  // @ts-expect-error Sizing belongs to the wrapped content.
  const sized = <MateoPress width="fill">Save</MateoPress>;
  const nativeAction = (
    <MateoPress
      as="button"
      ref={createRef<HTMLButtonElement>()}
      onPressed={(event) => {
        const button: HTMLButtonElement = event.currentTarget;
        button.focus();
      }}
    >
      Save
    </MateoPress>
  );
  const mismatchedRef = (
    // @ts-expect-error Native button mode requires a button ref.
    <MateoPress as="button" ref={createRef<HTMLDivElement>()}>
      Save
    </MateoPress>
  );
  const implicitButton = (
    // @ts-expect-error Button refs require explicit native button mode.
    <MateoPress ref={createRef<HTMLButtonElement>()}>Save</MateoPress>
  );
  const submission = (
    // @ts-expect-error Submission is outside the action-only contract.
    <MateoPress as="button" type="submit">
      Save
    </MateoPress>
  );
  return {
    staticAction,
    scalingAction,
    unsupportedAnimation,
    nativeAction,
    mismatchedRef,
    implicitButton,
    submission,
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
