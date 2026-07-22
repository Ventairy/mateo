import 'package:flutter/material.dart';
import 'package:mateo_mobile/src/icons/mateo_icons.dart';
import 'package:mateo_mobile/src/theme/mateo_theme_context.dart';
import 'package:mateo_mobile/src/theme/mateo_typography.dart';

/// Mateo Mobile search bar button that opens search through a tap action.
///
/// The button is intentionally display-only. Use [onTap] to open the real
/// search flow in the consuming app.
///
/// ```dart
/// MateoSearchBarButton(
///   title: 'Start your search',
///   onTap: () {},
/// )
/// ```
class MateoSearchBarButton extends StatelessWidget {
  /// Creates a Mateo Mobile search bar button.
  const MateoSearchBarButton({
    super.key,
    this.title = 'Start your search',
    this.onTap,
  });

  /// The default height of the search bar button.
  static const double searchBarHeight = 60;

  /// Text displayed in the center of the search bar button.
  final String title;

  /// Called when the search bar button is tapped.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    const borderRadius = BorderRadius.all(Radius.circular(34));

    return Semantics(
      button: true,
      label: title,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          boxShadow: [
            BoxShadow(
              color: context.mateo.colorScheme.buttons.searchBar.shadow,
              blurRadius: 24,
            ),
          ],
        ),
        child: Material(
          color: context.mateo.colorScheme.buttons.searchBar.background,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius,
            side: BorderSide(
              color: context.mateo.colorScheme.buttons.searchBar.border,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            borderRadius: borderRadius,
            child: SizedBox(
              height: searchBarHeight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MateoIcon.magnifierGlass(
                      width: 18,
                      height: 18,
                      color: context
                          .mateo
                          .colorScheme
                          .buttons
                          .searchBar
                          .foreground,
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: context
                              .mateo
                              .colorScheme
                              .buttons
                              .searchBar
                              .foreground,
                          fontFamily: MateoTypography.fontFamily,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: MateoTypography.letterSpacing,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
