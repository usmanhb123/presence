import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.all(20),
            children: [
              Image.asset(
                'assets/lottiefiles/page-login.gif',
                height: Get.height * 0.3,
              ),
              SizedBox(height: 20),
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
              ElevatedButton(
                  onPressed: () {
                    controller.login();
                  },
                  child: Text("Login")),
              TextButton(onPressed: () {}, child: Text("Forgot Passowrd?")),
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
                onPressed: () => {},
                label: const Text("Sign In With Google"),
                icon: const Icon(
                  FontAwesomeIcons.google,
                  size: 25,
                ),
              ),
            ],
          ),
        ));
  }
}
