import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/new_password_controller.dart';

class NewPasswordView extends GetView<NewPasswordController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Password'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            obscureText: true,
            controller: controller.newPass,
            autocorrect: false,
            decoration: InputDecoration(
              labelText: "New password",
              border: OutlineInputBorder()
            ),
          ),
          ElevatedButton(onPressed: (){
            controller.newPassword();

          }, child: Text("Next"))
        ],

      )
      );
     
  
  }
}
