import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/forgot_password_controller.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
        centerTitle: true,
      ),
      body: Center(
        child:  ListView(
        padding: EdgeInsets.all(20),
        children: [
         TextField(
           
            controller: controller.conEmail,
            autocorrect: false,
            decoration: InputDecoration(
              labelText: "Email",
              border: OutlineInputBorder()
            ),
          ),
          SizedBox(height: 10,),
           Text("Isi dengan email anda untuk mengirim link pengubahan password ke email anda!"),

          
          SizedBox(height: 20,),
          ElevatedButton(onPressed: (){
            controller.sendemail();

          }, child: Text("Next"))
        ],

      )
      ),
    );
  }
}
