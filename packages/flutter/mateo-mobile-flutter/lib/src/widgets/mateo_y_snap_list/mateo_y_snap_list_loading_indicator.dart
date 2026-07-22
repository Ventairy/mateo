part of 'mateo_y_snap_list.dart';

class _MateoYSnapListLoadingIndicator extends StatelessWidget {
  const _MateoYSnapListLoadingIndicator({required this.visible});

  static const double indicatorBoxSize = 100;

  final bool visible;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      key: const ValueKey('mateo_y_snap_list_loading_indicator'),
      width: indicatorBoxSize,
      height: indicatorBoxSize,
      child: visible
          ? Center(
              child: MateoDotsLoadingIndicator(
                color: context.mateo.palette.primary[9],
                dotRadius: 5,
              ),
            )
          : null,
    );
  }
}
