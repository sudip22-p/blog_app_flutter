import 'package:flutter/material.dart';
import 'package:blog_app/common/common.dart';

class BorderedText extends StatelessWidget {
  final String text;
  final TextStyle textStyle;
  final Color borderColor;
  final double borderWidth;

  const BorderedText({
    super.key,
    required this.text,
    this.textStyle = const TextStyle(
      fontSize: 48,
      fontWeight: FontWeight.bold,
      color: Colors.black, // This color will be overridden for the fill
    ),
    this.borderColor = Colors.blue,
    this.borderWidth = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // The outline text
        ParentTextWidget(
          text,
          style: textStyle.copyWith(
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = borderWidth
              ..color = borderColor,
          ),
        ),
        // The transparent fill text (placed on top for alignment)
        ParentTextWidget(
          text,
          style: textStyle.copyWith(
            color: Colors.transparent, // Makes the fill transparent
          ),
        ),
      ],
    );
  }
}
