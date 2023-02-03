import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      return GetMaterialApp(
        title: "Application",
        // ignore: unnecessary_null_comparison
        initialRoute: snapshot.data == null ? Routes.LOGIN : Routes.HOME,
        getPages: AppPages.routes,
      );
    },
  ));
}
