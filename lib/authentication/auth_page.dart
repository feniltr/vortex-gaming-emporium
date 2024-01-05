import 'login_page.dart';
import 'regestration_page.dart';
import 'package:flutter/material.dart';

class Auth_page extends StatefulWidget {
  Auth_page({Key? key}) : super(key: key);

  @override
  State<Auth_page> createState() => _Auth_pageState();
}

class _Auth_pageState extends State<Auth_page> {
  bool showloginpage = true;

  void togglescreen(){
    setState(() {
      showloginpage = !showloginpage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(showloginpage){
      return Login_page(showRegisterPage: togglescreen);
    }
    else{
      return Register_page(showLoginPage: togglescreen);
    }


  }
}
