import 'package:flutter/material.dart';
import 'package:fuel/Repository/Firebase_auth.dart';
import 'package:fuel/Screen/Support/Complaint_Screen.dart';
import 'package:fuel/Screen/Support/Contact_us.dart';
import 'package:fuel/Screen/Authentication/Login_Screen.dart';
import 'package:fuel/Screen/Support/faq_screen.dart';
import 'package:fuel/Screen/User/homepage.dart';
import 'package:fuel/Screen/User/profile_screen.dart';

class DrawerWidget extends StatelessWidget {
  DrawerWidget({
    super.key,
  });

  AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width / 2,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: [
            ListTile(
              title: const Text('Profile '),
              onTap: () {
                Navigator.pushReplacement<void, void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => ProfileScreen(uid: _auth.getCurrentUser()!.uid,),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('New Order'),
              onTap: () {
                Navigator.pushReplacement<void, void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const HomePage(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('My Addresses'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Contact Us'),
              onTap: () {
                Navigator.pushReplacement<void, void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const ContactUsPage(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Complaint'),
              onTap: () {
                Navigator.pushReplacement<void, void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        const CustomerComplaintPage(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('FAQs'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const FAQ(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('LogOut'),
              onTap: () {
                _auth.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (Route<dynamic> route) =>
                      false, // This prevents user from going back
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
