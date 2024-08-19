import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:todo_app/PhoneOtp/otp_screen.dart';
import 'package:todo_app/PhoneOtp/signin_screen.dart';
import '../PhoneOtp/home_screen.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Logger _logger = Logger();

  // Observable variable to track the loading state
  var isLoading = false.obs;

  String getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'No user found for the email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'The user account has been disabled.';
      case 'too-many-requests':
        return 'Too many requests. Try again later.';
      default:
        return 'An error occurred. Please try again.';
    }
  }


  // Method to handle user registration
  void registerUser({required String emailOrPhone, required String password}) async {
    isLoading.value = true; // Start loading
    try {
      if (emailOrPhone.contains('@')) {
        // Email registration
        await _auth.createUserWithEmailAndPassword(
          email: emailOrPhone,
          password: password,
        ).then((userCredential) {
          _saveUserData(userCredential.user!.uid, emailOrPhone, password);
          _logger.i('User registered successfully with email');
          Get.offAll(() => OtpScreen(isPhoneAuth: false, emailOrPhone: emailOrPhone));
        });
      } else {
        // Phone registration - Send OTP
        await _auth.verifyPhoneNumber(
          phoneNumber: emailOrPhone,
          verificationCompleted: (phoneAuthCredential) async {
            // Auto-retrieve or auto-complete the verification
            await _auth.signInWithCredential(phoneAuthCredential);
            _logger.i('Phone number automatically verified and user signed in');
            Get.offAll(() => SigninScreen());
          },
          verificationFailed: (FirebaseAuthException e) {
            _logger.e('Phone verification failed: ${e.message}');
            Get.defaultDialog(
              title: 'Error',
              content: Text(getErrorMessage(e.code)),
              onConfirm: () => Get.back(),
              textConfirm: 'OK',
            );
            isLoading.value = false; // Stop loading on error
          },
          codeSent: (verificationId, resendToken) {
            // Navigate to the OTP screen
            isLoading.value = false; // Stop loading before navigating
            Get.to(() => OtpScreen(
              verificationId: verificationId,
              emailOrPhone: emailOrPhone,
              isPhoneAuth: true,
            ));
          },
          codeAutoRetrievalTimeout: (verificationId) {},
        );
      }
    } on FirebaseAuthException catch (e) {
      _logger.e('Registration error: ${e.message}');
      Get.defaultDialog(
        title: 'Error',
        content: Text(getErrorMessage(e.code)),
        onConfirm: () => Get.back(),
        textConfirm: 'OK',
      );
      isLoading.value = false; // Stop loading on error
    } catch (e) {
      _logger.e('Unexpected error: ${e.toString()}');
      Get.defaultDialog(
        title: 'Error',
        content: Text('An unexpected error occurred'),
        onConfirm: () => Get.back(),
        textConfirm: 'OK',
      );
      isLoading.value = false; // Stop loading on error
    }
  }


  // Method to save user data to Firestore
  void _saveUserData(String uid, String emailOrPhone, String password) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'emailOrPhone': emailOrPhone,
        'password': password,
      });
      _logger.i('User data saved to Firestore');
    } catch (e) {
      _logger.e('Error saving user data: ${e.toString()}');
      Get.snackbar('Error', 'An error occurred while saving user data');
    }
  }

  // Method to handle user login
  void loginUser({required String emailOrPhone, required String password}) async {
    try {
      if (emailOrPhone.contains('@')) {
        // Email login
        await _auth.signInWithEmailAndPassword(
          email: emailOrPhone,
          password: password,
        );
        _logger.i('User logged in successfully with email');
        Get.offAll(() => HomeScreen()); // Navigate to home screen on successful login
      } else {
        // Phone login - fetch the stored password from Firestore and compare
        var userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(emailOrPhone)
            .get();

        if (userDoc.exists) {
          String storedPassword = userDoc['password'];
          if (storedPassword == password) {
            _logger.i('User logged in successfully with phone');
            Get.offAll(() => HomeScreen()); // Navigate to home screen on successful login
          } else {
            Get.defaultDialog(
              title: 'Error',
              content: Text('Incorrect password'),
              onConfirm: () => Get.back(),
              textConfirm: 'OK',
            );
          }
        } else {
          Get.defaultDialog(
            title: 'Error',
            content: Text('User not found'),
            onConfirm: () => Get.back(),
            textConfirm: 'OK',
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      _logger.e('Login error: ${e.message}');
      Get.defaultDialog(
        title: 'Error',
        content: Text(getErrorMessage(e.code)),
        onConfirm: () => Get.back(),
        textConfirm: 'OK',
      );
    } catch (e) {
      _logger.e('Unexpected error: ${e.toString()}');
      Get.defaultDialog(
        title: 'Error',
        content: Text('An unexpected error occurred'),
        onConfirm: () => Get.back(),
        textConfirm: 'OK',
      );
    }
  }


}





