import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signin_screen.dart';

class OtpScreen extends StatefulWidget {
  final bool isPhoneAuth;
  final String emailOrPhone;
  final String? verificationId;

  OtpScreen({
    required this.isPhoneAuth,
    required this.emailOrPhone,
    this.verificationId,
  });

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController otpController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OTP Verification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Verify ${widget.isPhoneAuth ? 'Phone' : 'Email'}'),
                SizedBox(height: 20),
                Text('Please enter the OTP sent to ${widget.emailOrPhone}'),
                SizedBox(height: 20),
                PinCodeTextField(
                  length: 6,
                  obscureText: false,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 50,
                    fieldWidth: 40,
                    activeFillColor: Colors.white,
                  ),
                  controller: otpController,
                  onChanged: (value) {},
                  appContext: context,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _verifyOtp();
                  },
                  child: Text('Verify OTP'),
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    if (widget.isPhoneAuth && widget.verificationId != null) {
                      _resendOtp();
                    }
                  },
                  child: Text('Resend OTP'),
                ),
              ],
            ),
            if (isLoading)
              Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }

  void _verifyOtp() async {
    setState(() {
      isLoading = true;
    });

    try {
      final authCredential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId!,
        smsCode: otpController.text.trim(),
      );

      await _auth.signInWithCredential(authCredential);

      Get.offAll(() => SigninScreen());
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message ?? 'Invalid OTP');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _resendOtp() {
    _auth.verifyPhoneNumber(
      phoneNumber: widget.emailOrPhone,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        Get.snackbar('Error', e.message ?? 'Failed to send OTP');
      },
      codeSent: (String verificationId, int? resendToken) {
        Get.snackbar('Success', 'OTP has been resent');
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }
}










