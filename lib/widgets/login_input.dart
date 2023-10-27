import 'package:flutter/material.dart';

class LoginInput extends StatelessWidget {
  final double height;
  final double width;
  final FocusNode focusNode;
  final bool isSelected;
  final String hintText;
  final TextEditingController controller;
  final Icon leadingIcon;
  final bool obscure;
  final Widget? suffex;
  final TextInputType type;
  final TextInputAction? action;
  final Color? suffexColor;
  const LoginInput(
      {super.key,
      required this.height,
      required this.width,
      required this.focusNode,
      required this.hintText,
      required this.controller,
      required this.leadingIcon,
      required this.obscure,
      this.suffex,
      required this.type,
      this.action,
      required this.isSelected,
      this.suffexColor});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(2)),
        color: Theme.of(context).colorScheme.background,
        boxShadow: isSelected
            ? [
                BoxShadow(
                    color: Theme.of(context).colorScheme.shadow,
                    blurRadius: 10,
                    offset: const Offset(3, 3),
                    spreadRadius: 1),
              ]
            : [
                BoxShadow(
                    color: Theme.of(context).colorScheme.secondary,
                    blurRadius: 0.1,
                    offset: const Offset(0, 1),
                    spreadRadius: 0.1),
              ],
      ),
      child: Center(
        child: TextField(
          obscureText: obscure,
          textInputAction: action,
          keyboardType: type,
          focusNode: focusNode,
          controller: controller,
          showCursor: false,
          decoration: InputDecoration(
              prefixIcon: leadingIcon,
              prefixIconColor: Theme.of(context).colorScheme.secondary,
              suffixIcon: suffex,
              suffixIconColor: suffexColor,
              border: InputBorder.none,
              hintText: hintText),
        ),
      ),
    );
  }
}
