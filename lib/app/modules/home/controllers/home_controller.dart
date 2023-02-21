import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
  void increment() => count.value++;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUser() async* {
    String uid = auth.currentUser!.uid;

    yield* firestore.collection('pegawai').doc(uid).snapshots();

  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamLastPresence() async* {
    String uid = auth.currentUser!.uid;

    yield* firestore.collection('pegawai').doc(uid).collection("presence").orderBy("date", descending: true).limitToLast(5).snapshots();

  }
  Stream<DocumentSnapshot<Map<String, dynamic>>> streamToDayPresence() async* {
    String uid = auth.currentUser!.uid;
    String id = DateFormat.yMd().format(DateTime.now()).replaceAll("/", "-");
    yield* firestore.collection('pegawai').doc(uid).collection("presence").doc(id).snapshots();

  }



}
