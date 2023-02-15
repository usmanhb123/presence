import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presence/app/routes/app_pages.dart';

class LoginController extends GetxController {
  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();
  RxBool isLoading = false.obs;

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> login() async {
    isLoading.value = true;
    if (emailC.text.isNotEmpty && passC.text.isNotEmpty) {
      try {
        UserCredential credential = await auth.signInWithEmailAndPassword(
            email: emailC.text, password: passC.text);

        if (credential.user != null) {
          // print(credential);

          isLoading.value = false;
          if (credential.user!.emailVerified == true) {
            isLoading.value = false;
            if (passC.text == "12345678") {
              Get.offAllNamed(Routes.NEW_PASSWORD);
            } else {
              Get.offAllNamed(Routes.HOME);
            }
          } else {
            // print(credential.user!.email);
            Get.defaultDialog(
                title: "Belum Verifikasi",
                middleText: "Kamu belum verifikasi email.",
                actions: [
                  OutlinedButton(
                      onPressed: () {
                        isLoading.value = false;
                        Get.back();
                      },
                      child: Text("Cancel")),
                  ElevatedButton(
                      onPressed: () async {
                        try {
                          await credential.user!.sendEmailVerification();

                          isLoading.value = false;
                          Get.back();
                          Get.snackbar("Berhasil", "Silahkan cek email anda!");
                        } catch (e) {
                          isLoading.value = false;
                          Get.snackbar("Terjadi kesalahan",
                              "tidak dapat mengirim email silahkan hubungi admin atau customer service!");
                        }
                      },
                      child: Text("Kirim Ulang")),
                ]);
          }
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          isLoading.value = false;
          Get.snackbar("Terjadi Kesalahan", "No user found for that email!");
          // print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          isLoading.value = false;
          Get.snackbar(
              "Terjadi Kesalahan", "Wrong password provided for that user!");
          // print('Wrong password provided for that user.');
        }
      }
    } else {
      isLoading.value = false;
      Get.snackbar(
          "Terjadi Kesalahan", "Periksa kembali email dan password anda!");
    }
  }
}
