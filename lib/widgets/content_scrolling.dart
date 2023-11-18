import 'package:cineverse/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContentScrolling extends StatelessWidget {
  final bool isIos;
  final String title;
  final double titleSize;
  final bool more;
  final Widget? otherMore;
  final bool? other;
  final FontWeight? weight;
  final double? moreSize;
  final Widget mainWidget;
  final double? padding;

  const ContentScrolling(
      {super.key,
      required this.isIos,
      required this.title,
      required this.titleSize,
      required this.more,
      this.weight,
      this.moreSize,
      required this.mainWidget,
      this.otherMore,
      this.other,
      this.padding});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.all(padding ?? 8.0),
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
            ],
            if (other == true) ...[otherMore as Widget]
          ],
        ),
        mainWidget
      ],
    );
  }
}
