import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fuel/Repository/Firebase_auth.dart';
import 'package:fuel/Repository/user_data.dart';
import 'package:fuel/Screen/Authentication/Login_Screen.dart';
import 'package:fuel/Screen/Authentication/verify_email.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController buildingNameController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController propertyTypeController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool agreeToTerms = true;
  String defaultPropertyType = 'Residential';
  UserData userData = UserData();
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Registration'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: firstNameController,
                  decoration: const InputDecoration(labelText: 'First Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: lastNameController,
                  decoration: const InputDecoration(labelText: 'Last Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your last name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    // You can add more email validation logic if needed
                    return null;
                  },
                ),
                TextFormField(
                  controller: buildingNameController,
                  decoration: const InputDecoration(labelText: 'Building Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your building name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: streetController,
                  decoration: const InputDecoration(labelText: 'Street'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your street';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  value: defaultPropertyType,
                  items: ['Residential', 'Commercial'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    propertyTypeController.text = value!;
                  },
                  decoration:
                      const InputDecoration(labelText: 'Type of Property'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select the type of property';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: stateController,
                  decoration: const InputDecoration(labelText: 'State'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your state';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: cityController,
                  decoration: const InputDecoration(labelText: 'City'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your city';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: pincodeController,
                  decoration: const InputDecoration(labelText: 'Pincode'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your pincode';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: phoneNumberController,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    // You can add more phone number validation logic if needed
                    return null;
                  },
                ),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration:
                      const InputDecoration(labelText: 'Confirm Password'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    } else if (value != passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                CheckboxListTile(
                  contentPadding: const EdgeInsets.all(0),
                  title: const Text('I agree to the terms and conditions'),
                  value: agreeToTerms,
                  activeColor: const Color(0xFF4F6F52),
                  onChanged: (bool? value) {
                    setState(() {
                      agreeToTerms = value!;
                    });
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      backgroundColor: const Color(0xFF4F6F52),
                      minimumSize: Size(
                        MediaQuery.sizeOf(context).width,
                        40,
                      )),
                  onPressed: () async {
                    if (!agreeToTerms) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Agree to our terms")));
                    }
                    if (_formKey.currentState?.validate() == true &&
                        agreeToTerms) {
                      try {
                        User? user = (await auth.createUserWithEmailAndPassword(
                          email: emailController.text,
                          password: passwordController.text,
                        ))
                            .user;

                        if (user != null) {
                          if (!auth.currentUser!.emailVerified) {
                            await auth.currentUser!.sendEmailVerification();
                          }

                          await userData.addUser(
                            context,
                            auth.currentUser!.uid,
                            firstNameController.text,
                            lastNameController.text,
                            phoneNumberController.text,
                            {
                              'building': buildingNameController.text,
                              'street': streetController.text,
                              'type': propertyTypeController.text,
                              'state': stateController.text,
                              'city': cityController.text,
                              'pincode': pincodeController.text,
                            },
                          );

                        Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => VerifyEmail()),
                    );
                        }
                      } catch (error) {
                        if (error is FirebaseAuthException) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(error.message!),
                              backgroundColor:
                                  Theme.of(context).colorScheme.error,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error adding user: $error'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      }
                    }
                  },
                  child: const Text(
                    'Generate OTP and Register',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    // Navigate to login page
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    );
                  },
                  child: const Text(
                    'Already a user? Login here',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
