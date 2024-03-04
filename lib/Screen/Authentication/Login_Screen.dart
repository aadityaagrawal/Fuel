import 'package:flutter/material.dart';
import 'package:fuel/Repository/Firebase_auth.dart';
import 'package:fuel/Screen/Authentication/Register_Screen.dart';
import 'package:fuel/Screen/User/homepage.dart';
import 'package:fuel/Screen/Authentication/verify_email.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _auth = AuthService();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _isValidEmail(String email) {
    // Use a regular expression to check if the email is valid
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  TextStyle customStyle = const TextStyle(color: Colors.black);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'FuelZapp',
              style: TextStyle(
                fontSize: 48.0,
                letterSpacing: 1.5,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 80.0),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                var result = await _auth.signInWithEmailAndPassword(
                  emailController.text,
                  passwordController.text,
                );
                if (result != null) {
                  if (_auth.getCurrentUser()!.emailVerified) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  } else {
                    await _auth.sendEmailVerification();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => VerifyEmail()),
                    );
                  }
                } else {
                  // Authentication failed
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Invalid email or password'),
                    ),
                  );
                }
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
                "Login",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () async {
                    if (_isValidEmail(emailController.text)) {
                      await _auth.forgotPassword(email: emailController.text);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter a valid email address'),
                        ),
                      );
                    }
                  },
                  child: Text(
                    'Forgot Password?',
                    style: customStyle,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegistrationPage()),
                    );
                  },
                  child: Text(
                    'New User?',
                    style: customStyle,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
