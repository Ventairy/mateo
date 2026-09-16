import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../base_mateo_view/base_mateo_view.dart';

part '_mateo_view_footer_content.dart';
part '_mateo_view_footer_slot.dart';
part '_render_mateo_view_footer_content.dart';

@internal
class BaseMateoViewFooter extends StatelessWidget {
  const BaseMateoViewFooter({
    this.padding,
    this.principal,
    this.leading,
    this.trailing,

    super.key,
  });

  final Widget? principal;
  final Widget? leading;
  final Widget? trailing;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final view = MateoViewLayoutScope.maybeOf(context);
    assert(padding != null || view != null, 'BaseMateoViewFooter requires padding or a BaseMateoView.');

    return Padding(
      padding: padding ?? view!.padding.copyWith(top: 0),
      child: _MateoViewFooterContent(
        principal: principal,
        leading: leading,
        trailing: trailing,
        textDirection: Directionality.of(context),
      ),
    );
  }
}
