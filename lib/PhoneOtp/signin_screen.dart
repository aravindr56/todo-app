import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../components/my_text_fiels.dart';
import 'home_screen.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final TextEditingController mailOrPhoneController = TextEditingController();
  final TextEditingController passOrOtpController = TextEditingController();
  final Logger _logger = Logger();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? _verificationId; // Assuming you have a way to pass or store this

  void _signIn() async {
    String mailOrPhone = mailOrPhoneController.text.trim();
    String passwordOrOtp = passOrOtpController.text.trim();

    if (mailOrPhone.isEmpty || passwordOrOtp.isEmpty) {
      Get.snackbar('Error', 'Email/Phone and password/OTP are required');
      return;
    }

    try {
      if (mailOrPhone.contains('@')) {
        // Email sign-in
        await _auth.signInWithEmailAndPassword(
          email: mailOrPhone,
          password: passwordOrOtp,
        );
      } else {
        // Phone sign-in using OTP as "password"
        if (_verificationId == null) {
          Get.snackbar('Error', 'Verification ID is not available. Please retry the OTP process.');
          return;
        }

        PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: _verificationId!,
          smsCode: passwordOrOtp, // OTP entered by the user
        );

        await _auth.signInWithCredential(credential);
      }

      _logger.i('User signed in successfully');
      Get.offAll(() => HomeScreen()); // Navigate to the home screen
    } on FirebaseAuthException catch (e) {
      _logger.e('Sign-in error: ${e.message}');
      Get.snackbar('Error', e.message ?? 'An error occurred during sign-in');
    } catch (e) {
      _logger.e('Unexpected error: ${e.toString()}');
      Get.snackbar('Error', 'An unexpected error occurred');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign In')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 10),
            MYTextField(text: 'Email/Phone', controller: mailOrPhoneController),
            SizedBox(height: 10),
            MYTextField(text: 'Password/OTP', controller: passOrOtpController,),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signIn,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
