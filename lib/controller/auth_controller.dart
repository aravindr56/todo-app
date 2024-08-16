import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../PhoneOtp/otp_screen.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Logger _logger = Logger();

  // Method to validate fields and register user
  Future<void> registerUser({required String emailOrPhone, required String password}) async {
    if (emailOrPhone.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'All fields are required');
      return;
    }

    try {
      if (isEmail(emailOrPhone)) {
        // Email Registration
        await _registerWithEmail(emailOrPhone, password);
      } else {
        // Phone Registration
        await _registerWithPhone(emailOrPhone);
      }
    } on FirebaseAuthException catch (e) {
      _logger.e(e.message);
      Get.snackbar('Error', e.message ?? 'Unknown error occurred');
    } catch (e) {
      _logger.e(e.toString());
      Get.snackbar('Error', 'An unknown error occurred');
    }
  }

  bool isEmail(String emailOrPhone) {
    return emailOrPhone.contains('@');
  }

  Future<void> _registerWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _logger.i('User registered with email: ${userCredential.user?.email}');
      // Proceed to OTP screen or next step if needed
      Get.to(() => OtpScreen());
    } on FirebaseAuthException catch (e) {
      _logger.e('Email registration error: ${e.message}');
      Get.snackbar('Error', e.message ?? 'An error occurred during email registration');
    }
  }

  Future<void> _registerWithPhone(String phoneNumber) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Automatically sign in the user on verification completed
          await _auth.signInWithCredential(credential);
          _logger.i('Phone number verified and user signed in automatically.');
        },
        verificationFailed: (FirebaseAuthException e) {
          _logger.e('Phone verification failed: ${e.message}');
          Get.snackbar('Error', e.message ?? 'An error occurred during phone verification');
        },
        codeSent: (String verificationId, int? resendToken) {
          _logger.i('OTP sent successfully. Navigating to OTP Screen with verificationId: $verificationId');
          // Navigate to OTP screen with the verificationId
          Get.to(() => OtpScreen(), arguments: verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _logger.w('Code auto-retrieval timeout.');
        },
      );
    } on FirebaseAuthException catch (e) {
      _logger.e('Phone registration error: ${e.message}');
      Get.snackbar('Error', e.message ?? 'An error occurred during phone registration');
    }
  }
}


