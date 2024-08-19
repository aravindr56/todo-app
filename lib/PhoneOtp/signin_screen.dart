import 'package:cloud_firestore/cloud_firestore.dart';
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
  bool isLoading = false;

  String? _verificationId; // Assuming you have a way to pass or store this

  void _signIn() async {
    setState(() {
      isLoading = true;
    });

    String mailOrPhone = mailOrPhoneController.text.trim();
    String password = passOrOtpController.text.trim();

    if (mailOrPhone.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Email/Phone and password are required');
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      if (mailOrPhone.contains('@')) {
        // Email sign-in
        await _auth.signInWithEmailAndPassword(
          email: mailOrPhone,
          password: password,
        );
      } else {
        // Phone sign-in
        // Assuming you have a method to fetch user details from Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(mailOrPhone)
            .get();

        if (userDoc.exists) {
          String storedPassword = userDoc['password'];
          if (storedPassword == password) {
            // Phone authentication using custom verification
            _logger.i('User signed in successfully');
            Get.offAll(() => HomeScreen()); // Navigate to the home screen
          } else {
            Get.snackbar('Error', 'Incorrect password');
          }
        } else {
          Get.snackbar('Error', 'User not found');
        }
      }
    } on FirebaseAuthException catch (e) {
      _logger.e('Sign-in error: ${e.message}');
      Get.snackbar('Error', e.message ?? 'An error occurred during sign-in');
    } catch (e) {
      _logger.e('Unexpected error: ${e.toString()}');
      Get.snackbar('Error', 'An unexpected error occurred');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign In')),
      body: Stack(
        children: [
          Padding(
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
          if (isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}

