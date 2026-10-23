import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../theme/mateo_typography.dart';

part '_mateo_text_presentation_scope.dart';
part 'mateo_text_scope.dart';
part '_resolved_mateo_text_scope.dart';
part 'mateo_decorative_text_variant.dart';
part 'presentations/_mateo_decorative_text_presentation.dart';
part 'presentations/_mateo_interface_text_presentation.dart';
part 'presentations/mateo_text_presentation.dart';

/// Plain text with an interface or decorative Mateo treatment.
class MateoText extends StatelessWidget {
  /// Creates text with an explicit [presentation].
  const MateoText(
    this.data, {
    required this.presentation,
    this.semanticsLabel,
    super.key,
  });

  /// The text to display.
  final String data;

  /// The typography and layout treatment.
  final MateoTextPresentation presentation;

  /// An alternative localized label read by assistive technology.
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) => _MateoTextPresentationScope(text: this, child: presentation);
}
