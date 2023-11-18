import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CupertinoInkWell extends StatefulWidget {
  const CupertinoInkWell({
    Key? key,
    required this.child,
    required this.onPressed,
  }) : super(key: key);

  final Widget child;
  final VoidCallback? onPressed;

  bool get enabled => onPressed != null;

  @override
  State<CupertinoInkWell> createState() => _CupertinoInkWellState();
}

class _CupertinoInkWellState extends State<CupertinoInkWell> {
  bool _buttonHeldDown = false;

  void _handleTapDown(TapDownDetails event) {
    if (!_buttonHeldDown) {
      setState(() {
        _buttonHeldDown = true;
      });
    }
  }

  void _handleTapUp(TapUpDetails event) {
    if (_buttonHeldDown) {
      setState(() {
        _buttonHeldDown = false;
      });
    }
  }

  void _handleTapCancel() {
    if (_buttonHeldDown) {
      setState(() {
        _buttonHeldDown = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.enabled;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: enabled ? _handleTapDown : null,
      onTapUp: enabled ? _handleTapUp : null,
      onTapCancel: enabled ? _handleTapCancel : null,
      onTap: widget.onPressed,
      child: Semantics(
        button: true,
        child: _buttonHeldDown
            ? Container(
                color: Get.isDarkMode
                    ? Colors.white.withOpacity(0.3)
                    : Theme.of(context).colorScheme.shadow.withOpacity(0.5),
                child: widget.child,
              )
            : widget.child,
      ),
    );
  }
}
