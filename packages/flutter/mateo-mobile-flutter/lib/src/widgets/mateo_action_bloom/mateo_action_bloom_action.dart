part of 'mateo_action_bloom.dart';

/// An action displayed inside a Mateo action-bloom panel.
///
/// The [iconBuilder], [title], and [onPressed] values are required.
/// [description] adds supporting text beneath the title when the action needs
/// more explanation; when it is null, no description space is reserved.
///
/// The action receives its icon foreground color and presentation progress
/// from its owning Mateo button.
///
/// See also:
///  * [MateoActionBloomActionIconState], the state passed to [iconBuilder].
class MateoActionBloomAction extends StatelessWidget {
  /// Creates an action displayed by a Mateo action-bloom button.
  const MateoActionBloomAction({
    required this.iconBuilder,
    required this.title,
    required this.onPressed,
    super.key,
    this.description,
  });

  /// Builds the required icon from the action's presentation state.
  final MateoActionBloomActionIconBuilder iconBuilder;

  /// The required visible title and accessibility label for this action.
  final String title;

  /// The optional supporting text displayed beneath [title].
  final String? description;

  /// Handles this action after the panel starts closing.
  ///
  /// The callback receives a future for the press feedback animation. Await it
  /// before navigation or another disruptive operation, or ignore it when the
  /// action should continue immediately.
  final MateoActionBloomActionCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final scope = _MateoActionBloomActionScope.of(context);
    final textColorScheme = context.mateo.colorScheme.text;

    return Semantics(
      button: true,
      enabled: true,
      label: title,
      hint: description,
      onTap: () => unawaited(scope.onPressed(Future<void>.value())),
      child: ExcludeSemantics(
        child: MateoTap(
          onPressed: scope.onPressed,
          animation: MateoTapAnimationType.scaleFade,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            child: Row(
              children: [
                SizedBox.square(
                  dimension: 42,
                  child: Center(
                    child: AnimatedBuilder(
                      animation: scope.animation,
                      builder: (context, _) => iconBuilder(
                        MateoActionBloomActionIconState(
                          animationProgress: scope.animation.value,
                          foregroundColor: scope.iconForegroundColor,
                          iconSize: 24,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          decoration: TextDecoration.none,
                          fontFamily: MateoTypography.fontFamily,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: MateoTypography.letterSpacing,
                          height: 1.25,
                          color: textColorScheme.primary,
                        ),
                      ),
                      if (description case final description?) ...[
                        const SizedBox(height: 2),
                        Text(
                          description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            fontFamily: MateoTypography.fontFamily,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            letterSpacing: MateoTypography.letterSpacing,
                            height: 1.3,
                            color: textColorScheme.secondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MateoActionBloomActionScope extends InheritedWidget {
  const _MateoActionBloomActionScope({
    required this.animation,
    required this.iconForegroundColor,
    required this.onPressed,
    required super.child,
  });

  final Animation<double> animation;
  final Color iconForegroundColor;
  final MateoActionBloomActionCallback onPressed;

  static _MateoActionBloomActionScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_MateoActionBloomActionScope>();
    if (scope != null) return scope;

    throw FlutterError(
      'MateoActionBloomAction must be provided through '
      'a Mateo action-bloom button.',
    );
  }

  @override
  bool updateShouldNotify(_MateoActionBloomActionScope oldWidget) {
    return animation != oldWidget.animation ||
        iconForegroundColor != oldWidget.iconForegroundColor ||
        onPressed != oldWidget.onPressed;
  }
}
