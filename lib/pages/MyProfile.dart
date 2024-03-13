import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vortex_gaming_emporium/components/text_box.dart';

class MyProfile extends StatefulWidget {
  MyProfile({Key? key}) : super(key: key);

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final userCollection = FirebaseFirestore.instance.collection("Users");

  late Map<String, dynamic> userData = {};

  Future<void> edit(String field) async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text("Edit $field"),
        content: TextField(
          autofocus: true,
          decoration: InputDecoration(
            hintText: "Enter new $field",
          ),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(newValue),
            child: Text("Save"),
          )
        ],
      ),
    );

    // Update in Firebase
    if (newValue.trim().isNotEmpty) {
      QuerySnapshot querySnapshot = await userCollection.where("email", isEqualTo: currentUser.email).get();
      if (querySnapshot.docs.isNotEmpty) {
        // Assuming there's only one document for the given email
        String documentId = querySnapshot.docs[0].id;
        await userCollection.doc(documentId).update({field: newValue});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "P R O F I L E",
            style: TextStyle(color: Colors.black),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: userCollection.where("email", isEqualTo: currentUser.email).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            for (QueryDocumentSnapshot userDocument in snapshot.data!.docs) {
              // Access data from the document
              userData = userDocument.data() as Map<String, dynamic>;
              print("user data :$userData");
            }

            return ListView(
              children: [
                // person icon
                Icon(Icons.person, size: 100),

                // current user email
                Text(
                  currentUser.email.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 20),
                  child: Text(
                    "My Details ",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextBox(
                    sectionname: "User Name",
                    text: userData['username'].toString() ?? 'N/A',
                    onPressed: () => edit('username'),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextBox(
                    sectionname: "Gender",
                    text: userData['gender'].toString() ?? 'N/A',
                    onPressed: () => edit('gender'),
                  ),
                ),

              ],
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error.toString()}');
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
