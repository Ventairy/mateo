import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../../components/mateo_button/mateo_button_appearance_scope.dart';
import '../../components/mateo_button/mateo_button_size.dart';
import '../../components/mateo_text/mateo_text.dart';
import '../base_mateo_view/base_mateo_view.dart';

part '_mateo_view_header_content.dart';
part '_mateo_view_header_slot.dart';
part '_render_mateo_view_header_content.dart';

@internal
class BaseMateoViewHeader extends StatelessWidget {
  const BaseMateoViewHeader({this.padding, this.principal, this.leading, this.trailing, super.key});

  final EdgeInsetsGeometry? padding;
  final Widget? principal;
  final Widget? leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final view = MateoViewLayoutScope.maybeOf(context);
    assert(padding != null || view != null, 'BaseMateoViewHeader requires padding or a BaseMateoView.');

    return Padding(
      padding: padding ?? view!.padding.copyWith(bottom: 0),
      child: MateoButtonAppearanceScope(
        variant: .primary.base,
        elevation: 1,
        size: MateoButtonSize.small,
        child: MateoTextScope(
          fontSize: 16,
          fontWeight: .w600,
          child: _MateoViewHeaderContent(
            principal: principal != null && leading != null && trailing != null
                ? MateoTextScope(textAlign: .center, child: principal!)
                : principal,
            leading: leading,
            trailing: trailing,
            textDirection: Directionality.of(context),
          ),
        ),
      ),
    );
  }
}
