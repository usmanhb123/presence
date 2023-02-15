import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:presence/app/data/controllers/authController.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  final authC = Get.put(AuthController(), permanent: true);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            return loginMobilePhone();
          } else {
            return LoginTablet();
          }
        },
      ),
    );
  }




  LoginTablet() {
    return Row(
      children: [
        Expanded(
            //<-- Expanded widget
            child: Image.asset(
          'assets/lottiefiles/page-login.gif',
          height: Get.height * 0.7,
        )),
        Expanded(
          //<-- Expanded widget
          child: Container(
            constraints: const BoxConstraints(maxWidth: 21),
            padding: const EdgeInsets.symmetric(horizontal: 150),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Welcome back',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Login to your account',
                ),
                const SizedBox(height: 35),
                TextField(
                  autocorrect: false,
                  controller: controller.emailC,
                  decoration: InputDecoration(
                      labelText: "Email", border: OutlineInputBorder()),
                ),
                SizedBox(height: 20),
                TextField(
                  autocorrect: false,
                  controller: controller.passC,
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: "Password", border: OutlineInputBorder()),
                ),
                SizedBox(height: 20),
                Obx(() => ElevatedButton(
                    onPressed: () async {
                      if (controller.isLoading.isFalse) {
                        await controller.login();
                      }
                    },
                    child: Text(controller.isLoading.isFalse
                        ? "Login"
                        : "Loading..."))),
                        
                SizedBox(height: 20),
                TextButton(onPressed: () {}, child: Text("Forgot Password?")),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                        child: Divider(
                      endIndent: 12,
                    )),
                    Text("Or with", style: TextStyle(color: Colors.blue)),
                    Expanded(
                        child: Divider(
                      indent: 12,
                    ))
                  ],
                ),
                SizedBox(height: 20),
                FloatingActionButton.extended(
                  onPressed: () async {
                    if (controller.isLoading.isFalse) {
                      await authC.login();
                    }
                  },
                  label: const Text("Sign In With Google"),
                  icon: const Icon(
                    FontAwesomeIcons.google,
                    size: 25,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }





  loginMobilePhone() {
    return SafeArea(
      child: ListView(
        padding: EdgeInsets.all(20),
        children: [
          // Text("Presence"),
          Image.asset(
            'assets/lottiefiles/page-login.gif',
            height: Get.height * 0.4,
          ),
          SizedBox(height: 20),
          // Container(
          //    padding: const EdgeInsets.symmetric(horizontal: 150),
          //    child: Column(
          //     children: [
                
          //     ],
          //    ),
          // )
          TextField(
            autocorrect: false,
            controller: controller.emailC,
            decoration: InputDecoration(
                labelText: "Email", border: OutlineInputBorder()),
          ),
          SizedBox(height: 20),
          TextField(
            autocorrect: false,
            controller: controller.passC,
            obscureText: true,
            decoration: InputDecoration(
                labelText: "Password", border: OutlineInputBorder()),
          ),
          SizedBox(height: 20),
          Obx(() => ElevatedButton(
              onPressed: () async {
                if (controller.isLoading.isFalse) {
                  await controller.login();
                }
              },
              child:
                  Text(controller.isLoading.isFalse ? "Login" : "Loading..."))),
          TextButton(onPressed: () {}, child: Text("Forgot Password?")),
          Row(
            children: [
              Expanded(
                  child: Divider(
                endIndent: 12,
              )),
              Text("Or with", style: TextStyle(color: Colors.blue)),
              Expanded(
                  child: Divider(
                indent: 12,
              ))
            ],
          ),

          SizedBox(height: 20),
          FloatingActionButton.extended(
            onPressed: () async {
              if (controller.isLoading.isFalse) {
                await authC.login();
              }
            },
            label: const Text("Sign In With Google"),
            icon: const Icon(
              FontAwesomeIcons.google,
              size: 25,
            ),
          ),
        ],
      ),
    );
  }
}
