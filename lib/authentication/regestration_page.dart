import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vortex_gaming_emporium/components/loading.dart';

class Register_page extends StatefulWidget {
  final VoidCallback showLoginPage;

  const Register_page({Key? key,required this.showLoginPage}) : super(key: key);

  @override
  State<Register_page> createState() => _Register_pageState();
}

class _Register_pageState extends State<Register_page> {
  bool _isChecked = false;
  String gp = "";
  bool visibility = true;
  bool confirm_visibility = true;
  final formkey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();
  final _firstName = TextEditingController();

  //Focus Nodes
  FocusNode nd_firstname = FocusNode();
  FocusNode nd_email = FocusNode();
  FocusNode nd_password = FocusNode();
  FocusNode nd_confirmpassword = FocusNode();
  UserCredential? userCredential;

  Future signUp() async{
    if (confirmpass()) {
      // Authenticate User
      showDialog(
          context: context,
          builder: (context) {
            return Center(child: Loading());
          });

      userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email.text.trim(),
        password: _password.text.trim(),
      );

      Navigator.pop(context);

      //add user data
      GetData(_firstName.text.trim(), _email.text.trim(),gp);
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text("Passwords Are Not Same"),
            );
          });
    }
  }

  Future GetData(String firstName, String email,String gp) async {
    await FirebaseFirestore.instance.collection('Users').add({
      'username' : firstName,
      'email' : email,
      'gender' : gp,
    });
    print("First Name :"+firstName);
    print("Email :"+email);
    print("gp :"+gp);
  }

  bool confirmpass() {
    if (_password.text.trim() == _confirmPassword.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  void _hadleradio(String value) {
    gp = value.toString();
    print(gp);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Space
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Hello There",
                    style: GoogleFonts.bebasNeue(fontSize: 60),
                  ),

                  Text(
                    "Register Your Detailes Below",
                    style: TextStyle(fontSize: 20),
                  ),

                  //space
                  SizedBox(
                    height: 20,
                  ),

                  //Form
                  Form(
                      key: formkey,
                      child: Column(
                        children: [
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 20.0),
                            child: TextFormField(
                              focusNode: nd_firstname,
                              onFieldSubmitted: (value) {
                                FocusScope.of(context).requestFocus(nd_email);
                              },
                              controller: _firstName,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "username is required";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Colors.deepPurpleAccent,
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 4)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                    borderSide: BorderSide(
                                        color: Colors.deepPurpleAccent,
                                        width: 4)),
                                hintText: "Username",
                              ),
                            ),
                          ),

                          SizedBox(
                            height: 10,
                          ),

                          //Email Input
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 20.0),
                            child: TextFormField(
                              focusNode: nd_email,
                              onFieldSubmitted: (vale) {
                                FocusScope.of(context).requestFocus(nd_password);
                              },
                              controller: _email,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Email is required";
                                } else if (!value.contains('@') ||
                                    !value.contains(".com")) {
                                  return "Enter valid email";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 4)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                    borderSide: BorderSide(
                                        color: Colors.deepPurpleAccent,
                                        width: 4)),
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: Colors.deepPurpleAccent,
                                ),
                                hintText: "Email",
                              ),
                            ),
                          ),

                          SizedBox(
                            height: 10,
                          ),

                          SizedBox(
                            height: 10,
                          ),

                          //Password Input
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 20.0),
                            child: TextFormField(
                              focusNode: nd_password,
                              onFieldSubmitted: (vale) {
                                FocusScope.of(context)
                                    .requestFocus(nd_confirmpassword);
                              },
                              controller: _password,
                              obscureText: visibility,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Password is required";
                                } else if (value.length < 6) {
                                  return "6 Digit password required";
                                }
                              },
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 4)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                    borderSide: BorderSide(
                                        color: Colors.deepPurpleAccent,
                                        width: 4)),
                                prefixIcon: Icon(
                                  Icons.password,
                                  color: Colors.deepPurpleAccent,
                                ),
                                hintText: "Password",
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      visibility = !visibility;
                                      setState(() {});
                                    },
                                    icon: visibility
                                        ? Icon(
                                      Icons.visibility,
                                      color: Colors.deepPurpleAccent,
                                    )
                                        : Icon(
                                      Icons.visibility_off,
                                      color: Colors.deepPurpleAccent,
                                    )),
                              ),
                            ),
                          ),

                          SizedBox(
                            height: 10,
                          ),

                          //Confirm Password Input
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 20.0),
                            child: TextFormField(
                              focusNode: nd_confirmpassword,
                              controller: _confirmPassword,
                              obscureText: confirm_visibility,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Confirm Password is required";
                                } else if (value.length < 6) {
                                  return "6 Digit password required";
                                }
                              },
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 4)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                    borderSide: BorderSide(
                                        color: Colors.deepPurpleAccent,
                                        width: 4)),
                                prefixIcon: Icon(
                                  Icons.password,
                                  color: Colors.deepPurpleAccent,
                                ),
                                hintText: "Confirm Password",
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      confirm_visibility = !confirm_visibility;
                                      setState(() {});
                                    },
                                    icon: confirm_visibility
                                        ? Icon(
                                      Icons.visibility,
                                      color: Colors.deepPurpleAccent,
                                    )
                                        : Icon(
                                      Icons.visibility_off,
                                      color: Colors.deepPurpleAccent,
                                    )),
                              ),
                            ),
                          ),

                          //Space
                          SizedBox(
                            height: 10,
                          ),

                          //gender
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: GestureDetector(
                                    onTap: () => _hadleradio('male'),
                                    child: Container(
                                      padding: EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                          border: Border.all(
                                              color: ((gp == 'male')
                                                  ? Colors.deepPurpleAccent
                                                  : Colors.white),
                                              width: 4)),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Radio(
                                              value: "male",
                                              activeColor:
                                              Colors.deepPurpleAccent,
                                              groupValue: gp,
                                              onChanged: (value) {
                                                gp = value.toString();
                                                setState(() {});
                                              }),
                                          Text(
                                            "Male",
                                            style: GoogleFonts.roboto(
                                                fontSize: 17),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  flex: 2,
                                  child: GestureDetector(
                                    onTap: () => _hadleradio('female'),
                                    child: Container(
                                      padding: EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                          border: Border.all(
                                              color: ((gp == 'female')
                                                  ? Colors.deepPurpleAccent
                                                  : Colors.white),
                                              width: 4)),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Radio(
                                              value: "female",
                                              activeColor:
                                              Colors.deepPurpleAccent,
                                              groupValue: gp,
                                              onChanged: (value) {
                                                gp = value.toString();
                                                setState(() {});
                                              }),
                                          Text(
                                            "Female",
                                            style: GoogleFonts.roboto(
                                                fontSize: 17),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(
                            height: 10,
                          ),

                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                                  border: Border.all(
                                      color: _isChecked
                                          ? Colors.deepPurpleAccent
                                          : Colors.white,
                                      width: 4)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Transform.scale(
                                    scale: 1.2,
                                    child: Checkbox(
                                        value: _isChecked,
                                        activeColor: Colors.deepPurpleAccent,
                                        onChanged: (value) {
                                          _isChecked = !_isChecked;
                                          setState(
                                                () {},
                                          );
                                        }),
                                  ),
                                  Text(
                                    "I accept Terms & conditions",
                                    style: TextStyle(fontSize: 17),
                                  )
                                ],
                              ),
                            ),
                          ),

                          SizedBox(
                            height: 10,
                          ),
                          //Sign up Button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text("Sign Up",
                                  style: GoogleFonts.roboto(fontSize: 30)),
                              GestureDetector(
                                  onTap: () {
                                    if (formkey.currentState!.validate() &&
                                        !gp.isEmpty &&
                                        _isChecked) {
                                      signUp();
                                    }
                                    if (gp.isEmpty && !_isChecked) {
                                      Fluttertoast.showToast(
                                          msg: "Select Your Gender And Accept Terms & Conditions",
                                          toastLength: Toast.LENGTH_SHORT,
                                          fontSize: 15);
                                    } else if (gp.isEmpty) {
                                      Fluttertoast.showToast(
                                          msg: "Select Your Gender",
                                          toastLength: Toast.LENGTH_SHORT,
                                          fontSize: 15);
                                    } else if (!_isChecked) {
                                      Fluttertoast.showToast(
                                          msg: "Accept Terms & Conditions",
                                          toastLength: Toast.LENGTH_SHORT,
                                          fontSize: 15);
                                    }
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: Colors.deepPurpleAccent,
                                    maxRadius: 30,
                                    child: Icon(
                                      Icons.keyboard_arrow_right,
                                      size: 50,
                                      color: Colors.white,
                                    ),
                                  )),
                            ],
                          ),

                          //Space
                          SizedBox(
                            height: 20,
                          ),

                          //New Member Regiseter Text
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Im a member ?",
                                style: TextStyle(fontSize: 15),
                              ),
                              GestureDetector(
                                onTap: widget.showLoginPage,
                                child: Text(
                                  " Login Now",
                                  style: TextStyle(
                                      fontSize: 15,
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
          ),
        ));
  }
}
