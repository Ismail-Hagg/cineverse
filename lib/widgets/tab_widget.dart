import 'package:cineverse/widgets/custom_text.dart';
import 'package:cineverse/widgets/ios_tab_widget.dart';
import 'package:flutter/material.dart';

class TabWidget extends StatelessWidget {
  final String title;
  final Function() function;
  final bool selected;
  final TargetPlatform platform;
  final double height;
  final double width;
  final EdgeInsets padding;
  const TabWidget(
      {super.key,
      required this.title,
      required this.function,
      required this.selected,
      required this.platform,
      required this.height,
      required this.width,
      required this.padding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: platform == TargetPlatform.android
          ? InkWell(
              onTap: function,
              child: Column(
                children: [
                  SizedBox(
                    height: height * 0.95,
                    width: width,
                    child: Center(
                      child: FittedBox(
                        child: CustomText(
                          size: width * 0.08,
                          color: selected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.4),
                          text: title,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: height * 0.05,
                    color: selected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.4),
                  )
                ],
              ),
            )
          : CupertinoInkWell(
              onPressed: function,
              child: Column(
                children: [
                  SizedBox(
                    width: width,
                    height: height * 0.95,
                    child: Center(
                      child: FittedBox(
                        child: CustomText(
                          size: width * 0.08,
                          color: selected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.4),
                          text: title,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: height * 0.05,
                    color: selected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.4),
                  )
                ],
              ),
            ),
    );
  }
}
