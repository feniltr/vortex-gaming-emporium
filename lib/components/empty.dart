import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Empty extends StatelessWidget {
  const Empty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset('animation/empty.json',
          height: 300,
          repeat: true,
          fit: BoxFit.cover
      ),
    );
  }
}
