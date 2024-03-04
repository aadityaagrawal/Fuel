import 'package:flutter/material.dart';

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