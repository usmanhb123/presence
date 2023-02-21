import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:presence/app/routes/app_pages.dart';


class AuthController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  var isAuth = false.obs;
  UserCredential? _userCredential;
  GoogleSignIn _googleSignIn = GoogleSignIn();

  // ignore: unused_field
  GoogleSignInAccount? _currentUser;

  Future<void> login() async {
    try {
      await _googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();
      await _googleSignIn.signIn().then((value) => _currentUser = value);

      final isSignin = await _googleSignIn.isSignedIn();
      if (isSignin) {
        final googleAuth = await _currentUser!.authentication;

        final credential = await GoogleAuthProvider.credential(
            idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

        final userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        CollectionReference users =
            await FirebaseFirestore.instance.collection('pegawai_cek');
        final cek_vermuk = await users.doc(_currentUser!.email).get();
        if (cek_vermuk.data() == null) {
          await Get.defaultDialog(
              barrierDismissible: false,
              title: "Login Gagal",
              middleText: "Akun kamu tidak terdaftar silahkan hubungi admin!",
              actions: [
                ElevatedButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      await _googleSignIn.signOut();
                      Get.back();
                    },
                    child: Text("OK")),
              ]);
        } else {
          return Get.offAllNamed(Routes.HOME);
        }
        // }
      } else {
        Get.snackbar("Login Gagal",
            "Terjadi kesalahan saat login menggunakan google acount silahkan login menggunakan email password atau hubungi admin");
        print('login failed');
      }

      // print(_currentUser);
    } catch (error) {
      print(error);
    }
  }

  Future logout() async {
    await FirebaseAuth.instance.signOut();
    _googleSignIn.signOut();
    return Get.offAllNamed(Routes.LOGIN);
  }

  Future<void> resetPassword() async {
   FirebaseAuth auth = FirebaseAuth.instance;
   String email = await auth.currentUser!.email!;
  //  print(email);
    return await Get.defaultDialog(
        barrierDismissible: false,
        title: "Change Password",
        middleText: "Kamu akan mengubah password? anda akan logout!",
        actions: [
          OutlinedButton(onPressed: () => Get.back(), child: Text("Cancel")),
          ElevatedButton(
              onPressed: () async {
                await auth.sendPasswordResetEmail(email: email);
                Get.snackbar("Berhasil",
                    "Change password berhasil silahkan cek email anda untuk mengubah password anda");
                await FirebaseAuth.instance.signOut();
                // _googleSignIn.signOut();
               return Get.offAllNamed(Routes.LOGIN);
              },
              child: Text("Ya")),
        ]);
  }
}
