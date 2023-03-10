import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  streamUsder() async {
  return streamUser();

  }
  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUser() async* {
   
    String uid = auth.currentUser!.uid;
    yield* firestore.collection('pegawai').doc(uid).snapshots();

  }

}
