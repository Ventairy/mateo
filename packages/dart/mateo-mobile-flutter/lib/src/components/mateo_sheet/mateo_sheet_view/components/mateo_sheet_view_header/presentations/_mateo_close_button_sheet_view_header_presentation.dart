part of '../../../../show_mateo_sheet.dart';

class _MateoCloseButtonSheetViewHeaderPresentation extends MateoSheetViewHeaderPresentation {
  const _MateoCloseButtonSheetViewHeaderPresentation() : super._();

  @override
  Widget build(BuildContext context) {
    final route = ModalRoute.of(context);
    assert(route is MateoSheetRoute, 'The close button requires a containing Mateo sheet.');
    return BaseMateoViewHeader(
      trailing: Localizations.override(
        context: context,
        delegates: const [GlobalMaterialLocalizations.delegate],
        child: Builder(
          builder: (context) => MateoButton(
            presentation: .icon(
              icon: const MateoIcon(.cross),
              semanticLabel: MaterialLocalizations.of(context).closeButtonLabel,
            ),
            onPressed: () {
              if (route is MateoSheetRoute) unawaited(route._requestDismiss(.closeButton));
            },
          ),
        ),
      ),
    );
  }
}
