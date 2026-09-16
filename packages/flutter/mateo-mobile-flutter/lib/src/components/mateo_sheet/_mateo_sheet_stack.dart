part of 'mateo_sheet.dart';

class _MateoSheetStack extends ChangeNotifier {
  final Object surfaceTag = Object();
  final Object closeTag = Object();
  final List<_MateoSheetRoute<Object?>> routes = [];
  Animation<double>? dismissalAnimation;
  bool isDeciding = false;
  int revision = 0;
  bool _disposed = false;

  void add(_MateoSheetRoute<Object?> route) {
    routes.add(route);
    revision++;
  }

  void remove(_MateoSheetRoute<Object?> route) {
    routes.remove(route);
    revision++;
    if (identical(dismissalAnimation, route._surfaceMotion)) dismissalAnimation = null;
    if (routes.isEmpty) {
      dispose();
    } else {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (!_disposed) notifyListeners();
      });
    }
  }

  void updateDismissalAnimation(Animation<double>? animation) {
    dismissalAnimation = animation;
    notifyListeners();
  }

  Future<bool> dismissFrom(_MateoSheetRoute<Object?> top, MateoSheetDismissSource source) async {
    if (!top.isCurrent || isDeciding || top._leavingStack) return false;
    final navigator = top.navigator!;
    final startingRevision = revision;
    final accepted = <_MateoSheetRoute<Object?>>[];
    _MateoSheetRoute<Object?>? protected;
    bool unchanged() => top.isCurrent && top.navigator == navigator && revision == startingRevision;

    isDeciding = true;
    try {
      // Ask from top to bottom. A refusal protects that sheet and everything below it.
      for (_MateoSheetRoute<Object?>? candidate = top; candidate != null; candidate = candidate._previousSheet) {
        final disposition = await candidate._dismissDisposition(source);
        if (!unchanged() || !candidate.isActive) return false;
        if (disposition != RoutePopDisposition.pop || candidate.popDisposition != RoutePopDisposition.pop) {
          if (disposition == RoutePopDisposition.pop && candidate.popDisposition == RoutePopDisposition.doNotPop) {
            candidate.onPopInvokedWithResult(false, null);
            if (!unchanged() || !candidate.isActive) return false;
          }
          protected = candidate;
          break;
        }
        accepted.add(candidate);
      }
      if (accepted.isEmpty) return false;

      if (protected != null && source.isTapOutside) {
        accepted.skip(1).toList().reversed.forEach(navigator.removeRoute);
        // Detach skipped Morph endpoints before selecting the protected destination.
        await SchedulerBinding.instance.endOfFrame;
        if (!top.isCurrent || !protected.isActive) return false;
        navigator.pop();
        return true;
      }

      await top._leaveStack();
      if (!unchanged()) {
        top._cancelStackExit();
        return false;
      }
      protected?._prepareDragReturn();
      accepted.reversed.forEach(navigator.removeRoute);
      if (protected != null) unawaited(protected._returnAfterDrag());
      return true;
    } on TickerCanceled {
      return false;
    } finally {
      isDeciding = false;
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
