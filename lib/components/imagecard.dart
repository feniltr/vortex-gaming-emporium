import 'package:flutter/material.dart';

class ImageCard extends StatefulWidget {
  final String image;
  final String title;
  final String description;

  const ImageCard({
    Key? key,
    required this.image,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  State<ImageCard> createState() => _ImageCardState();
}

class _ImageCardState extends State<ImageCard> {
  double height(double s){
    final double t = (s/MediaQuery.of(this.context).size.height)*MediaQuery.of(this.context).size.height;
    return t;
  }

  double width(double s){
    final double t = (s/MediaQuery.of(this.context).size.width)*MediaQuery.of(this.context).size.width;
    return t;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height(120),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 4,
            blurRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(width: width(10)),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              widget.image,
              width: width(100),
              height: height(100),
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: width(10)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: height(14),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: height(6)),
                Text(
                  widget.description,
                  style: TextStyle(
                    fontSize: height(14),
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: width(10)),
        ],
      ),
    );
  }
}