import 'package:flutter/material.dart';

class HomePhone extends StatelessWidget {
  const HomePhone({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
            onTap: () {
              List<String> lst = [];
              var thing = lst.join(',');
              print(thing);
              print(thing.runtimeType);

              var back = thing.split(',');
              print(back);
              print(back.runtimeType);
            },
            child: Text('Phone View ${MediaQuery.of(context).size.width}')),
      ),
    );
  }
}
