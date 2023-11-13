import 'package:cineverse/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContentScrolling extends StatelessWidget {
  final bool isIos;
  final String title;
  final double titleSize;
  final bool more;
  final FontWeight? weight;
  final double? moreSize;
  final Widget mainWidget;

  const ContentScrolling(
      {super.key,
      required this.isIos,
      required this.title,
      required this.titleSize,
      required this.more,
      this.weight,
      this.moreSize,
      required this.mainWidget});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomText(
                text: title,
                weight: weight,
                size: titleSize,
              ),
            ),
            if (more) ...[
              isIos
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CupertinoButton(
                          padding: const EdgeInsets.all(0),
                          child: CustomText(
                            text: 'more'.tr,
                            size: moreSize,
                          ),
                          onPressed: () {}),
                    )
                  : TextButton(
                      onPressed: () {},
                      child: CustomText(text: 'more'.tr, size: moreSize),
                    )
            ]
          ],
        ),
        mainWidget
      ],
    );
  }
}
