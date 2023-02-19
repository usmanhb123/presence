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
        try {
          await auth.currentUser!.updatePassword(newPass.text);
          String email = auth.currentUser!.email!;

          await auth.signOut();

          await FirebaseAuth.instance.signOut();
          Get.snackbar(
              "Berhasil", "Password berhasil diubah silahkan login kembali.");
          Get.offAllNamed(Routes.LOGIN);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            Get.snackbar("Terjadi kesalahan",
                "Password terlalu lemah setidaknya 6 Karakter.");
          }
        } catch (e) {
          Get.snackbar("Terjadi kesalahan",
              "Tidak dapat membuat password baru silahkan hubungi admin!");
        }
      } else {
        Get.snackbar("Terjadi Kesalahan",
            "Password tidak boleh sama dengan password sebelumnya!");
      }
    } else {
      Get.snackbar("Terjadi Kesalahan", "Password tidak boleh Kosong!");
    }
  }
}
