import 'package:flutter/material.dart';
import 'package:fuel/Screen/Review_Screen.dart';
import 'package:fuel/Widgets/drawer_widget.dart';
import 'package:intl/intl.dart';

class PriceDisplay extends StatelessWidget {
  const PriceDisplay({
    Key? key,
    required this.type,
    required this.netprice,
    required this.price,
  }) : super(key: key);

  final String type;
  final String netprice;
  final String price;


  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: const Color(0XFFECE3CE),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  const Icon(Icons.local_gas_station_outlined, size: 40,),
                  const SizedBox(height: 5,),
                  Text(type, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                ],
              ),
            ),
            const SizedBox(height: 8,),
            const Text("Today", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
            Text("₹ $netprice", style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 20),),
            Text("₹ $price", style: const TextStyle(decoration: TextDecoration.lineThrough, fontWeight: FontWeight.w500, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  int petrolPrice = 100;
  int dieselPrice = 200;
  String selectedFuel = 'Petrol';
  TextEditingController quantityController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer:  DrawerWidget(),
      appBar: AppBar(
        title: const Text("FuelZapp"),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
             Row(
              children: [
                PriceDisplay(type: "Petrol", netprice: petrolPrice.toString(), price: "120"),
                PriceDisplay(type: "Diesel", netprice: dieselPrice.toString(), price: "100"),
              ],
            ),
            const SizedBox(height: 16,),
            buildFuelTypeRow(),
            const SizedBox(height: 16,),
            buildQuantityAndDateRow(),
            const Spacer(),
            ElevatedButton(
              onPressed: () => submitOrder(context, selectedFuel == 'Petrol' ? petrolPrice : dieselPrice),
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
            onTap: () => _selectDate(context),
            child: InputDecorator(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Date',
                hintText: 'Select date',
              ),
              child: Text(
                DateFormat('dd-MM-yyyy').format(selectedDate),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void submitOrder(BuildContext context, int price) {

  //   if (selectedFuel == 'Petrol') {
  //   netPrice = "100";
  //   price = "120";
  // } else {
  //   netPrice = "80";
  //   price = "100";
  // }


    if (int.tryParse(quantityController.text) != null && int.parse(quantityController.text) > 0) {
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => ReviewScreen(type: selectedFuel, quantity: quantityController.text, date: selectedDate, time: "16:00", price: price ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter valid amount of fuel")),
      );
    }
  }
}
