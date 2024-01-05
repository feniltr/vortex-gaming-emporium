import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _email = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }
  Future  ResetPassword() async{
    try{
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _email.text.trim());
      showDialog(context: context, builder: (context){
        return AlertDialog(
          content: Text("Email Has Been Sent To The Email"),
        );
      });
    }on FirebaseAuthException catch(e){
      print(e);
      showDialog(context: context, builder: (context) {
        return AlertDialog(
          content: Text(e.message.toString()),
        );
      },);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
      ),
      backgroundColor: Colors.grey[200],
      body: SafeArea(
          child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Enter Email",style: TextStyle(fontSize: 20),),
                  Text("We Will Send You Email ",style: TextStyle(fontSize: 20),),

                  //Space
                  SizedBox(height: 20,),
                  //Email Input
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),

                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white54,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          border: Border.all(color: Colors.white,width: 5)
                      ),
                      padding: EdgeInsets.only(left: 10),

                      child: TextField(
                        controller: _email,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          fillColor: Colors.white,
                          hintText: "Email",
                        ),
                      ),
                    ),
                  ),

                  //Space
                  SizedBox(height: 20,),

                  //Button Reset Email
                  MaterialButton(onPressed: ResetPassword,
                    padding: EdgeInsets.all(15),
                    child: Text("Reset Password",style: TextStyle(color: Colors.white,fontSize: 18),),
                    color: Colors.deepPurpleAccent,

                  )
                ],
              ))),
    );
  }
}
