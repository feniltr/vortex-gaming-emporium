import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PaymentDone extends StatelessWidget {
  const PaymentDone({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset('animation/paydone.json',
          height: 300,
          repeat: true,
          fit: BoxFit.cover
      ),
    );
  }
}
