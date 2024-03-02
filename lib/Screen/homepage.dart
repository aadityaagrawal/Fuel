import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fuel/Repository/Firebase_auth.dart';
import 'package:fuel/Screen/Booking_Screen.dart';
import 'package:fuel/Screen/Map_Screen.dart';
import 'package:fuel/Widgets/drawer_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  AuthService auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "FuelZapp",
          style: TextStyle(letterSpacing: 1.5, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          const MapScreen(),
          Container(
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 16),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement<void, void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const OrderScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  backgroundColor: const Color(0xFF4F6F52),
                  minimumSize: Size(
                    MediaQuery.sizeOf(context).width,
                    40,
                  )),
              child: const Text(
                "Order Now",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
      drawer: DrawerWidget(),
    );
  }
}


