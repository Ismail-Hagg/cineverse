import 'package:flutter/cupertino.dart';

class NotificationWidget extends StatelessWidget {
  final bool isNotify;
  final Widget mainWidget;
  final double? top;
  final double? right;
  final double? left;
  final double? bottom;
  final Color notificationColor;
  final double height;
  final double width;
  const NotificationWidget(
      {super.key,
      required this.mainWidget,
      this.top,
      this.right,
      this.left,
      this.bottom,
      required this.notificationColor,
      required this.height,
      required this.width,
      required this.isNotify});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        mainWidget,
        if (isNotify) ...[
          Positioned(
            top: top,
            right: right,
            left: left,
            bottom: bottom,
            child: Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                  color: notificationColor, shape: BoxShape.circle),
            ),
          )
        ]
      ],
    );
  }
}
