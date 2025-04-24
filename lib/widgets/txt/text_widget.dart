import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final double textSize;
  bool isTitle;
  int maxLines;
  Color color;
  //overflow TextOverflow;

  TextWidget({super.key,
    required this.text,
    required this.textSize,
    this.isTitle = false,
    this.maxLines = 10,
    this.color = Colors.white,
    //this.overflow = TextOverflow.ellipsis,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      style: TextStyle(
        overflow: TextOverflow.ellipsis,
        color: color,
        fontSize: textSize,
        fontWeight: isTitle ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}

