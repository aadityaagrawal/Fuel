import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fuel/Screen/Orders/Review_Screen.dart';
import 'package:fuel/Widgets/drawer_widget.dart';
import 'package:fuel/Widgets/price_display.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class OrderScreen extends StatefulWidget {
  final LatLng? location;

  const OrderScreen({Key? key, this.location}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  int? petrolPrice;
  int? dieselPrice;
  int? deliveryCharge ;
  int? petrolOrigioanl;
  int? dieselOrigional;
  String selectedFuel = 'Petrol';
  TextEditingController quantityController = TextEditingController();
  DateTime selectedDate = DateTime.now();



  final CollectionReference ordersCollection =
      FirebaseFirestore.instance.collection('prices');

Future<void> fetchPrices() async {
  try {

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('prices').get();
    querySnapshot.docs.forEach((doc) {
      deliveryCharge = doc['delivery_charge'];
      dieselPrice = doc['diesel_price'];
      petrolPrice = doc['petrol_price'];
      petrolOrigioanl = doc['petrol_origional'];
      dieselOrigional = doc['diesel_origional'];


      print(dieselOrigional.toString()  + petrolOrigioanl.toString());
    });
  } catch (e) {
    print(e.toString());
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
        title: const Text("FuelZapp"),
      ),
      body: FutureBuilder(
        future: fetchPrices(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(),);
          }
          else if(snapshot.hasError) {
              return  Center(child: Text(snapshot.hasError.toString()),);
          }
          else {
          return Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    PriceDisplay(
                        type: "Petrol",
                        netprice: petrolPrice.toString(),
                        price: petrolOrigioanl.toString()),
                    PriceDisplay(
                        type: "Diesel",
                        netprice: dieselPrice.toString(),
                        price: dieselOrigional.toString()),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                buildFuelTypeRow(),
                const SizedBox(
                  height: 16,
                ),
                buildQuantityAndDateRow(),
                const Spacer(),
                ElevatedButton(
                  onPressed: () => submitOrder(context,
                      selectedFuel == 'Petrol' ? petrolPrice : dieselPrice),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: const Color(0xFF4F6F52),
                    minimumSize: Size(
                      MediaQuery.sizeOf(context).width,
                      40,
                    ),
                  ),
                  child: const Text(
                    "Submit",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          );
          }
        }
      ),
    );
  }

  Widget buildFuelTypeRow() {
    return Row(
      children: [
        Expanded(
          child: RadioListTile<String>(
            title: const Text('Petrol'),
            value: 'Petrol',
            groupValue: selectedFuel,
            onChanged: (value) {
              setState(() {
                selectedFuel = value!;
              });
            },
            activeColor: const Color(0xFF4F6F52),
          ),
        ),
        Expanded(
          child: RadioListTile<String>(
            activeColor: const Color(0xFF4F6F52),
            title: const Text('Diesel'),
            value: 'Diesel',
            groupValue: selectedFuel,
            onChanged: (value) {
              setState(() {
                selectedFuel = value!;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget buildQuantityAndDateRow() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: quantityController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Quantity',
              hintText: 'Enter quantity',
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: InkWell(
            onTap: () => _selectDateAndTime(context),
            child: InputDecorator(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Date and Time',
                hintText: 'Select date and time',
              ),
              child: Text(
                '${DateFormat('dd-MM-yyyy').format(selectedDate)} ${selectedTime.format(context)}',
              ),
            ),
          ),
        ),
      ],
    );
  }

TimeOfDay selectedTime = TimeOfDay.now();

  Future<void> _selectDateAndTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: selectedTime,
      );

      if (pickedTime != null) {
        setState(() {
          selectedDate = pickedDate;
          selectedTime = pickedTime;
        });
      }
    }
  }

  void submitOrder(BuildContext context, int? price) {
    if (int.tryParse(quantityController.text) != null &&
        int.parse(quantityController.text) > 0) {
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => ReviewScreen(
            type: selectedFuel,
            quantity: quantityController.text,
            date: selectedDate,
            time: selectedTime.format(context),
            price: price ?? 1000,
            deliveryCordinates: widget.location ?? const LatLng(0, 0),
            deliveryPrice: deliveryCharge ?? 1000,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter valid amount of fuel")),
      );
    }
  }
}
