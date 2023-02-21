import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:presence/app/controllers/page_index_controller.dart';
// import 'package:presence/app/data/controllers/authController.dart';

import 'app/data/controllers/authController.dart';
import 'app/routes/app_pages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  // final authC = Get.put(AuthController(), permanent: true);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final authC = Get.put(AuthController());
  final pageC = Get.put(PageIndexController(), permanent: true);
  runApp(StreamBuilder<User?>(
    stream: FirebaseAuth.instance.authStateChanges(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return MaterialApp(
          title: "Loading",
          home: Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.black,
                value: 0.20,
              ),
            ),
          ),
        );
      }
      if (snapshot.data != null) {
        // print(snapshot.data!.uid);
        // print(snapshot.data);
        
        print('udah logn');
      } else {
        print('blum logn');
      }
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Application",
        initialRoute: 
        snapshot.data != null ? Routes.HOME : Routes.LOGIN,
        getPages: AppPages.routes,
      );
    },
  ));
}
