part of 'show_mateo_sheet.dart';

class _MateoSheetStackScope extends InheritedWidget {
  const _MateoSheetStackScope({required this.stackEntry, required super.child});

  final _MateoSheetStackEntry stackEntry;

  static _MateoSheetStackEntry? stackEntryOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_MateoSheetStackScope>()?.stackEntry;

  @override
  bool updateShouldNotify(_MateoSheetStackScope oldWidget) => !identical(stackEntry, oldWidget.stackEntry);
}
