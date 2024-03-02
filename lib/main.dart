import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fuel/Screen/Booking_Screen.dart';
import 'package:fuel/Screen/Splash_Screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: "AIzaSyBs5tbqzbqVlx3W_iGZWvrI049CIhzwkro",
              appId: "1:261042307752:android:0fee959fa3d9339843b89d",
              messagingSenderId: "261042307752",
              projectId: "srmproj"))
      : await Firebase.initializeApp();

  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen (),
    );
  }
}
