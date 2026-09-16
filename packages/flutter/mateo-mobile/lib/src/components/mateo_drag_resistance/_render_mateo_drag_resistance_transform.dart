part of 'mateo_drag_resistance.dart';

class _RenderMateoDragResistanceTransform extends RenderTransform {
  _RenderMateoDragResistanceTransform(this._translation) : super(transform: Matrix4.identity()) {
    _syncTranslation();
  }

  ValueListenable<Offset> _translation;

  ValueListenable<Offset> get translation => _translation;

  set translation(ValueListenable<Offset> value) {
    if (identical(value, _translation)) return;
    if (attached) _translation.removeListener(_syncTranslation);
    _translation = value;
    if (attached) _translation.addListener(_syncTranslation);
    _syncTranslation();
  }

  void _syncTranslation() {
    final offset = _translation.value;
    transform = Matrix4.translationValues(offset.dx, offset.dy, 0);
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _translation.addListener(_syncTranslation);
    _syncTranslation();
  }

  @override
  void detach() {
    _translation.removeListener(_syncTranslation);
    super.detach();
  }
}
