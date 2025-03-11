import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Lấy danh sách pizza từ Firestore
  Future<List<Map<String, dynamic>>> getPizzas() async {
    QuerySnapshot snapshot = await _db.collection("pizzas").get();

    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }
}
