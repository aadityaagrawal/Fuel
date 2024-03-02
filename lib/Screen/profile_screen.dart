import 'package:flutter/material.dart';
import 'package:fuel/Models/User_Model.dart';
import 'package:fuel/Repository/user_data.dart';
import 'package:fuel/Widgets/drawer_widget.dart';


class ProfileScreen extends StatelessWidget {
  final UserData userData = UserData(); // Instantiate the UserData class
  final String uid; // Pass the user ID to retrieve user data

  ProfileScreen({required this.uid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Profile'),
      ),
      body: FutureBuilder<UserModel>(
        future: userData.getUser(uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error loading profile'),
            );
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: Text('User not found'),
            );
          } else {
            UserModel user = snapshot.data!;
            return buildProfileContent(user);
          }
        },
      ),
    );
  }

  Widget buildProfileContent(UserModel user) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 50,
            // backgroundImage: , // You can replace this with the actual user's profile image
          ),
          const SizedBox(height: 20),
          Text(
            user.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            user.phoneNumber,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          buildAddressWidget(user.address),
        ],
      ),
    );
  }

  Widget buildAddressWidget(Address address) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Address:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text('Building: ${address.buildingName}'),
        Text('Street: ${address.street}'),
        Text('Type: ${address.type}'),
        Text('State: ${address.state}'),
        Text('City: ${address.city}'),
        Text('Pincode: ${address.pincode}'),
      ],
    );
  }
}
