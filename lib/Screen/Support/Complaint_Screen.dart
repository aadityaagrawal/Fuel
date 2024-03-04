import 'package:flutter/material.dart';
import 'package:fuel/Widgets/drawer_widget.dart';

class CustomerComplaintPage extends StatefulWidget {
  const CustomerComplaintPage({Key? key});

  @override
  State<CustomerComplaintPage> createState() => _CustomerComplaintPageState();
}

class _CustomerComplaintPageState extends State<CustomerComplaintPage> {
  String selectedComplaintType = 'Slot not available';
  TextEditingController commentController = TextEditingController();

  void _submitComplaint() {
    String comment = commentController.text.trim();

    if (comment.isEmpty) {
      // Show snackbar if comment is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your complaint in the comment section.'),
        ),
      );
      return;
    }

    // TODO: Add logic to handle the submitted complaint, e.g., send to server

    // Clear the comment field after submission
    commentController.clear();

    // Show a success message (you can customize this according to your needs)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Complaint submitted successfully!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "FuelZapp",
          style: TextStyle(letterSpacing: 1.5, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      drawer:  DrawerWidget(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Customer Complaint',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color:  Color(0xFF4F6F52),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Fill out the below form for registering any kind of complaints with your orders, invoices, delivery, etc. Don\'t forget to mention the Order ID in the comment section below.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Please specify the type of your complaint:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              isExpanded: true,
              value: selectedComplaintType,
              onChanged: (value) {
                setState(() {
                  selectedComplaintType = value!;
                });
              },
              items: [
                'Slot not available',
                'Order delay',
                'Delivery error',
                'Executive misbehavior',
                'Invoice enquiry',
                'Quality and Quantity check',
                'Payment related',
                'Others',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            const Text(
              'Comment:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: commentController,
              maxLines: 4,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your complaint here...',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitComplaint,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                primary: const Color(0xFF4F6F52),
              ),
              child: const Text(
                'Submit',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
