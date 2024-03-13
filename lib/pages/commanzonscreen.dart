import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vortex_gaming_emporium/components/loading.dart';
import 'package:vortex_gaming_emporium/pages/reciept.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cherry_toast/cherry_toast.dart';
import '../components/payment.dart';


class CommonZoneScreen extends StatefulWidget {
  List<String> t;

  CommonZoneScreen({Key? key, required this.t}) : super(key: key);

  @override
  State<CommonZoneScreen> createState() => _CommonZoneScreenState();
}

class _CommonZoneScreenState extends State<CommonZoneScreen> {
  List<dynamic> computerList = [];
  List<int> selectedComputers = [];
  bool isselected = false;
  int? total;
  bool isLoading = true;
  final currentuser = FirebaseAuth.instance.currentUser!;
  late String computers = '';

  @override
  void initState(){
    super.initState();

    fetchDataFromFirestore();


    FirebaseFirestore.instance
        .collection('CommanZone')
        .where('TimeSlot', arrayContainsAny: widget.t)
        .get()
        .then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if (data != null) {
          computerList.addAll(data['ZoneId']);
        }
      }
      setState(() {isLoading = false;});
    });
  }

  void fetchDataFromFirestore() async {
    FirebaseFirestore.instance.collection('unit').doc('id').get().then((documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        computers = data['computers'] ?? '';
        print('Computer Name: $computers');
      } else {
        print('Document does not exist');
      }
    }).catchError((error) {
      print('Error fetching document: $error');
    });
  }

  void toggleSelectedComputer(int pc) {
    setState(() {
      if (selectedComputers.contains(pc)) {
        selectedComputers.remove(pc);
        print("selected computers : ${selectedComputers}");
      } else {
        selectedComputers.add(pc);
        print("selected computers : ${selectedComputers}");
      }
    });
  }

  void book(){
    if(selectedComputers.isEmpty){
      CherryToast(
        icon: Icons.report_problem_outlined,
        themeColor: Colors.red,
        title: Text(''),
        displayTitle: false,
        description: Text('Select Computer',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
        toastPosition: Position.bottom,
        animationDuration: Duration(milliseconds: 1000),
        autoDismiss: true,
      ).show(context);
    }
    else{
      _total();
      //show email
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
                      'Zone : Common Zone',
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
                        'Computers : ${selectedComputers}',
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
                        'Time Slot : ${widget.t}',
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
                    //send_data();
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Payment(email: currentuser.email!,zonid: selectedComputers,timslot: widget.t,total: total!,zone: "CommanZone")));
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
    FirebaseFirestore.instance.collection("CommanZone").add({
      'Email' : currentuser.email!,
      'ZoneId' : selectedComputers,
      'TimeSlot' : widget.t,
      'total' : total
    });
    print("Sended data");

    FirebaseFirestore.instance.collection("transactions").add({
      'zone' : "commanzone",
      'Email' : currentuser.email!,
      'ZoneId' : selectedComputers,
      'TimeSlot' : widget.t,
      'total' : total,
    });

    //send data to receipt
    Navigator.push(context,MaterialPageRoute(builder: (context) =>
        Receipt(
          email: currentuser.email!,
          Computer: selectedComputers,
          TimeSlot: widget.t,
          total: total!,
          zone: "Common Zone",
        ),));
    
    print("Navigated");
  }

  void _total(){
    int comps = (selectedComputers.length);
    int slots = (widget.t.length);

    total = (15 * slots) * comps;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Common Zone',style: GoogleFonts.openSans(color: Colors.black),)),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(onPressed: () => null, icon: Icon(Icons.logout,color: Colors.white,)),
        ],
      ),
      body: isLoading ? Center(child: Loading())
      :Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: int.parse(computers),
              itemBuilder: (context, index) {
                final pc = (index + 1);
                final isSelected = selectedComputers.contains(pc);

                if (computerList.contains(pc)) {
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
                            'Computer ${index + 1}',
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
