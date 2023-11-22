import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'custom_text.dart';

class Menu extends StatelessWidget {
  final bool ios;
  final List<String> titles;
  final List<Function()> funcs;
  final Widget child;

  const Menu({
    super.key,
    required this.ios,
    required this.titles,
    required this.funcs,
    required this.child,
  });

  void thing({required BuildContext context}) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: titles
            .map(
              (e) => CupertinoActionSheetAction(
                onPressed: funcs[titles.indexOf(e)],
                child: CustomText(text: titles[titles.indexOf(e)]),
              ),
            )
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ios
        ? CupertinoButton(
            padding: const EdgeInsets.all(0),
            onPressed: () => thing(context: context),
            child: child,
          )
        : PopupMenuButton(
            padding: const EdgeInsets.all(0.0),
            splashRadius: 15,
            //icon: child,
            itemBuilder: (context) {
              return titles
                  .map(
                    (e) => PopupMenuItem<int>(
                      value: titles.indexOf(e),
                      child: Text(e),
                    ),
                  )
                  .toList();
            },
            onSelected: (value) {
              funcs[value]();
            },
            child: child,
          );
  }
}
