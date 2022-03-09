import 'package:flutter/material.dart';

class CollapsibleContainer extends StatelessWidget {
  const CollapsibleContainer({
    Key? key,
    required this.height,
    required this.width,
    required this.padding,
    required this.borderRadius,
    required this.color,
    required this.child,
    required this.sidebarBoxShadow,
  }) : super(key: key);

  final double height, width, padding, borderRadius;
  final Color color;
  final Widget child;
  final List<BoxShadow> sidebarBoxShadow;

  @override
  Widget build(BuildContext context) => Container(
        height: height,
        width: width,
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: color,
          boxShadow: sidebarBoxShadow,
        ),
        child: child,
      );
}
