import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vortex_gaming_emporium/components/loading.dart';
import 'forgot_password.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

class Login_page extends StatefulWidget {
  final VoidCallback showRegisterPage;

  const Login_page({Key? key,required this.showRegisterPage}) : super(key: key);

  @override
  State<Login_page> createState() => _Login_pageState();
}

class _Login_pageState extends State<Login_page>{
  FocusNode Nd_email = FocusNode();
  FocusNode Nd_passwprd = FocusNode();
  final formkey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool visibility = true;
  bool connected = false;

  /*Future<bool> checkGoogleResponse() async {
    try {
      final response = await http.get(Uri.parse('https://www.google.com'));
      print("Internet on");
      setState(() {
        connected = true;
      });
      return response.statusCode == 200;

    } catch (e) {
      setState(() {
        connected = false;
      });
      print("Internet off");
      return false;
    }
  }*/

  /*void show(){
    if(!connected){
      Center(
        child: Lottie.asset('animation/nointernet.json',
            height: 300,
            repeat: true,
            fit: BoxFit.cover
        ),
      );
    }
  }*/

  @override
  void initState(){
    super.initState();

   /* checkGoogleResponse();
    show();*/
  }

  @override
  void dispose(){
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future signIn() async {
    try {
      if(formkey.currentState!.validate()) {
        showDialog(
            context: context,
            builder: (context) {
              return Center(child: Loading());
            });
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _email.text.trim(), password: _password.text.trim());
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      print(e);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text("Email or password is wrong check out again"),
              actions: [
                MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Ok",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  color: Colors.deepPurple,
                )
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  //Icon
                  Icon(Icons.lock_rounded,size: 150,),

                  //Space
                  SizedBox(height: 30),

                  Text("Hello Again",style: GoogleFonts.bebasNeue(fontSize: 60),),

                  const Text(
                    "Long Time No See , Let's Start",
                    style: TextStyle(fontSize: 20),
                  ),
                  //space
                  SizedBox(height: 20,),

                  Form(
                      key: formkey,
                      child: Column(
                        children: [
                          //Email Input
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 20.0),
                            child: TextFormField(
                              focusNode: Nd_email,
                              onFieldSubmitted: (value){
                                FocusScope.of(context).requestFocus(Nd_passwprd);
                              },
                              controller: _email,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Email is required";
                                } else if (!value.contains('@') || !value.contains(".com")) {
                                  return "Enter valid email";
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 4)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                    borderSide: BorderSide(
                                        color: Colors.deepPurpleAccent, width: 4)),
                                prefixIcon: Icon(Icons.email,color: Colors.deepPurpleAccent,),
                                hintText: "Email",
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          //Password Input
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 20.0),
                            child: TextFormField(
                              focusNode: Nd_passwprd,
                              controller: _password,
                              obscureText: visibility,
                              validator: (value){
                                if(value == null || value.isEmpty){
                                  return "Password is required";
                                }else if(value.length < 6){
                                  return "6 Digit password required";
                                }
                              },
                              decoration: InputDecoration(
                                enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 4)),
                                focusedBorder: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                    borderSide: BorderSide(
                                        color: Colors.deepPurpleAccent, width: 4)),
                                prefixIcon: Icon(Icons.password,color: Colors.deepPurpleAccent,),
                                hintText: "Password",
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      visibility = !visibility;
                                      setState(() {
                                      });
                                    },
                                    icon: visibility
                                        ? Icon(Icons.visibility,color: Colors.deepPurpleAccent,)
                                        : Icon(Icons.visibility_off,color: Colors.deepPurpleAccent,)),
                              ),
                            ),
                          ),

                          //Space
                          SizedBox(
                            height: 10,
                          ),
                          //Forgot Password
                          Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ForgotPassword(),
                                          ));
                                    },
                                    child: Text("Forgot Password ?",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.deepPurpleAccent)),
                                  ),
                                ],
                              )),

                          //Space
                          SizedBox(
                            height: 20,
                          ),

                          //Sign in Button
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text("Sign in",style: GoogleFonts.roboto(fontSize: 30)),
                                GestureDetector(
                                    onTap: signIn,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.deepPurpleAccent,
                                      maxRadius: 30,

                                      child: Icon(Icons.keyboard_arrow_right,size: 50,color: Colors.white,),
                                    )
                                ),
                              ],
                            ),
                          ),

                          //Space
                          SizedBox(height: 20,),

                          //New Member Regiseter Text
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Not a member ?",style: TextStyle(fontSize: 15),),

                              GestureDetector(
                                onTap: widget.showRegisterPage,
                                child: Text(" Register Now",
                                  style: TextStyle(fontSize: 15,
                                      color: Colors.deepPurpleAccent),
                                ),
                              ),
                            ],
                          )
                        ],
                      ))

                ],
              ),
            ),
          )),
    );
  }
}
