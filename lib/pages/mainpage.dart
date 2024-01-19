import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:vortex_gaming_emporium/pages/wallchat.dart';
import 'bookingpage.dart';
import 'homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'history page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    HomePage(),
    BookingPage(),
    WallChat(),
    HistoryPage(),
  ];
  final zones = ["CommanZone","PrivateZone","GameStation"];

  @override
  void initState(){
    super.initState();
    for(String z in zones){
      _fetchAndProcessData(z);
    }

    print("InitState Started");
  }

  Future<void> _fetchAndProcessData(String z) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String collectionName = z;
    QuerySnapshot querySnapshot = await firestore
        .collection(collectionName)
        .get();
    print(z);
    TimeOfDay currentTime = TimeOfDay.fromDateTime(DateTime.now());

    for (QueryDocumentSnapshot document in querySnapshot.docs) {
      List<String> timeSlots = List<String>.from(document['TimeSlot']);

      if (timeSlots.isNotEmpty) {
        String lastSlot = timeSlots.last;
        if (_isBlank(lastSlot, currentTime)) {
          await firestore.collection(collectionName).doc(document.id).delete();
          print("Record Deleted");
        }
      }
    }
  }

  bool _isBlank(String slot, TimeOfDay currentTime) {
    print("Is Blank Called");

    // Example comparison logic based on your timeslot format
    TimeOfDay earliestSelectedTime = _parse(slot.split(' - ')[1]);
    if (currentTime.hour >= earliestSelectedTime.hour &&
        currentTime.minute >= earliestSelectedTime.minute) {
      return true; // Delete the record
    } else {
      return false; // Keep the record
    }
  }

  TimeOfDay _parse(String time) {
    List<String> timeComponents = time.split(' ')[0].split(':');
    int hours = int.parse(timeComponents[0]);
    int minutes = int.parse(timeComponents[1]);
    String amPm = time.split(' ')[1];

    bool isPM = amPm == 'PM';

    print("Original Hours: $hours, Original Minutes: $minutes, isPM: $isPM");

    if (isPM && hours != 12) {
      hours += 12;
    }
    if (!isPM && hours == 12) {
      hours = 0; // 12:00 AM is equivalent to 0:00
    }

    print("Final Hours: $hours, Final Minutes: $minutes");

    return TimeOfDay(hour: hours, minute: minutes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Vortex',style: GoogleFonts.pacifico(color: Colors.black),)),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        leading: Icon(Icons.menu),
        actions: [
          IconButton(onPressed: () {
            showDialog(
                context: context,
                builder: (context){
                  return AlertDialog(
                    title: Text("Sign out confirmation"),
                    content: Text("Want to sign out",style: TextStyle(fontSize: 18),),
                    actions: [
                      MaterialButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Cancel",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        color: Colors.deepPurple,
                      ),
                      MaterialButton(
                        onPressed: () {
                          Navigator.pop(context);
                          FirebaseAuth.instance.signOut();
                        },
                        child: Text(
                          "Sign out",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        color: Colors.deepPurple,
                      )
                    ],
                  );

                });
            }, icon: Icon(Icons.logout,color: Colors.black,)),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1))
        ]),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
            child: GNav(
              gap: 8,
              activeColor: Colors.white,
              iconSize: 24,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              duration: Duration(milliseconds: 500),
              tabBackgroundColor: Colors.deepPurpleAccent,
              tabs: [
                GButton(
                  icon: Icons.home,
                  text: 'Home',
                  backgroundColor: Colors.deepPurpleAccent,
                ),
                GButton(
                  icon: Icons.book,
                  text: 'Booking',
                  backgroundColor: Colors.deepPurpleAccent,
                ),
                GButton(
                  icon: Icons.chat,
                  text: 'Chats',
                  backgroundColor: Colors.deepPurpleAccent,
                ),
                GButton(
                  icon: Icons.history,
                  text: 'History',
                  backgroundColor: Colors.deepPurpleAccent,
                ),
              ],
              selectedIndex: _currentIndex,
              onTabChange: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}