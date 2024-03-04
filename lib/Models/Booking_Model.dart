import 'package:google_maps_flutter/google_maps_flutter.dart';

class BookingModel {
  
  final LatLng deliveryCoordinates;
  final String type;
  final String quantity;
  final String time;
  final DateTime date;
  final int price;
  final int deliveryPrice;
  int totalPrice;

  BookingModel({
    required this.deliveryCoordinates,
    required this.type,
    required this.quantity,
    required this.time,
    required this.date,
    required this.price,
    required this.deliveryPrice,
  }) : totalPrice = (price * int.parse(quantity) + 1.18 * deliveryPrice).toInt();

  Map<String, dynamic> toJson() {
    return {
      'deliveryCoordinates': {
        'latitude': deliveryCoordinates.latitude,
        'longitude': deliveryCoordinates.longitude,
      },
      'type': type,
      'quantity': quantity,
      'time': time,
      'date': date.toIso8601String(),
      'price': price,
      'deliveryPrice': deliveryPrice,
      'totalPrice': totalPrice,
    };
  }

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      deliveryCoordinates: LatLng(
        json['deliveryCoordinates']['latitude'],
        json['deliveryCoordinates']['longitude'],
      ),
      type: json['type'],
      quantity: json['quantity'],
      time: json['time'],
      date: DateTime.parse(json['date']),
      price: json['price'],
      deliveryPrice: json['deliveryPrice'],
    );
  }
}
