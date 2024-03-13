import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:vortex_gaming_emporium/components/loading.dart';
import 'package:vortex_gaming_emporium/components/room.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../components/payment.dart';
import 'reciept.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivateRoomScreen extends StatefulWidget {
  List<String> timeSlot;
   PrivateRoomScreen({Key? key, required this.timeSlot}) : super(key: key);

  @override
  _PrivateRoomScreenState createState() => _PrivateRoomScreenState();
}

class _PrivateRoomScreenState extends State<PrivateRoomScreen> {
  List<int> selectedRooms = [];
  List<dynamic> roomList = [];
  bool isLoading = true;
  int ?total;
  final currentuser = FirebaseAuth.instance.currentUser!;
  late String rooms = "";

  @override
  void initState() {
    super.initState();

      fetchDataFromFirestore();

      FirebaseFirestore.instance
          .collection('PrivateZone') // replace with your actual collection name
          .where('TimeSlot', arrayContainsAny: widget.timeSlot)
          .get()
          .then((QuerySnapshot snapshot) {
        print("Selected Time private :${widget.timeSlot}");
        for (var doc in snapshot.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          if (data != null) {
            roomList.addAll(data['ZoneId']);
          }
        }
        print("Selected Time private:${widget.timeSlot}");
        setState(() { isLoading = false;});
      });
    }

  void fetchDataFromFirestore() async {
    FirebaseFirestore.instance.collection('unit').doc('id').get().then((documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        rooms = data['rooms'] ?? '';
        print('rooms : $rooms');
      } else {
        print('Document does not exist');
      }
    }).catchError((error) {
      print('Error fetching document: $error');
    });
  }

  void toggleSelectedComputer(int pc) {
    setState(() {
      if (selectedRooms.contains(pc)) {
        selectedRooms.remove(pc);
        print("selected computers : ${selectedRooms}");
      } else {
        selectedRooms.add(pc);
        print("selected computers : ${selectedRooms}");
      }
    });
  }

  void book(){
    if(selectedRooms.isEmpty){
      CherryToast(
        icon: Icons.report_problem_outlined,
        themeColor: Colors.red,
        title: Text(''),
        displayTitle: false,
        description: Text('Select Room',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
        toastPosition: Position.bottom,
        animationDuration: Duration(milliseconds: 1000),
        autoDismiss: true,
      ).show(context);
    }
    else{
      //calling total function
      _total();

      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Confirm Booking"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListTile(
                    visualDensity:
                    VisualDensity(horizontal: -4, vertical: -4),
                    contentPadding: EdgeInsets.zero,
                    horizontalTitleGap: 0,
                    leading:
                    Icon(Icons.gamepad, color: Colors.deepPurpleAccent),
                    title: Text(
                      'Zone : Private Zone',
                      style: GoogleFonts.openSans(fontSize: 20,color: Colors.grey.shade700
                      ),
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
                        'Rooms : ${selectedRooms}',
                        style: GoogleFonts.openSans(fontSize: 20,color: Colors.grey.shade700)
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
                        'Time Slot : ${widget.timeSlot}',
                        style: GoogleFonts.openSans(fontSize: 20, color: Colors.grey.shade700)
                    ),
                  ),
                  ListTile(
                    visualDensity:
                    VisualDensity(horizontal: -4, vertical: -4),
                    contentPadding: EdgeInsets.zero,
                    horizontalTitleGap: 0,
                    leading: Icon(Icons.currency_rupee,
                        color: Colors.deepPurpleAccent),
                    title: Text(
                        'Total : ${total}',
                        style: GoogleFonts.openSans(fontSize: 20, color: Colors.grey.shade700)
                    ),
                  ),
                ],
              ),
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Payment(email: currentuser.email!,zonid: selectedRooms,timslot: widget.timeSlot,total: total!,zone: "PrivateZone")));
                  },
                  child: Text(
                    "Book",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  color: Colors.deepPurple,
                )
              ],
            );
          });
    }
  }

  void send_data(){
    FirebaseFirestore.instance.collection("PrivateZone").add({
      'Email' : currentuser.email!,
      'ZoneId' : selectedRooms,
      'TimeSlot' : widget.timeSlot,
      'total' : total
    });

    //send data to receipt
    Navigator.push(context, MaterialPageRoute(builder: (context) =>
        Receipt(
          email: currentuser.email!,
          Computer: selectedRooms,
          TimeSlot: widget.timeSlot,
          total: total!,
          zone: "Private Zone",
        ),));
  }

  void _total(){
    int comps = (selectedRooms.length);
    int slots = (widget.timeSlot.length);

    total = (60 * slots) * comps;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Priate Zone',style: GoogleFonts.openSans(color: Colors.black),)),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(onPressed: () => null, icon: Icon(Icons.logout,color: Colors.white,)),
        ],
      ),
      body: isLoading ? Center(child: Loading()): Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: int.parse(rooms),
              itemBuilder: (context, index) {
                final pc = (index + 1);
                final isSelected = selectedRooms.contains(pc);

                if (roomList.contains(pc)) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.deepPurple : Colors.red,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text('Booked ${index + 1}'),
                      ),
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        toggleSelectedComputer(pc);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: isSelected
                              ? LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF6600FF), Color(0xFFFF66FF)],
                          )
                              : null,
                          color: isSelected ? null : Colors.white,
                          border: Border.all(
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: isSelected ? Colors.black.withOpacity(0.3) : Colors.transparent,
                              blurRadius: isSelected ? 10 : 0,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'Room ${index + 1}',
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontSize: 16, // Adjust font size as needed
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    )
                  );
                }
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: book,
                  child: Container(
                    width: 150,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Book',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}