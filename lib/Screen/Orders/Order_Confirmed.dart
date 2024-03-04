// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fuel/Screen/User/homepage.dart';


class SucessfullOrder extends StatefulWidget {
  const SucessfullOrder({Key? key}) : super(key: key);


  @override
  State<SucessfullOrder> createState() => _SucessfullOrderState();
}

Color themeColor = const Color(0xFF43D19E);

class _SucessfullOrderState extends State<SucessfullOrder> {
  double screenWidth = 600;
  double screenHeight = 400;
  Color textColor = const Color(0xFF32567A);

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 170,
              padding: EdgeInsets.all(35),
              decoration: BoxDecoration(
                color: themeColor,
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                "assets/card.png",
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: screenHeight * 0.1),
            Text(
              "Thank You!",
              style: TextStyle(
                color: themeColor,
                fontWeight: FontWeight.w600,
                fontSize: 36,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            Text(
              "Order Placed Successfully",
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w400,
                fontSize: 17,
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            TextButton(

              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder:  (context) => const HomePage(),));
              },
              child :  Text("Click here to return to home page", style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),),
              
            ),
            SizedBox(height: screenHeight * 0.06),
            // Flexible(
            //   child: HomePage()
            // ),
          ],
        ),
      ),
    );
  }
}