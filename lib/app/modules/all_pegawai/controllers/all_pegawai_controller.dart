import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AllPegawaiController extends GetxController {
 FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  DateTime end = DateTime.now();
  Future<QuerySnapshot<Map<String, dynamic>>> getPresence() async {

      return await firestore
          .collection("pegawai")
          .get();
  

  }
}
