import 'package:flutter/material.dart';

class Mytext extends StatelessWidget {
  final msg;
  Mytext({Key? key ,required this.msg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(msg,style: TextStyle(fontSize: 20),);
  }
}
