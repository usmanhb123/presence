import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:presence/app/routes/app_pages.dart';

class AuthController extends GetxController {
  
  FirebaseAuth auth = FirebaseAuth.instance;
  var isAuth = false.obs;

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
        // print('login google');
        // print(_currentUser!.email);

        final googleAuth = await _currentUser!.authentication;

        final credential = GoogleAuthProvider.credential(
            idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

        final userCredential =
            FirebaseAuth.instance.signInWithCredential(credential);
        CollectionReference users =
            FirebaseFirestore.instance.collection('user_vermuk');
        final cek_vermuk = await users.doc(_currentUser!.email).get();
        // print('User vermuk');
        // print(cek_vermuk.data());
        if (cek_vermuk.data() == null) {
          // final userlogin = FirebaseAuth.instance.currentUser;
          // await _googleSignIn.disconnect();
          // await _googleSignIn.signOut();
          // await _currentUser!.clearAuthCache();
          // await FirebaseAuth.instance.signOut();
          await auth.signOut();
          print("userlogin"); 
          print("userlogin"); 
          Get.snackbar("login failed", "Unregistered account");
          logout();
        } else {
          // print(" --------------------vermuk ----------------------------");
          // var statusvermuk = cek_vermuk['status'];
          // print(statusvermuk);
          isAuth.value = true;
          if(cek_vermuk['status'] == 0){
            Get.snackbar("Register faces", "If you haven't registered your face yet, please register first");
            Get.offAllNamed(Routes.REGISTER_FACE);
          }else{
             Get.offAllNamed(Routes. HOME);
          }
        }
      } else {
        print('login failed');
      }

      // print(_currentUser);
    } catch (error) {
      print(error);
    }
  }

  
  Future logout() async {
    // print("fungsi logout");
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    Get.offAllNamed(Routes.LOGIN);
  }
}
