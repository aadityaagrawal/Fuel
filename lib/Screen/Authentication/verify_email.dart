import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fuel/Repository/Firebase_auth.dart';
import 'package:fuel/Screen/User/homepage.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {

  @override
  void initState() {
    super.initState();
    setTimerForAutoRedirect();
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer to avoid memory leaks
    super.dispose();
  }

  late Timer _timer;

  void setTimerForAutoRedirect(){
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      FirebaseAuth.instance.currentUser?.reload();
      final user = FirebaseAuth.instance.currentUser;
      if(user!.emailVerified)
      {
        _timer.cancel();
        Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );

      }

    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: [
              Image.asset(
                "assets/email_verify.jpg",
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.contain,
              ),
              const Text(
                "Verify you email address",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 12,
              ),
              const Text(
                "We have just shared a link to your registered email id click on the link to verify your email address",
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 12,
              ),

              const Spacer(),
              const Text(
                "If your didn't received any mail click the below button",
                style: TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 9,),
              ElevatedButton(
                  onPressed: () {
                  
                      AuthService().sendEmailVerification()
                      .then((value) => const ScaffoldMessenger(child: SnackBar(content: Text("Link send successfully"), backgroundColor: Colors.green,)))
                      .onError((error, stackTrace) => ScaffoldMessenger( child: SnackBar(content: Text("Error occured : ${error.toString()}"), backgroundColor: Colors.red,), ), )
                      ;
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0XFFFF725E),
                    padding: const EdgeInsets.all(12),
                    minimumSize: Size(MediaQuery.of(context).size.width * 0.5, 16)
                  ),
                  child: const Text(
                    "Resend mail",
                    style: TextStyle(color: Colors.white),
                  ))
            ]),
          ),
        ),
      
    );
  }
}
