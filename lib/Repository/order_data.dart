import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fuel/Models/Booking_Model.dart';

class OrderService {
  final CollectionReference ordersCollection =
      FirebaseFirestore.instance.collection('orders');

  Future<void> addOrderToUser(BookingModel booking, BuildContext context) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentReference orderDocRef = ordersCollection.doc(uid);
      DocumentSnapshot orderSnapshot = await orderDocRef.get();
      List<Map<String, dynamic>> currentOrders = orderSnapshot.exists
          ? List<Map<String, dynamic>>.from(orderSnapshot['orders'])
          : [];

      currentOrders.add(booking.toJson());

      await orderDocRef.set({'orders': currentOrders}, SetOptions(merge: true));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<List<Map<String, dynamic>>> fetchUserOrders(BuildContext context) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;

      DocumentReference orderDocRef = ordersCollection.doc(uid);

      DocumentSnapshot orderSnapshot = await orderDocRef.get();

      if (orderSnapshot.exists) {
        List<Map<String, dynamic>> orders =
            List<Map<String, dynamic>>.from(orderSnapshot['orders']);
        return orders;
      } else {
        return [];
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      return [];
    }
  }
}