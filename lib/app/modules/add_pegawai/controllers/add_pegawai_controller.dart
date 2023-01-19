import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
//  import 'Dart:html';
class AddPegawaiController extends GetxController {
TextEditingController nipC = TextEditingController();
TextEditingController namaC = TextEditingController();
TextEditingController emailC = TextEditingController();
FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;

void tambahPegawai() async{
  if(nipC.text.isNotEmpty && namaC.text.isNotEmpty && emailC.text.isNotEmpty){

    // menyimpan ke email firebaseauth
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: emailC.text,
        password: "12345678"
      );
      if(userCredential.user != null){
        String uid = userCredential.user!.uid;

        await firestore.collection('pegawai').doc(uid).set({
          "nip": nipC.text,
          "nama": namaC.text,
          "email": emailC.text,
          "uid": uid,
          "createdAd": DateTime.now().toIso8601String(),
        });
       await userCredential.user!.sendEmailVerification();
        // window.console.info(userCredential);
        print(userCredential);
      }
      
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Get.snackbar('Terjadi kesalahan', 'Password terlalu mudah!');
      } else if (e.code == 'email-already-in-use') {
        Get.snackbar('Terjadi kesalahan', 'Email sudah terdaftar!');
      }
    } catch (e) {
        Get.snackbar('Terjadi kesalahan', 'Periksa koneksi anda!');
    }
    
  }else{
    Get.snackbar('Terjadi kesalahan', 'Form tidak boleh kosong');

  }
}
}
