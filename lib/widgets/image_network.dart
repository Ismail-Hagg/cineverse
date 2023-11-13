import 'package:cached_network_image/cached_network_image.dart';
import 'package:cineverse/widgets/movie_widget.dart';
import 'package:flutter/cupertino.dart';

class ImageNetWork extends StatelessWidget {
  final String link;
  final double width;
  final double height;
  final bool? shadow;
  final bool? shimmer;
  final Color? border;
  final Function()? function;
  const ImageNetWork(
      {super.key,
      required this.link,
      required this.width,
      this.function,
      required this.height,
      this.shadow,
      this.shimmer,
      this.border});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: CachedNetworkImage(
        imageUrl: link,
        imageBuilder: (context, imageProvider) {
          return MovieWidget(
            borderColor: border,
            shadow: shadow ?? true,
            shimmer: shimmer ?? false,
            fit: BoxFit.cover,
            provider: imageProvider,
            height: height,
            width: width,
            link: link,
          );
        },
        placeholder: (context, url) {
          return MovieWidget(
            shadow: false,
            shimmer: true,
            provider: Image.asset('assets/images/no_image.png').image,
            height: height,
            width: width,
            link: link,
          );
        },
        errorWidget: (context, url, error) {
          return MovieWidget(
            shadow: false,
            shimmer: false,
            fit: BoxFit.contain,
            provider: Image.asset('assets/images/no_image.png').image,
            height: height,
            width: width,
            link: link,
          );
        },
      ),
    );
  }
}
