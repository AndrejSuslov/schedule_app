import 'package:flutter/material.dart';

class CommonContainer extends StatelessWidget {
  const CommonContainer({
    super.key,
    this.child,
    this.height,
    this.width,
    this.color,
    this.borderRadius = 16,
    this.padding,
  });
  final Widget? child;
  final double? height;
  final double? width;
  final Color? color;
  final double borderRadius;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: child,
    );
  }
}
