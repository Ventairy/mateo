part of '../../mateo_page_transition.dart';

typedef _MateoPushPageSnapshot = ({ui.Image image, Size sourceSize, double pixelRatio});

final class _MateoPushPageSnapshotPainter extends SnapshotPainter {
  final _snapshotPaint = Paint()..filterQuality = .low;
  _MateoPushPageSnapshot? get snapshot => _snapshot;
  _MateoPushPageSnapshot? _snapshot;

  bool get retainEdgeSource => _retainEdgeSource;
  bool _retainEdgeSource = false;
  set retainEdgeSource(bool value) {
    if (value == _retainEdgeSource) return;
    _retainEdgeSource = value;
    if (!value) clearSnapshot();
  }

  void clearSnapshot() {
    _snapshot?.image.dispose();
    _snapshot = null;
  }

  @override
  void paint(PaintingContext context, Offset offset, Size size, PaintingContextCallback painter) {
    clearSnapshot();
    painter(context, offset);
  }

  @override
  void paintSnapshot(
    PaintingContext context,
    Offset offset,
    Size size,
    ui.Image image,
    Size sourceSize,
    double pixelRatio,
  ) {
    if (_retainEdgeSource && !(_snapshot?.image.isCloneOf(image) ?? false)) {
      clearSnapshot();
      // This owns a handle to the existing texture. It does not rasterize or
      // allocate another page texture, and stays valid during snapshot release.
      _snapshot = (image: image.clone(), sourceSize: sourceSize, pixelRatio: pixelRatio);
    }
    context.canvas.drawImageRect(image, Offset.zero & sourceSize, offset & size, _snapshotPaint);
  }

  @override
  bool shouldRepaint(covariant _MateoPushPageSnapshotPainter oldPainter) => false;

  @override
  void dispose() {
    clearSnapshot();
    super.dispose();
  }
}
