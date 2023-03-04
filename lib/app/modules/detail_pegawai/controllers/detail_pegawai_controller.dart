import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class DetailPegawaiController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  DateTime? start;
  DateTime end = DateTime.now();
  Future<QuerySnapshot<Map<String, dynamic>>> getPresence(id) async {
    String uid = id;

    if (start == null) {
      return await firestore
          .collection("pegawai")
          .doc(uid)
          .collection("presence")
          .where('date', isLessThan: end.toIso8601String())
          .orderBy('date', descending: true)
          .get();
    }else{
      return await firestore
          .collection("pegawai")
          .doc(uid)
          .collection("presence")
          .where('date', isGreaterThan: start!.toIso8601String())
          .where('date', isLessThan: end.add(Duration(days: 1)).toIso8601String())
          .orderBy('date', descending: true)
          .get();

    }

  }
  void picDate(DateTime picStart, DateTime picEnd){
    start = picStart; 
    end = picEnd; 
    update();
    Get.back();
  }
}
