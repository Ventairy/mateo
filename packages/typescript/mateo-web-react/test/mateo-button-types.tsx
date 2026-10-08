import { createRef } from 'react';
import { MateoButtonColorScheme } from '../src/mateo.js';
import { MateoCircleCheckIcon, MateoCrossIcon } from '../src/mateo-icons.js';
import {
  MateoButton,
  type MateoButtonColorSchemeOverride,
  type MateoButtonPresentation,
  MateoIconProvider,
  useMateoIconContext,
} from '../src/mateo-react.js';

export function MateoButtonTypeTrigger({
  buttonPresentation,
}: {
  buttonPresentation: MateoButtonPresentation;
}) {
  return (
    <MateoButton
      presentation={buttonPresentation}
      onPressed={(event) => event.currentTarget.focus()}
      aria-haspopup="menu"
      aria-expanded={false}
    />
  );
}
export function checkMateoButtonTypes() {
  const partialColors = {
    background: '#173B2C',
  } satisfies MateoButtonColorSchemeOverride;
  const completeColors = new MateoButtonColorScheme({
    background: '#173B2C',
    foreground: '#FFFFFF',
    backgroundDisabled: '#E5EAFA',
    foregroundDisabled: '#273392',
  });
  const customLabel: MateoButtonPresentation = {
    kind: 'label',
    label: 'Save',
    colorScheme: partialColors,
  };
  const customIcon: MateoButtonPresentation = {
    kind: 'icon',
    label: 'Close',
    icon: <MateoCrossIcon />,
    colorScheme: completeColors,
  };
  const emptyColors = {} satisfies MateoButtonColorSchemeOverride;
  const invalidColors: MateoButtonColorSchemeOverride = {
    // @ts-expect-error Color roles require strings.
    foreground: 123,
  };
  const misspelledColors: MateoButtonColorSchemeOverride = {
    // @ts-expect-error Only the four supported color roles are accepted.
    backgound: '#173B2C',
  };
  const nullRole: MateoButtonColorSchemeOverride = {
    // @ts-expect-error Omit a role to inherit; null is unsupported.
    background: null,
  };
  const nullColors: MateoButtonPresentation = {
    kind: 'label',
    label: 'Save',
    // @ts-expect-error Omit the scheme to inherit; null is unsupported.
    colorScheme: null,
  };
  const presentation = {
    kind: 'label',
    label: 'Save',
    variant: 'primary-success',
    leadingIcon: <MateoCircleCheckIcon />,
  } satisfies MateoButtonPresentation;
  const iconPresentation: MateoButtonPresentation = {
    kind: 'icon',
    label: 'Close',
    icon: <MateoCrossIcon />,
  };
  // @ts-expect-error Icon actions require an accessible label.
  const unnamedIcon: MateoButtonPresentation = {
    kind: 'icon',
    icon: <MateoCrossIcon />,
  };
  const stretchedIcon: MateoButtonPresentation = {
    kind: 'icon',
    label: 'Close',
    icon: <MateoCrossIcon />,
    // @ts-expect-error Icon presentations have circular geometry, not fill width.
    width: 'fill',
  };
  const invalidVariant: MateoButtonPresentation = {
    kind: 'label',
    label: 'Save',
    // @ts-expect-error Secondary success is not a supported treatment.
    variant: 'secondary-success',
  };
  // @ts-expect-error Labels are required.
  const missingLabel: MateoButtonPresentation = { kind: 'label' };
  const styled = (
    // @ts-expect-error Raw style customization is not supported.
    <MateoButton presentation={presentation} style={{ color: 'red' }} />
  );
  const physicalAlignment: MateoButtonPresentation = {
    kind: 'label',
    label: 'Save',
    // @ts-expect-error Alignment uses logical options.
    alignment: 'left',
  };
  const invalidRef = (
    <MateoButton
      presentation={presentation}
      // @ts-expect-error Native button refs cannot refer to div elements.
      ref={{ current: document.createElement('div') }}
    />
  );
  const anchor = (
    <MateoButton
      as="a"
      href="/profile"
      presentation={presentation}
      target="_blank"
      rel="noopener"
      ref={createRef<HTMLAnchorElement>()}
      onPressed={(event) => {
        const link: HTMLAnchorElement = event.currentTarget;
        link.focus();
      }}
    />
  );
  // @ts-expect-error Anchor mode requires a destination.
  const missingDestination = <MateoButton as="a" presentation={presentation} />;
  const implicitDestination = (
    // @ts-expect-error Navigation props require explicit anchor mode.
    <MateoButton href="/profile" presentation={presentation} />
  );
  const buttonDestination = (
    // @ts-expect-error Native actions cannot receive navigation props.
    <MateoButton as="button" href="/profile" presentation={presentation} />
  );
  const anchorButtonRef = (
    // @ts-expect-error Link refs must refer to native anchors.
    <MateoButton
      as="a"
      href="/profile"
      presentation={presentation}
      ref={createRef<HTMLButtonElement>()}
    />
  );
  const buttonTarget = (
    // @ts-expect-error Actions cannot receive browsing context props.
    <MateoButton target="_blank" presentation={presentation} />
  );
  const disabledAnchor = (
    // @ts-expect-error Links do not have a disabled state.
    <MateoButton as="a" href="/profile" presentation={presentation} disabled />
  );
  return {
    customLabel,
    customIcon,
    emptyColors,
    invalidColors,
    misspelledColors,
    nullRole,
    nullColors,
    anchor,
    missingDestination,
    implicitDestination,
    buttonDestination,
    anchorButtonRef,
    buttonTarget,
    disabledAnchor,
    presentation,
    iconPresentation,
    unnamedIcon,
    stretchedIcon,
    invalidVariant,
    missingLabel,
    styled,
    physicalAlignment,
    invalidRef,
  };
}
export function MateoIconProviderTypeFixture() {
  const { size, color } = useMateoIconContext();
  return (
    <MateoIconProvider size={size} color={color}>
      <MateoCrossIcon />
    </MateoIconProvider>
  );
}
