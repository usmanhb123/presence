import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presence/app/routes/app_pages.dart';

class NewPasswordController extends GetxController {
  TextEditingController newPass = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  void newPassword() async {
    if (newPass.text.isNotEmpty) {
      if (newPass.text != "12345678") {
        await auth.currentUser!.updatePassword(newPass.text);
        String email = auth.currentUser!.email!;

        await auth.signOut();

        await FirebaseAuth.instance.signOut();
        Get.snackbar(
            "Berhasil", "Password berhasil diubah silahkan login kembali.");
        Get.offAllNamed(Routes.LOGIN);
      } else {
        Get.snackbar("Terjadi Kesalahan",
            "Password tidak boleh sama dengan password sebelumnya!");
      }
    } else {
      Get.snackbar("Terjadi Kesalahan", "Password tidak boleh Kosong!");
    }
  }
}
