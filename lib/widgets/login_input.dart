import 'package:flutter/material.dart';

class LoginInput extends StatelessWidget {
  final double height;
  final double width;
  final FocusNode? focusNode;
  final bool isSelected;
  final String? hintText;
  final TextEditingController? controller;
  final Icon? leadingIcon;
  final bool obscure;
  final Widget? suffex;
  final TextInputType? type;
  final TextInputAction? action;
  final Color? suffexColor;
  final Widget? other;
  final Function()? socialLog;
  const LoginInput(
      {super.key,
      required this.height,
      required this.width,
      this.focusNode,
      this.hintText,
      this.controller,
      this.leadingIcon,
      required this.obscure,
      this.suffex,
      this.type,
      this.action,
      required this.isSelected,
      this.suffexColor,
      this.other,
      this.socialLog});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        color: Theme.of(context).colorScheme.background,
        boxShadow: other == null
            ? isSelected
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
                        offset: const Offset(1, 1),
                        spreadRadius: 0.1),
                  ]
            : [
                BoxShadow(
                    color: Theme.of(context).colorScheme.shadow,
                    blurRadius: 5,
                    offset: const Offset(2, 2),
                    spreadRadius: 0.5),
              ],
      ),
      child: Center(
        child: GestureDetector(
          onTap: socialLog,
          child: other ??
              TextField(
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
      ),
    );
  }
}