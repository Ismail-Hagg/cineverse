import 'package:flutter/material.dart';

class SquareButton extends StatelessWidget {
  final double? padding;
  final Function() function;
  final double height;
  final double width;
  final Color color;
  final IconData icon;
  final Color iconColor;
  final bool isFilled;
  final bool? clear;

  const SquareButton(
      {super.key,
      this.padding,
      required this.function,
      required this.height,
      required this.width,
      required this.color,
      required this.icon,
      required this.iconColor,
      required this.isFilled,
      this.clear});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding ?? 16.0),
      child: GestureDetector(
        onTap: function,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
              border: Border.all(color: color),
              borderRadius: BorderRadius.circular(10),
              color: isFilled
                  ? color
                  : clear == true
                      ? Colors.transparent
                      : Theme.of(context).colorScheme.background),
          child: Center(
            child: Icon(
              icon,
              color: isFilled || clear == true
                  ? iconColor
                  : Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }
}
