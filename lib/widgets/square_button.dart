import 'package:flutter/cupertino.dart';

class SquareButton extends StatelessWidget {
  final double? padding;
  final Function() function;
  final double height;
  final double width;
  final Color color;
  final IconData icon;
  final Color iconColor;

  const SquareButton(
      {super.key,
      this.padding,
      required this.function,
      required this.height,
      required this.width,
      required this.color,
      required this.icon,
      required this.iconColor});

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
              borderRadius: BorderRadius.circular(10), color: color),
          child: Center(
            child: Icon(
              icon,
              color: iconColor,
            ),
          ),
        ),
      ),
    );
  }
}
