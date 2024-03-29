import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fuel/Models/Booking_Model.dart';
import 'package:fuel/Repository/order_data.dart';
import 'package:fuel/Screen/Orders/Order_Confirmed.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ReviewScreen extends StatefulWidget {
  final LatLng deliveryCordinates;
  final String type, quantity, time;
  final DateTime date;
  final int price;
  final int deliveryPrice;

  const ReviewScreen({
    Key? key,
    required this.type,
    required this.quantity,
    required this.date,
    required this.time,
    required this.price,
    required this.deliveryCordinates,
    required this.deliveryPrice,
  }) : super(key: key);

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  OrderService orderService = OrderService();

  late Razorpay razorpay;

  void openCheckOut(int amount) async {
    amount = amount * 100;
    Map<String, dynamic> options = {
      'key': dotenv.env['KEY'],
      'amount': amount.toInt(),
      'name': dotenv.env['NAME'],
      'description': dotenv.env['DESCRIPTION'],
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {
        'contact': dotenv.env['CONTACT'],
        'email': dotenv.env['EMAIL']
      },
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      razorpay.open(options);
    } catch (e) {
      debugPrint('Error : $e');
    }
  }

  void handlePayementSuccess(PaymentSuccessResponse response) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const SucessfullOrder(),
      ),
    );
  }

  void handlePayementError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "Payement Failed ${response.message!}",
        toastLength: Toast.LENGTH_SHORT);
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "External wallet ${response.walletName!}",
        toastLength: Toast.LENGTH_SHORT);
  }

  @override
  void dispose() {
    super.dispose();
    razorpay.clear();
  }

  @override
  void initState() {
    super.initState();
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePayementSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePayementError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  }

  TextStyle customStyle = const TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  TextStyle headingCustomStyle = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Review Order"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.all(24),
        child: Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildInfoColumn("Type of fuel", widget.type),
                    const SizedBox(height: 124),
                    _buildInfoColumn("Quantity", widget.quantity),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: _buildInfoColumn(
                        "Date",
                        DateFormat('dd-MM-yy').format(widget.date),
                      ),
                    ),
                    Expanded(child: _buildInfoColumn("Time", widget.time)),
                  ],
                ),
                const SizedBox(height: 24),
                _buildDivider(),
                const SizedBox(height: 8),
                _buildPriceRow(
                    "Fuel price", widget.quantity, widget.price.toDouble()),
                _buildPriceRow(
                    "Std. Delivery Fee", null, widget.deliveryPrice.toDouble()),
                _buildPriceRow(
                    "Gst on Delivery Fee", null, widget.deliveryPrice * 0.18),
                const SizedBox(height: 4),
                _buildDivider(),
                const SizedBox(height: 8),
                _buildTotalRow(),
                const Spacer(),
                _buildConfirmButton(1.18 * widget.deliveryPrice +
                    int.parse(widget.quantity) * widget.price),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String heading, String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          heading,
          style: headingCustomStyle,
        ),
        Text(
          value,
          style: customStyle,
        )
      ],
    );
  }

  Widget _buildDivider() {
    return const Divider(
      color: Colors.black,
      height: 25,
      thickness: 1,
      indent: 5,
      endIndent: 5,
    );
  }

  Widget _buildPriceRow(String heading, String? quantity, double price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          heading,
          style: headingCustomStyle,
        ),
        Text(
          quantity != null
              ? "₹ ${(int.parse(quantity) * price).toDouble()}"
              : "₹ ${price.toDouble()}",
          style: headingCustomStyle,
        )
      ],
    );
  }

  Widget _buildTotalRow() {
    double total =
        1.18 * widget.deliveryPrice + int.parse(widget.quantity) * widget.price;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Total",
          style: headingCustomStyle,
        ),
        Text(
          "₹ $total",
          style: headingCustomStyle.copyWith(
              fontSize: 28, fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  Widget _buildConfirmButton(double amount) {
    return ElevatedButton(
      onPressed: () {
        orderService
            .addOrderToUser(
                BookingModel(
                    deliveryCoordinates: widget.deliveryCordinates,
                    type: widget.type,
                    quantity: widget.quantity,
                    time: widget.time,
                    date: widget.date,
                    price: widget.price,
                    deliveryPrice: widget.deliveryPrice),
                context)
            .then((result) {
          openCheckOut(amount.toInt());
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.toString())),
          );
        });
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: const Color(0xFF4F6F52),
        minimumSize: const Size(
          double.infinity,
          40,
        ),
      ),
      child: const Text(
        "Confirm",
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}
