import 'dart:async' show unawaited;
import 'dart:ffi' as ffi show Size, sizeOf;
import 'dart:math' as math;
import 'dart:typed_data' show Uint16List, Uint32List;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart' show Intl;
import 'package:intl/number_symbols_data.dart' show numberFormatSymbols;

import '../../theme/mateo_typography.dart';

part '_mateo_text_presentation_scope.dart';
part 'motion/_mateo_text_motion.dart';
part 'motion/_mateo_text_motion_atlas.dart';
part 'motion/_mateo_text_motion_frame.dart';
part 'motion/_mateo_text_motion_hidden.dart';
part 'motion/_mateo_text_motion_layout.dart';
part 'motion/_mateo_text_motion_matching.dart';
part 'motion/_mateo_text_motion_numeral_atlas.dart';
part 'motion/_mateo_text_motion_paint.dart';
part 'motion/_mateo_text_motion_prepared.dart';
part 'motion/_mateo_text_motion_prepared_admission.dart';
part 'motion/_mateo_text_motion_state.dart';
part 'mateo_text_scope.dart';
part 'mateo_text_interface_font_size.dart';
part '_resolved_mateo_text_scope.dart';
part 'mateo_decorative_text_variant.dart';
part 'presentations/_mateo_decorative_text_presentation.dart';
part 'presentations/_mateo_interface_text_presentation.dart';
part 'presentations/mateo_text_presentation.dart';

/// Plain text with an interface or decorative Mateo treatment.
class MateoText extends StatelessWidget {
  /// Creates text with an explicit [presentation].
  const new(this.data, {required this.presentation, this.semanticsLabel, super.key});

  /// The text to display.
  final String data;

  /// The typography and layout treatment.
  final MateoTextPresentation presentation;

  /// An alternative localized label read by assistive technology.
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) =>
      _MateoTextPresentationScope(data: data, semanticsLabel: semanticsLabel, child: presentation);
}
