import 'package:flutter/material.dart';
import 'package:fuel/Widgets/drawer_widget.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({Key? key});

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
      body: Container(
        padding: const EdgeInsets.all(16),
        child: const Center(
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Contact Us',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color:  Color(0xFF4F6F52),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Corporate Office',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              Text(
                'SRM Institute of Science and Technology\nPotheri, Chennai, Tamil Nadu 603203',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 20),
              ContactDetail(
                title: 'For Order Related Queries:',
                content: 'adityakuagrawal@gmail.com',
                icon: Icons.email,
              ),
              SizedBox(height: 10),
              ContactDetail(
                title: 'For Business Related Queries:',
                content: 'work.adityaagrawal@gmail.com',
                icon: Icons.email,
              ),
              SizedBox(height: 20),
              ContactDetail(
                title: 'Call us:',
                content: '+918120988344',
                icon: Icons.phone,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ContactDetail extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;

  const ContactDetail({
    required this.title,
    required this.content,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 24,
          color: const Color(0xFF4F6F52),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            Text(
              content,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
