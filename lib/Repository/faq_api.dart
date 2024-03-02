import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fuel/Models/FAQ_Model.dart';


class FAQAPI{

  Future<List<FAQMODEL>> getAllFAQs() async {
  QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await FirebaseFirestore.instance.collection('faqs').get();

  return querySnapshot.docs.map((doc) => FAQMODEL.fromJson(doc.data())).toList();
}

}