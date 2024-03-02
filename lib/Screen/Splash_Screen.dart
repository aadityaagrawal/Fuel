import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fuel/Repository/Firebase_auth.dart';
import 'package:fuel/Screen/Login_Screen.dart';
import 'package:fuel/Screen/homepage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  AuthService _auth = AuthService();

  timer() {
    Timer(const Duration(seconds: 3), () async{
      if(_auth.getCurrentUser() != null)
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> const HomePage()));
      else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> const LoginScreen()));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    timer();
  }
  @override
  Widget build(BuildContext context) {


    return Material(
      child: Container(
        color: const Color(0xFF4F6F52),
        child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("FuelZapp", style: TextStyle(fontSize: 64, fontWeight: FontWeight.bold, color: Color(0XFFECE3CE),)),
              SizedBox(height: 8,),
              Text("Anywhere door of fuel"  , style: TextStyle(fontSize: 32, fontWeight: FontWeight.w400,  color: Color(0XFFECE3CE)),)
            ],
          ),
        ),
    );
  }
}