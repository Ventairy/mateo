import 'package:meta/meta.dart' show RecordUse;

/// The visual treatment for a Mateo catalog icon.
@RecordUse()
enum MateoIconStyle {
  /// The vector icon treatment.
  svg,

  /// The dimensional image treatment, available for selected icons.
  threeD,

  /// Icon styled in a way that looks like a sticker
  sticker,
}
