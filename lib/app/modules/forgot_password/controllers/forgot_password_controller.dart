import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presence/app/routes/app_pages.dart';

class ForgotPasswordController extends GetxController {
 
  TextEditingController conEmail = TextEditingController();
   Future<void> sendemail() async {
   FirebaseAuth auth = FirebaseAuth.instance;
  //  String email = await auth.currentUser!.email!;
  //  print(email);
    return await Get.defaultDialog(
        barrierDismissible: false,
        title: "Forgot Password",
        middleText: "Anda melupakan password anda dengan ini anda akan mengubahnya?",
        actions: [
          OutlinedButton(onPressed: () => Get.back(), child: Text("Cancel")),
          ElevatedButton(
              onPressed: () async {
                await auth.sendPasswordResetEmail(email: conEmail.text);
                Get.snackbar("Berhasil",
                    "berhasil silahkan cek email anda untuk mengubah password anda");
                // await FirebaseAuth.instance.signOut();
                // _googleSignIn.signOut();
               return Get.offAllNamed(Routes.LOGIN);
              },
              child: Text("Ya")),
        ]);
  }
}
