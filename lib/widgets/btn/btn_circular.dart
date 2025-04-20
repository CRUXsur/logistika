import 'package:flutter/material.dart';

class BtnCircular extends StatelessWidget {
  const BtnCircular({
    Key? key,
    required this.child,
    required this.color,
    required this.onTap,
    required this.width,
  }) : super(key: key);

  final Widget child;
  final Color color;
  final double width;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.deepOrange,
      shape: const CircleBorder(),
      clipBehavior: Clip.hardEdge,
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(1.0),//10.0
          child: child,
        ),
      ),
    );
  }
}
