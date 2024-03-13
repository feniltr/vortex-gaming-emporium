import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vortex_gaming_emporium/components/loading.dart';
import '../components/empty.dart';


class HistoryPage extends StatefulWidget {
  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final currentuser = FirebaseAuth.instance.currentUser!;
  late User? _currentUser;
  bool isLoading = true;
  List<dynamic> gameList = [];
  List<dynamic> timeslot = [];
  List<String> collection = [];

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser;
    print("Current Email : ${_currentUser!.email!}");
    fetchData(_currentUser!.email!); // Use current user's email ID
  }

  Future<void> fetchData(String emailId) async {
    await fetchCollectionData('CommanZone', emailId);
    await fetchCollectionData('PrivateZone', emailId);
    await fetchCollectionData('GameStation', emailId);

    setState(() {
      isLoading = false;
    });
  }

  // Function to fetch data from a specific collection based on user's email ID
  Future<void> fetchCollectionData(String collectionName, String emailId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await firestore
        .collection(collectionName)
        .where('Email', isEqualTo: emailId)
        .get();

    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String,dynamic>;
      if (data != null) {


        List<dynamic> zoneIdList = data['ZoneId'];
        List<String> zoneIdStrings = zoneIdList.map((e) => e.toString()).toList();
        List<dynamic> zoneIdIntegers = zoneIdStrings.map((e) => int.parse(e)).toList();


        gameList.add(zoneIdIntegers);
        print('gameList : ${gameList}');

        List<dynamic> timeIdList = data['TimeSlot'];
        List<String> timeIdStrings = timeIdList.map((e) => e.toString()).toList();
        timeslot.add(timeIdStrings);


        collection.add(collectionName);

      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double size = MediaQuery.of(context).size.width * 0.055;
    final double detailsize = MediaQuery.of(context).size.width * 0.050;
    final double iconhead = MediaQuery.of(context).size.width * 0.07;

    return Scaffold(
      body: isLoading
          ? Loading()
       : (gameList.length == 0) ? Empty() : ListView.builder(
        itemCount: gameList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Card(
                color: Colors.white,
                elevation: 15,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        visualDensity:
                        VisualDensity(horizontal: -4, vertical: -4),
                        contentPadding: EdgeInsets.zero,
                        horizontalTitleGap: 0,
                        leading:
                        Icon(Icons.gamepad, color: Colors.deepPurpleAccent),
                        title: Text(
                          '${collection[index]}',
                          style: GoogleFonts.openSans(fontSize: size,color: Colors.black
                          ),
                        ),
                      ),
                      ListTile(
                        visualDensity:
                        VisualDensity(horizontal: -4, vertical: -4),
                        contentPadding: EdgeInsets.zero,
                        horizontalTitleGap: 0,
                        leading: Icon(Icons.timer_rounded,
                            color: Colors.deepPurpleAccent),
                        title: Text(
                          '${timeslot[index]}',
                          style: GoogleFonts.openSans(fontSize: detailsize, color: Colors.grey.shade700)
                        ),
                      ),
                      ListTile(
                        visualDensity:
                        VisualDensity(horizontal: -4, vertical: -4),
                        contentPadding: EdgeInsets.zero,
                        horizontalTitleGap: 0,
                        leading: Icon(Icons.computer_rounded,
                            color: Colors.deepPurpleAccent),
                        title: Text(
                          '${gameList[index]}',
                          style: GoogleFonts.openSans(fontSize: detailsize,color: Colors.grey.shade700)
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),

    );
  }
}