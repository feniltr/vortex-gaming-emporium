import 'package:flutter/material.dart';

class TextBox extends StatelessWidget {
  final String sectionname;
  final String text;
  final void Function()? onPressed;
  const TextBox({Key? key,required this.sectionname,required this.text,required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
              color: Colors.grey,
              width: 2
          ),
          borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 15,bottom: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //section name
                Text(sectionname,
                  style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700,color: Colors.grey),),

                //setting icon
                IconButton(
                    onPressed: onPressed,
                    icon: Icon(Icons.edit))
              ],
            ),

            //text
            Text(text,
              style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),)
          ],

        ),
      ),

    );
  }
}
