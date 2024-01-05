import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';


class ImageSlider extends StatefulWidget {
  final List<String> gameImages;

  const ImageSlider({Key? key, required this.gameImages}) : super(key: key);

  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  int _currentPage = 0;

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
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 0, left: 10, right: 10),
      child: Stack(
        children: [
          CarouselSlider.builder(
            itemCount: widget.gameImages.length,
            itemBuilder: (BuildContext context, int index, int realIndex) {
              return Image.asset(
                widget.gameImages[index],
                fit: BoxFit.cover,
              );
            },
            options: CarouselOptions(
              height: height(400),
              initialPage: _currentPage,
              autoPlay: true,
              enlargeCenterPage: true,
              autoPlayInterval: Duration(seconds: 3),
              onPageChanged: (index, reason) {
                setState(() {
                  _currentPage = index;
                });
              },
            ),
          ),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.gameImages.length, (index) {
                return Container(
                  width: width(10),
                  height: height(10),
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index ? Colors.blue : Colors.grey,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
