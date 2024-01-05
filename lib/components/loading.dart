import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset('animation/amongusloading.json',
          height: 300,
          repeat: true,
          fit: BoxFit.cover
      ),
    );
  }
}
