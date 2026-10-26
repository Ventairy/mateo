part of 'render_lifecycle_probe.dart';

class _RenderLifecycleProbe extends RenderProxyBox {
  _RenderLifecycleProbe({required this.onAttach, required this.onDetach});

  final VoidCallback onAttach;
  final VoidCallback onDetach;

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    onAttach();
  }

  @override
  void detach() {
    onDetach();
    super.detach();
  }
}
