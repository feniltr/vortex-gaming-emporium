import 'package:flutter/material.dart';

class MyListTile extends StatelessWidget {
  final void Function()? onTap;
  final IconData icon;
  final String text;
  const MyListTile({Key? key,required this.icon,required this.text,required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 30),
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          icon,
          color: Colors.black,
        ),
        title: Text(text,
          style: TextStyle(fontWeight: FontWeight.bold,fontSize:18),),
      ),
    );
  }
}
