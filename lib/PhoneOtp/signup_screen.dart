import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../components/my_button.dart';

import '../components/my_text_fiels.dart';
import '../controller/auth_controller.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController name = TextEditingController();
  final TextEditingController phoneOrEmail = TextEditingController();
  final TextEditingController password = TextEditingController();

  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 10,),
            MYTextField(
              text: 'Username',
              controller: name,

            ),
            SizedBox(height: 10,),
            MYTextField(
              text: 'Email/Phone no',
              controller: phoneOrEmail,
            ),
            SizedBox(height: 10,),
            MYTextField(
              text: 'Password',
              controller: password,
              // obscureText: true,
            ),
            SizedBox(height: 20),
            MYButton(
              text: 'Register',
              onPressed: () {
                authController.registerUser(
                  emailOrPhone: phoneOrEmail.text.trim(),
                  password: password.text.trim(),
                );
              },
              fixedSize: Size(200, 30), color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}


