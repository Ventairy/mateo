part of 'mateo_text_input.dart';

abstract final class _MateoTextInputEditingControls {
  static TextSelectionControls get selectionControls => switch (defaultTargetPlatform) {
    TargetPlatform.android || TargetPlatform.fuchsia => material.materialTextSelectionHandleControls,
    TargetPlatform.iOS => cupertinoTextSelectionHandleControls,
    TargetPlatform.macOS => cupertinoDesktopTextSelectionHandleControls,
    TargetPlatform.linux || TargetPlatform.windows => material.desktopTextSelectionHandleControls,
  };

  static Widget buildContextMenu(BuildContext context, EditableTextState editable) => Localizations.override(
    context: context,
    delegates: const [GlobalCupertinoLocalizations.delegate, GlobalMaterialLocalizations.delegate],
    child: material.Theme(
      data: material.ThemeData.light().copyWith(platform: defaultTargetPlatform),
      child: Builder(
        builder: (context) => SystemContextMenu.isSupportedByField(editable)
            ? SystemContextMenu.editableText(editableTextState: editable)
            : material.AdaptiveTextSelectionToolbar.editableText(editableTextState: editable),
      ),
    ),
  );
}
