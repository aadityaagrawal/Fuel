import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:fuel/Models/User_Model.dart";

class UserData {
  Future<UserModel> getUser(String uid) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      DocumentReference userRef = firestore.collection('users').doc(uid);
      DocumentSnapshot userSnapshot = await userRef.get();

      if (userSnapshot.exists) {
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;
        return UserModel.fromJson(userData);
      } else {
        return UserModel("null", "null", Address("null", "null", "null", "null", "null", "null"));
      }
    } catch (error) {
      // Handle the error appropriately, e.g., log or throw it
     return UserModel("null", "null", Address("null", "null", "null", "null", "null", "null"));
    }
  }

  Future<void> addUser(BuildContext context, String uid, String name, String phoneNumber, Map<String, dynamic> address) async {
  try {

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference userRef = firestore.collection('users').doc(uid);
    Map<String, dynamic> userData = {
      'name': name,
      'phone_number': phoneNumber,
      'address': address,
    };
    await userRef.set(userData);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("User successfully added")));
    
  } catch (error) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
  }
}

}
