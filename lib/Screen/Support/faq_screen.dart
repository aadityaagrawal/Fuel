import 'package:flutter/material.dart';
import 'package:fuel/Models/FAQ_Model.dart';
import 'package:fuel/Repository/faq_api.dart';
import 'package:fuel/Widgets/drawer_widget.dart';

class FAQ extends StatefulWidget {
  const FAQ({super.key});

  @override
  State<FAQ> createState() => _FAQState();
}

class _FAQState extends State<FAQ> {
  List<FAQMODEL> faqs = [];

  Future<void> getfaqlist() async {
    faqs = await FAQAPI().getAllFAQs();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getfaqlist(),
      builder: (context, dataSnapshot) {
        if (dataSnapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: const Text("FuelZapp"), centerTitle: true,),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (dataSnapshot.hasError) {
          return const Center(
            child: Text("Error occured. Please try again latter"),
          );
        } else {
          return Scaffold(
            appBar: AppBar(title: const Text("FuelZapp"), centerTitle: true,),
            drawer:  DrawerWidget(),
            body: ListView.builder(
                itemCount: faqs.length,
                itemBuilder: (context, int index) {
                  return Card(
                    elevation: 5,
                    color: Colors.white,
                  margin: const EdgeInsets.all(8),
                    child: ExpansionTile(
                      title: Text(faqs[index].question),
                      children: <Widget>[
                        ListTile(
                          title: Text(faqs[index].answer),
                        )
                      ],
                    ),
                  );
                }),
          );
        }
      },
    );
  }
}
