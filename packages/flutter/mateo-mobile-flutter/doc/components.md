# Component guide

`mateo_mobile` exports its supported Mateo Mobile surface from
`package:mateo_mobile/mateo_mobile.dart`. Start with `MateoButton`, `MateoTextButton`,
`MateoIconButton`, `MateoBottomSheet`, and `MateoToast` for common mobile application
controls and feedback.

Gesture-intensive experiences can use `MateoYSnapList`,
`MateoSwipeToPopSurface`, and `MateoHeroPage`. Controllers must be disposed by
their owners unless a component's API explicitly states otherwise.

`MateoLocationRadiusMap` wraps MapLibre presentation behavior. Consumers remain
responsible for their tile provider, attribution, access policy, and supported
zoom bounds.
