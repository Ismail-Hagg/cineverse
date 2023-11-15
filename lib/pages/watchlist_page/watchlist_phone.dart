import 'package:cineverse/widgets/image_network.dart';
import 'package:flutter/cupertino.dart';

class WatchlistPhone extends StatelessWidget {
  const WatchlistPhone({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: ImageNetWork(
          height: 100,
          width: 100,
          link:
              'https://i.pinimg.com/originals/46/ea/0b/46ea0bf4f3985f905aa215c42c5b3133.jpg'),
    );
  }
}
