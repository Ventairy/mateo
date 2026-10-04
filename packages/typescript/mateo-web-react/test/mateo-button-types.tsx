import {
  MateoButton,
  type MateoButtonPresentation,
  MateoIcon,
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
  const presentation = {
    kind: 'label',
    label: 'Save',
    variant: 'primary-success',
    leadingIcon: <MateoIcon icon="circleCheck" />,
  } satisfies MateoButtonPresentation;
  const iconPresentation: MateoButtonPresentation = {
    kind: 'icon',
    label: 'Close',
    icon: <MateoIcon icon="cross" />,
  };
  // @ts-expect-error Icon actions require an accessible label.
  const unnamedIcon: MateoButtonPresentation = {
    kind: 'icon',
    icon: <MateoIcon icon="cross" />,
  };
  const stretchedIcon: MateoButtonPresentation = {
    kind: 'icon',
    label: 'Close',
    icon: <MateoIcon icon="cross" />,
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
  return {
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
      <MateoIcon icon="cross" />
    </MateoIconProvider>
  );
}
