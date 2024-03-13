import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../components/list_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyDrawer extends StatefulWidget {
  final void Function()? onprofiletap;
  final void Function()? onlogouttap;

   MyDrawer({Key? key ,required this.onprofiletap,required this.onlogouttap}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  late String num;

  @override
  void initState() {
    super.initState();
    fetchDataFromFirestore();
  }

    void fetchDataFromFirestore() async {
    FirebaseFirestore.instance.collection('contanct').doc('number').get().then((documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        num = data['callnum'] ?? '';
        print('call num : $num');
      } else {
        print('Document does not exist');
      }
    }).catchError((error) {
      print('Error fetching document: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          DrawerHeader(
              child: Icon(Icons.person,size: 80,)),

          MyListTile(
            icon: Icons.home,
            text: "H O M E",
            onTap: () =>Navigator.pop(context),
          ),

          MyListTile(
            icon: Icons.person,
            text: "P R O F I L E",
            onTap: widget.onprofiletap,
          ),

          MyListTile(
            icon: Icons.call,
            text: "C O N T A C T",
              onTap: () async {
                Uri phoneNumber = Uri.parse('tel:$num');

                if (await canLaunch(phoneNumber.toString())) {
                  await launch(phoneNumber.toString());
                } else {

                }
              }
          ),

          MyListTile(
              icon: Icons.logout,
              text: "L O G O U T",
              onTap: widget.onlogouttap)
        ],
      ),
    );
  }
}
