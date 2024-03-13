import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vortex_gaming_emporium/components/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../components/OpeningHours.dart';
import 'package:google_fonts/google_fonts.dart';
import 'bookingpage.dart';
import 'select_time.dart';
import 'select_time_1hr.dart';
import 'select_time_gameroom.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final currentuser = FirebaseAuth.instance.currentUser!;
  List<String> zones = ['Common Zone', 'Private Zone', 'Game Zone'];
  List<String> images = ['assets/images/common_zone.png', 'assets/images/private_room.png', 'assets/images/vrgame_room.png'];
  List<int> price = [];
  List<Widget> pages = [select_Time(), Select_Time_1hr(), Select_time_gameroom()];

  @override
  void initState() {
    super.initState();
    fetchDataFromFirestore();
  }

  Future<void> fetchDataFromFirestore() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('ZonePrice').doc('prices').get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;

        int cz = data['commanzone'] ?? 0;
        price.add(cz);
        int rm = data['privatezone'] ?? 0;
        price.add(rm);
        int gz = data['gamestation'] ?? 0;
        price.add(gz);

        print("Prices : $price");
      } else {
        print('Document does not exist');
      }
    } catch (error) {
      print('Error fetching document: $error');
    }
  }

  void route(int index) {
    Navigator.push(this.context, MaterialPageRoute(builder: (context) => pages[index]));
  }

  double hsizewelcome(double s) {
    return s * MediaQuery.of(context).size.height / 812;
  }

  double wsizewelcome(double s) {
    return s * MediaQuery.of(context).size.width / 375;
  }

  double size(double s) {
    return s * MediaQuery.of(context).size.width / 375;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            OpeningHoursContainer(),

            Expanded(
              child: FutureBuilder(
                future: fetchDataFromFirestore(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: Loading());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Container(
                      height: hsizewelcome(300),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: zones.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => BookingPage())),
                            child: Container(
                              width: wsizewelcome(300),
                              margin: EdgeInsets.all(wsizewelcome(15)),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(wsizewelcome(50)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    spreadRadius: wsizewelcome(2),
                                    blurRadius: wsizewelcome(4),
                                    offset: Offset(0, wsizewelcome(2)),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Image(
                                    image: AssetImage(images[index]),
                                    height: hsizewelcome(300),
                                    width: wsizewelcome(300),
                                    fit: BoxFit.cover,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(wsizewelcome(8.0)),
                                    child: Text(
                                      zones[index],
                                      style: GoogleFonts.openSans(fontSize: hsizewelcome(25), fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: wsizewelcome(9),
                                      top: wsizewelcome(9),
                                      right: wsizewelcome(9),
                                      bottom: hsizewelcome(20),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(wsizewelcome(15)),
                                          bottomRight: Radius.circular(wsizewelcome(15)),
                                        ),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.2),
                                            spreadRadius: wsizewelcome(3),
                                            blurRadius: wsizewelcome(10),
                                            offset: Offset(wsizewelcome(2), wsizewelcome(2)),
                                          ),
                                        ],
                                      ),
                                      height: hsizewelcome(50),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(wsizewelcome(25)),
                                              color: Colors.white,
                                            ),
                                            height: hsizewelcome(30),
                                            width: wsizewelcome(180),
                                            child: Center(
                                              child: Text(
                                                index == 0 ? '${price[index].toString()} ₹  30 Minutes' : '${price[index].toString()} ₹  1 Hour',
                                                style: GoogleFonts.openSans(fontSize: hsizewelcome(20)),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
