import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MovieWidget extends StatelessWidget {
  final double width;
  final double height;
  final String link;
  final ImageProvider provider;
  final bool shimmer;
  final bool shadow;
  final BoxFit? fit;
  final Color? borderColor;
  final bool? circle;

  const MovieWidget(
      {super.key,
      required this.width,
      required this.height,
      required this.link,
      required this.provider,
      required this.shimmer,
      required this.shadow,
      this.fit,
      this.borderColor,
      this.circle});

  @override
  Widget build(BuildContext context) {
    return shimmer
        ? Shimmer.fromColors(
            baseColor: Theme.of(context).colorScheme.shadow.withOpacity(0.3),
            highlightColor: Colors.grey.withOpacity(0.4),
            child: Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onBackground,
                borderRadius: circle == true ? null : BorderRadius.circular(10),
                shape: circle == true ? BoxShape.circle : BoxShape.rectangle,
                border: Border.all(
                    color: borderColor ?? Theme.of(context).colorScheme.primary,
                    width: 1.5),
              ),
            ),
          )
        : Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              image: DecorationImage(image: provider, fit: fit ?? BoxFit.cover),
              borderRadius: circle == true ? null : BorderRadius.circular(10),
              shape: circle == true ? BoxShape.circle : BoxShape.rectangle,
              border: Border.all(
                  color: borderColor ?? Theme.of(context).colorScheme.primary,
                  width: 1.5),
              boxShadow: shadow == true
                  ? [
                      BoxShadow(
                          color: Theme.of(context).colorScheme.shadow,
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(2, 2))
                    ]
                  : [],
            ),
          );
  }
}
