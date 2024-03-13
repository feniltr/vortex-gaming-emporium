import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OpeningHoursContainer extends StatefulWidget {
  @override
  State<OpeningHoursContainer> createState() => _OpeningHoursContainerState();
}

class _OpeningHoursContainerState extends State<OpeningHoursContainer> {
  String openTime = "Loading";
  String closeTime = "Loading";
  String status = "Loading";

  String getCurrentStatus() {
    DateTime currentTime = DateTime.now();
    DateTime open = DateTime(currentTime.year, currentTime.month, currentTime.day, 9, 0);
    DateTime close = DateTime(currentTime.year, currentTime.month, currentTime.day, 19, 0);

    if (currentTime.isAfter(open) && currentTime.isBefore(close)) {
      return "Open";
    } else {
      return "Closed";
    }
  }

  void fetchDataFromFirebase() async {
    try {
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('OpenHourTime').get();

      if (querySnapshot.docs.isNotEmpty) {
        Map<String, dynamic> data =
        querySnapshot.docs.first.data() as Map<String, dynamic>;

        setState(() {
          openTime = data['opentime'] ?? "";
          closeTime = data['closetime'] ?? "";
          status = data['status'] ?? "";
        });

        print("Open Time: $openTime");
        print("Close Time: $closeTime");
        print("Status Time: $status");
      } else {
        print("No documents found in the collection.");
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    // Call the function to fetch data from Firebase when the widget is initialized
    fetchDataFromFirebase();
    getCurrentStatus();
  }

  @override
  Widget build(BuildContext context) {
    final double paddingVertical = MediaQuery.of(context).size.height * 0.023;
    final double paddingHorizontal = MediaQuery.of(context).size.width * 0.23;
    final double fontSizeOpenTime = MediaQuery.of(context).size.width * 0.05;
    final double fontSizeStatus = MediaQuery.of(context).size.width * 0.06;
    final double fontSizeClosingTime = MediaQuery.of(context).size.width * 0.047;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(height: paddingVertical),
        Container(
          padding: EdgeInsets.symmetric(horizontal: paddingHorizontal, vertical: paddingVertical),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 4,
                offset: Offset(0, 2), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                "Open time: $openTime",
                style: TextStyle(fontSize: fontSizeOpenTime),
              ),
              Text(
                status,
                style: TextStyle(
                  fontSize: fontSizeStatus,
                  fontWeight: FontWeight.bold,
                  color: status == "Open" ? Colors.green : Colors.red,
                ),
              ),
              Text(
                "Closing time: $closeTime",
                style: TextStyle(fontSize: fontSizeClosingTime),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
