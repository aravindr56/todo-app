import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:todo_app/PhoneOtp/signin_screen.dart';

class OtpScreen extends StatefulWidget {
  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  final Logger _logger = Logger();

  String? _verificationId;
  bool _isResending = false;

  @override
  void initState() {
    super.initState();
    _verificationId = Get.arguments;
  }

  void _verifyOtp() async {
    String otp = _otpController.text.trim();
    if (otp.isEmpty || _verificationId == null) {
      Get.snackbar('Error', 'Please enter the OTP');
      return;
    }

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );

      await FirebaseAuth.instance.signInWithCredential(credential).then((userCredential) {
        _logger.i('User signed in successfully with OTP');
        Get.offAll(() => SigninScreen()); // Navigate to the sign-in screen
      }).catchError((error) {
        _logger.e('Error during sign-in: $error');
        Get.snackbar('Error', 'An error occurred during sign-in');
      });

    } on FirebaseAuthException catch (e) {
      if (e.code == 'session-expired') {
        _logger.e('Session expired: ${e.message}');
        Get.snackbar('Error', 'The SMS code has expired. Please resend the verification code to try again.');
      } else {
        _logger.e('OTP verification failed: ${e.message}');
        Get.snackbar('Error', e.message ?? 'An error occurred during OTP verification');
      }
    }
  }

  void _resendOtp() async {
    setState(() {
      _isResending = true;
    });

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: 'YOUR_PHONE_NUMBER', // Pass the user's phone number here
        verificationCompleted: (PhoneAuthCredential credential) {
          _logger.i('Phone verification completed automatically.');
        },
        verificationFailed: (FirebaseAuthException e) {
          _logger.e('Phone verification failed: ${e.message}');
          Get.snackbar('Error', e.message ?? 'An error occurred during phone verification');
        },
        codeSent: (String verificationId, int? resendToken) {
          _logger.i('OTP sent successfully. Navigating to OTP Screen with verificationId: $verificationId');
          setState(() {
            _verificationId = verificationId;
          });
          Get.snackbar('Success', 'OTP has been resent successfully');
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _logger.w('Code auto-retrieval timeout.');
        },
      );
    } catch (e) {
      _logger.e('Failed to resend OTP: $e');
      Get.snackbar('Error', 'Failed to resend OTP');
    } finally {
      setState(() {
        _isResending = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Enter OTP')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            PinCodeTextField(
              controller: _otpController,
              appContext: context,
              length: 6,
              onChanged: (value) {},
              keyboardType: TextInputType.number,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(5),
                fieldHeight: 50,
                fieldWidth: 40,
                activeFillColor: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _verifyOtp,
              child: Text('Verify OTP'),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: _isResending ? null : _resendOtp,
              child: _isResending
                  ? CircularProgressIndicator()
                  : Text('Resend OTP'),
            ),
          ],
        ),
      ),
    );
  }
}






