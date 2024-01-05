import 'package:flutter/material.dart';
import 'package:vortex_gaming_emporium/pages/privateroomscreen.dart';
import 'package:vortex_gaming_emporium/pages/select_time.dart';
import 'package:vortex_gaming_emporium/pages/select_time_1hr.dart';
import 'package:vortex_gaming_emporium/pages/select_time_gameroom.dart';
import 'gamestation.dart';
import '../components/imagecard.dart';
import '../components/imageslider.dart';

class BookingPage extends StatefulWidget {
  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final List<String> gameImages = [
    'assets/images/game1.jpg',
    'assets/images/game2.jpeg',
    'assets/images/game3.jpg',
    'assets/images/game4.jpg'
  ];

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
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ImageSlider(gameImages: gameImages),
            ),
            SizedBox(height: height(20)),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: width(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Navigate to Common Zone screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => select_Time()),
                          );
                        },
                        child: ImageCard(
                          image: 'assets/images/common_zone.png',
                          title: 'Common Zone - 20 Group Computers',
                          description: 'Enjoy gaming in a shared environment with other gamers.',
                        ),
                      ),

                      SizedBox(height: height(20)),
                      GestureDetector(
                        onTap: () {
                          // Navigate to Private Room screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Select_Time_1hr()),
                          );
                        },
                        child: ImageCard(
                          image: 'assets/images/private_room.png',
                          title: 'Private Room - 10 PCs Available',
                          description: 'Book a private room for a more personalized gaming experience.',
                        ),
                      ),
                      SizedBox(height: height(20)),
                      GestureDetector(
                        onTap: () {
                          // Navigate to Game Room screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Select_time_gameroom()),
                          );
                        },
                        child: ImageCard(
                          image: 'assets/images/vrgame_room.png',
                          title: 'Game Room - Choose a Platform (Xbox, PlayStation, VR)',
                          description: 'Indulge in your favorite gaming platform.',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}