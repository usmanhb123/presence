import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

//  import 'Dart:html';
class AddPegawaiController extends GetxController {
  TextEditingController nipC = TextEditingController();
  TextEditingController namaC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController jobC = TextEditingController();
  TextEditingController passwordAdmin = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

Future<void> prosesAddPegawai() async {
    if (passwordAdmin.text.isNotEmpty) {
      try {
        String emailAdmin = auth.currentUser!.email!;
         UserCredential userCredentialadmin =
              await auth.signInWithEmailAndPassword(
                  email: emailAdmin, password: passwordAdmin.text);
        UserCredential pegawaiCredential =
            await auth.createUserWithEmailAndPassword(
                email: emailC.text, password: "12345678");
        if (pegawaiCredential.user != null) {
          String uid = pegawaiCredential.user!.uid;

          await firestore.collection('pegawai').doc(uid).set({
            "nip": nipC.text,
            "nama": namaC.text,
            "email": emailC.text,
            "job": jobC.text,
            "role": "pegawai",
            "uid": uid,
            "createdAd": DateTime.now().toIso8601String(),
          });
          await pegawaiCredential.user!.sendEmailVerification();
          await firestore.collection('user_vermuk').doc(emailC.text).set({
            "email": emailC.text,
            "status": 0,
            "nama": namaC.text,
            "vermuk": 0,
            "createdAd": DateTime.now().toIso8601String(),
          });
          // window.console.info(pegawaiCredential);
          // print(pegawaiCredential);
          await auth.signOut();
          UserCredential userCredentialadmin =
              await auth.signInWithEmailAndPassword(
                  email: emailAdmin, password: passwordAdmin.text);
          Get.back();
          Get.back();
          Get.snackbar("Berhasil", "Pegawai Berhasil Ditambahkan");
          // await auth.signInWithEmailAndPassword(email: email, password: password)
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Get.snackbar('Terjadi kesalahan', 'Password terlalu mudah!');
        } else if (e.code == 'email-already-in-use') {
          Get.snackbar('Terjadi kesalahan', 'Email sudah terdaftar!');
        } else if (e.code == 'wrong-password') {
          Get.snackbar(
              'Terjadi kesalahan', 'Admin tidak dapat login, password salah!');
        } else {
          Get.snackbar('Terjadi kesalahan', '${e.code}');
        }
      } catch (e) {
        Get.snackbar('Terjadi kesalahan', 'Periksa koneksi anda!');
      }
    } else {
      Get.snackbar("Warning", "Harap masukkan password admin!");
    }
  }



  void tambahPegawai() async {
    if (nipC.text.isNotEmpty &&
        namaC.text.isNotEmpty &&
        emailC.text.isNotEmpty) {
      Get.defaultDialog(
          title: "Validasi Admin!",
          content: Column(
            children: [
              Text("Masukan Password untuk validasi admin!"),
              TextField(
                controller: passwordAdmin,
                autocorrect: false,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: "Password", border: OutlineInputBorder()),
              )
            ],
          ),
          actions: [
            OutlinedButton(onPressed: () => Get.back(), child: Text("Cancel")),
            ElevatedButton(
                onPressed: () async {
                  await prosesAddPegawai();
                },
                child: Text("Add Pegawai")),
          ]);
    } else {
      Get.snackbar('Terjadi kesalahan', 'Form tidak boleh kosong');
    }
  }

  }
