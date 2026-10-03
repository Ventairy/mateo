import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

@internal
abstract interface class MateoSurfaceObstruction implements Listenable {
  EdgeInsets get layoutInsets;

  // Resolve only after layout, when placement-dependent bounds are available.
  EdgeInsets resolvePaintInsets();
}
